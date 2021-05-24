// 

import UIKit

class PasscodeInfoVC: UIViewController {
    var onNext: (()->())?
    var mainView: PasscodeInfoView
    
    init(){
        self.mainView = PasscodeInfoView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "create_wallet".localized
        setUpFullscreenView(mainView: mainView)
        mainView.button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    @objc func buttonAction() {
        onNext?()
    }
}
