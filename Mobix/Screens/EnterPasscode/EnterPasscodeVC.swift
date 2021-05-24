
import Foundation
import UIKit

class EnterPasscodeVC: UIViewController, UITextFieldDelegate {
    var onPasscodeEntered: ((String)->())?
    var mainView: EnterPasswordView
    
    init(title: String){
        self.mainView = EnterPasswordView()
        mainView.titleLabel.text = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "create_wallet".localized
        setUpFullscreenView(mainView: mainView)
        mainView.passcode.didFinishedEnterCode = { [weak self] code in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.onPasscodeEntered?(code)
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView.passcode.code = ""
        mainView.passcode.becomeFirstResponder()
    }
}
