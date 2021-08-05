
import Foundation
import AVFoundation
import UIKit

class ScannerVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    var onEnterManually: (()->())?
    var onTransactionWithAmount: ((TransactionInfo)->())?
    var onTransactionWithoutAmount: ((TransactionInfo)->())?
    private let mainView = ScannerView()
    let currencyInfo: CurrencyInfo
    
    init(currencyInfo: CurrencyInfo) {
        self.currencyInfo = currencyInfo
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .black

        mainView.configure(with: currencyInfo)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        #if targetEnvironment(simulator)
        view.backgroundColor = UIColor.red
        #else
        setUpScanner()
        #endif
        setUpFullscreenView(mainView: mainView)
        mainView.enterWalletIdManuallyButton.addTarget(self, action: #selector(enterManuallyAction), for: .touchUpInside)
    }
    
    @objc func enterManuallyAction() {
        onEnterManually?()
    }
    
    private func setUpScanner() {
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }

    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }

        dismiss(animated: true)
    }

    func found(code: String) {
        guard let data = code.data(using: .utf8) else {return}
        do {
            let transaction = try JSONDecoder().decode(TransactionInfo.self, from: data)
            if transaction.coin == nil {
                onTransactionWithoutAmount?(transaction)
            } else {
                onTransactionWithAmount?(transaction)
            }
        } catch {
            print(error)
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
