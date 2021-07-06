// 

import UIKit

class EnterAddressVC: UIViewController {
    private let mainView = EnterAddressView()
    var onContinue: ((TransactionInfo)->())?
    private let currencyInfo: CurrencyInfo
    
    init(currencyInfo: CurrencyInfo) {
        self.currencyInfo = currencyInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.configure(with: currencyInfo)
        setUpFullscreenView(mainView: mainView)
        mainView.continueButton.addTarget(self, action: #selector(continueButtonAction), for: .touchUpInside)
        mainView.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        checkIfValidAddress(textField.text ?? "") ? mainView.setEnabledButton() : mainView.setDisabledButton()
    }
    
    func checkIfValidAddress(_ text: String) -> Bool {
        return Utils.isValidateBech32(text)
    }
    
    @objc func continueButtonAction() {
        guard let address = mainView.textField.text else {return}
        let transaction = TransactionInfo(amountOfTokens: nil, address: address)

        onContinue?(transaction)
    }
}
