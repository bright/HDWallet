// 

import Foundation
import UIKit
import ActivityIndicator

class RepeatPasscodeVC: UIViewController {
    let code: String
    var onPasscodeValidated: (()->())?
    var mainView: EnterPasswordView
    
    init(title: String, code: String){
        self.mainView = EnterPasswordView()
        self.code = code
        mainView.titleLabel.text = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setUpFullscreenView(mainView: mainView)
        super.viewDidLoad()
        title = "restore_wallet".localized
        mainView.passcode.didFinishedEnterCode = { [weak self] code in
            DispatchQueue.main.async {
                self?.validate()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView.passcode.code = ""
        mainView.passcode.becomeFirstResponder()
    }
    
    func validate() {
        let repeatedCode = mainView.passcode.code
        if code == repeatedCode {
            generateWallet()
        } else {
            AlertPresenter.present(message: "passcodes_dont_match".localized, type: .error)
        }
    }
    
    func generateWallet() {
        Loader.shared.start()
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            let account = HDWalletProvider.generateWallet(chainType: .FETCH_AI_MAIN, password: code)
            do {
                try AccountStore.shared.setAccount(account: account)
                PasscodeRepository.shared.savePasscode(code)
                DispatchQueue.main.async {
                    Loader.shared.stop()
                    self.onPasscodeValidated?()
                }
            } catch {
                print(error)
            }
        }
    }
}
