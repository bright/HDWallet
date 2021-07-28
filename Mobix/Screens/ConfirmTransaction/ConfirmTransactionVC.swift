// 

import UIKit
import ActivityIndicator
import BigInt
import Combine

class ConfirmTransactionVC: UIViewController, MTSlideToOpenDelegate {
    private let mainView = ConfirmTransactionView()
    private let cosmos: Cosmos
    private let transactionInfo: TransactionInfo
    private let walletBalanceTracker: WalletBalanceTracker
    private let currencyInfo: CurrencyInfo
    var onScanAnotherCode: (()->())?
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
        mainView.bottomButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
    }

    func mtSlideToOpenDelegateDidFinish(_ sender: MTSlideToOpenView) {
//        if let passcode = PasscodeRepository.shared.fetchPasscode() {
//            commitTransaction(passcode: passcode)
//            mainView.slider.resetStateWithAnimation(true)
//        } else {
//        requirePasscode()
        
//        }
        
        commitTransaction()
    }
    
    private func commitTransaction(osSuccess: (()->())? = nil) {
        Loader.shared.start()
        cosmos.fetchAuth()
            .flatMap{ [unowned self] auth in
                self.cosmos.onBroadcastTx(auth: auth)
            }
            .sink { (_) in
                Loader.shared.stop()
            } receiveValue: { (data) in
                print(String(data: data, encoding: .utf8))
            }.store(in: &publishers)

        //passcode is requred to unlock the keystore
//        web3Client.transfer(amount: transactionInfo.amountOfTokens!, toAddressString: transactionInfo.address, password: passcode) { [unowned self] result in
//            switch result {
//            case .success():
//                Loader.shared.stop()
//                self.walletBalanceTracker.updateWalletBalance()
//                self.setUpForConfirmed()
//                osSuccess?()
//            case .failure(let error):
//                print(error)
//                AlertPresenter.present(message: error.localizedDescription, type: .error)
//                Loader.shared.stop()
//            }
//        }
    }
    
    private func setUpForConfirmed() {
        self.mainView.configureConfirmed(with: self.makeViewModelForTransactionConfirmed())
        mainView.doneButton.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        mainView.bottomButton.removeTarget(nil, action: nil, for: .allEvents)
        mainView.bottomButton.addTarget(self, action: #selector(scanAnotherCodeAction), for: .touchUpInside)
    }
    
    @objc func doneAction() {
        onDone?()
    }
    
    @objc func cancelAction() {
        onCancell?()
    }
    
    @objc func scanAnotherCodeAction() {
        onScanAnotherCode?()
    }
    
    private func makeViewModelForTransactionToConfirm() -> ConfirmTransactionViewModel {
        let image = UIImage(named: "transaction_to_confirm")
        let amount = "Utils.formatToEthereumUnits(transactionInfo.amountOfTokens!)!"
        let token = currencyInfo.symbol
        let currentBalance = walletBalanceTracker.balance!
        let newBalance = currentBalance - transactionInfo.amountOfTokens!
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
