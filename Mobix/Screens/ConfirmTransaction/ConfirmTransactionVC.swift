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
        let amount = Utils.formatToMobixUnits(transactionInfo.coin!.amount)!
        let token = currencyInfo.symbol
        let description = String.localizedStringWithFormat("transaction_to_confirm".localized, amount, token)
        return ConfirmTransactionViewModel(title: "confirm_to_send".localized, image: image, amount: amount, token: token, description: description, bottomButtonText: "cancel".localized)
    }

    private func makeViewModelForTransactionConfirmed() -> ConfirmTransactionViewModel {
        let image = UIImage(named: "transaction_confirmed")
        let description = String.localizedStringWithFormat("transaction_id".localized, "transaction_id")
        let amount = Utils.formatToMobixUnits(transactionInfo.coin!.amount)!
        let token = currencyInfo.symbol
        return ConfirmTransactionViewModel(title: "you_have_sent".localized, image: image, amount: amount, token: token, description: description, bottomButtonText: "scan_another_code".localized)
    }
}
