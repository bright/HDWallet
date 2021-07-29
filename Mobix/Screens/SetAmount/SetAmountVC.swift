// 

import UIKit
import BigInt

enum TransferType {
    case receive
    case send
}

class SetAmountVC: UIViewController {
    var onContinue: ((TransactionInfo)->())?
    var transactionInfo: TransactionInfo
    private let walletBalanceTracker: WalletBalanceTracker
    private let mainView = SetAmountView()
    private let currencyInfo: CurrencyInfo
    private let amountValidator: AmountValidator
    private let transferType: TransferType

    init(transaction: TransactionInfo,
         walletBalanceTracker: WalletBalanceTracker,
         currencyInfo: CurrencyInfo,
         amountValidator: AmountValidator,
         transferType: TransferType) {
        self.transactionInfo = transaction
        self.amountValidator = amountValidator
        self.transferType = transferType
        self.currencyInfo = currencyInfo
        self.walletBalanceTracker = walletBalanceTracker
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        #if DEBUG
        mainView.textField.text = "0"
        mainView.continueButton.isEnabled = true
        #endif
        mainView.configure(with: makeDetailText())
        setUpFullscreenView(mainView: mainView)
        mainView.continueButton.addTarget(self, action: #selector(continueButtonAction), for: .touchUpInside)
        mainView.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        amountValidator.checkIfValidAmount(textField.text ?? "") ? mainView.setEnabledButton() : mainView.setDisabledButton()
    }

    @objc func continueButtonAction() {
        guard let amountText = mainView.textField.text,
              let amount =  Utils.parseToBigUInt(amountText, decimals: 9) else {return}
        transactionInfo.coin = Coin(denom: "nanomobx", amount: amount)
        onContinue?(transactionInfo)
    }
    
    private func makeDetailText() -> String {
        switch transferType {
        case .receive:
            return String.localizedStringWithFormat("set_amount_details_receive".localized, currencyInfo.symbol)
        case .send:
            return String.localizedStringWithFormat("set_amount_details_send".localized, currencyInfo.symbol)
        }
    }
}

