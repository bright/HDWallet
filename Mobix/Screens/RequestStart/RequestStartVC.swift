// 

import UIKit

class RequestStartVC: UIViewController {
    let mainView = RequestStartView()
    let transaction: TransactionInfo
    var onSetAmount: ((TransactionInfo)->())?
    var onScaleUp: ((TransactionInfo)->())?
    var onDisappeared: (()->())?
    private let currencyInfo: CurrencyInfo
    
    init(currencyInfo: CurrencyInfo, address: String) {
        self.currencyInfo = currencyInfo
        let address = address
        self.transaction = TransactionInfo(coin: nil, address: address)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.QRImageView.image = generateQRCode(from: transaction)
        mainView.amountButton.addTarget(self, action: #selector(setAmountTap), for: .touchUpInside)
        mainView.scaleUpButton.addTarget(self, action: #selector(scaleUpTap), for: .touchUpInside)
        mainView.shareButton.addTarget(self, action: #selector(shareWalletAddress), for: .touchUpInside)
        setUpFullscreenView(mainView: mainView)
        mainView.configure(with: currencyInfo)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isMovingFromParent {
            onDisappeared?()
        }
    }
    
    private func generateQRCode(from transaction: TransactionInfo) -> UIImage? {
        TransactionQRCodeGenerator.generateQRCode(for: transaction)
    }
    
    @objc func setAmountTap() {
        onSetAmount?(transaction)
    }
    
    @objc func scaleUpTap() {
        onScaleUp?(transaction)
    }
    
    @objc func shareWalletAddress() {
        let activityViewController = UIActivityViewController(activityItems: [transaction.toAddress], applicationActivities: nil)
           self.present(activityViewController, animated: true, completion: nil)
    }
}
