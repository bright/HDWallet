// 

import UIKit

class QRCodeZoomVC: UIViewController {
    let mainView = QRCodeZoomView()
    
    init(transaction: TransactionInfo) {
        super.init(nibName: nil, bundle: nil)
        mainView.qrImageView.image = TransactionQRCodeGenerator.generateQRCode(for: transaction, scale: 8)
        mainView.closeButton.addTarget(self, action: #selector(closeButtonTap), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFullscreenView(mainView: mainView)
    }
    
    @objc func closeButtonTap() {
        dismiss(animated: true, completion: nil)
    }
}
