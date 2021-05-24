// 

import UIKit
import MobileCoreServices
import ActivityIndicator

class OnboardingStartVC: UIViewController {
    private let mainView = OnboardingStartView()
    var onRestoreWallet: (()->())?
    var onCreateWallet: (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "welcome".localized
        setUpFullscreenView(mainView: mainView)
        mainView.createWalletButton.addTarget(self, action: #selector(createWalletAction), for: .touchUpInside)
        mainView.restoreWalletButton.addTarget(self, action: #selector(restoreWalletAction), for: .touchUpInside)
    }
    
    @objc func createWalletAction() {
        onCreateWallet?()
    }
    
    @objc func restoreWalletAction() {
        onRestoreWallet?()
    }
}
