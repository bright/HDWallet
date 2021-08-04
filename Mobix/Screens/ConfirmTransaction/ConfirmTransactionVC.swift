// 

import UIKit
import ActivityIndicator
import BigInt
import Combine

class ConfirmTransactionVC: UIViewController, MTSlideToOpenDelegate {
    private let mainView = ConfirmTransactionView()
    private let cosmos: Cosmos
    private var transactionInfo: TransactionInfo
    private let walletBalanceTracker: WalletBalanceTracker
    private let currencyInfo: CurrencyInfo
    var onDone: (()->())?
    var onCancell: (()->())?
    private var publishers = [AnyCancellable]()

    init(_ transaction: TransactionInfo,
         currencyInfo: CurrencyInfo,
         cosmos: Cosmos,
         walletBalanceTracker: WalletBalanceTracker) {
        self.cosmos = cosmos
        self.currencyInfo = currencyInfo
        self.walletBalanceTracker = walletBalanceTracker
        self.transactionInfo = transaction
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFullscreenView(mainView: mainView)
        mainView.slider.delegate = self
        mainView.configureToConfirm(with: makeViewModelForTransactionToConfirm())
    }

    func mtSlideToOpenDelegateDidFinish(_ sender: MTSlideToOpenView) {
        commitTransaction()
        mainView.slider.resetStateWithAnimation(true)
    }
    
    private func commitTransaction(osSuccess: (()->())? = nil) {
        Loader.shared.start()
        transactionInfo.fee = Fee("200000", [Coin(denom: "atestfet", amount: "0")])
        cosmos.fetchAuth()
            .flatMap{ [unowned self] auth in
                self.cosmos.onBroadcastTx(auth: auth, transactionInfo: transactionInfo)
            }
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] (_) in
                Loader.shared.stop()
                self.setUpForConfirmed()
            } receiveValue: { (data) in
                print(String(data: data, encoding: .utf8))
            }.store(in: &publishers)
    }
    
    private func setUpForConfirmed() {
        self.mainView.configureConfirmed(with: self.makeViewModelForTransactionConfirmed())
        mainView.doneButton.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
    }
    
    @objc func doneAction() {
        onDone?()
    }
    
    @objc func cancelAction() {
        onCancell?()
    }
    
    private func makeViewModelForTransactionToConfirm() -> ConfirmTransactionViewModel {
        let image = UIImage(named: "transaction_to_confirm")
        let amount = "Utils.formatToEthereumUnits(transactionInfo.amountOfTokens!)!"
        let token = currencyInfo.symbol
        let currentBalance = walletBalanceTracker.balance!
        let newBalance = currentBalance - transactionInfo.coin!.amount
        let newBalanceFormatted = "Utils.formatToEthereumUnits(newBalance)!"
        var transactionCostDescription: String = ""
//        if let transactionCost = calculateTransactionCost(),
//           let transactionCostString = Utils.formatToEthereumUnits(BigUInt(transactionCost)) {
//            transactionCostDescription = String.localizedStringWithFormat("transaction_fee".localized, transactionCostString)
//        } else {
//            transactionCostDescription = "failed_to_calculate".localized
//        }
        let description = String.localizedStringWithFormat("transaction_to_confirm".localized, amount, token, newBalanceFormatted)
        return ConfirmTransactionViewModel(image: image, amount: amount, token: token, description: description, transactionCostDescription: transactionCostDescription, bottomButtonText: "cancel".localized)
    }
    
//    private func calculateTransactionCost() -> BigUInt? {
//        let estimatedTransferCostInGas = BigUInt(web3Client.token.estimatedTransferCostInGas)
//        do {
//            let estimatedGasPrice = try web3Client.getGasPrice()
//            print("estimated gas price is: \(estimatedGasPrice)")
//            print("estimated transaction cost: \(estimatedTransferCostInGas * estimatedGasPrice)")
//            return estimatedTransferCostInGas * estimatedGasPrice
//        } catch {
//            AlertPresenter.present(message: error.localizedDescription, type: .error)
//            return nil
//        }
//    }
    
    private func makeViewModelForTransactionConfirmed() -> ConfirmTransactionViewModel {
        let image = UIImage(named: "transaction_confirmed")
        let amount = "Utils.formatToEthereumUnits(transactionInfo.amountOfTokens!)!"
        let token = currencyInfo.symbol
        return ConfirmTransactionViewModel(image: image, amount: amount, token: token, description: nil, transactionCostDescription: nil, bottomButtonText: "scan_another_code".localized)
    }
}
