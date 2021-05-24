import Foundation
import UIKit

class OnboardingFlowController: FlowController {
    var onFlowFinish: (()->())?
    private let rootNavigationController: UINavigationController
    
    init(_ window: UIWindow) {
        rootNavigationController = UINavigationController()
        window.rootViewController = rootNavigationController
        window.makeKeyAndVisible()
    }
    
    func runFlow() {
        showOnboardingStartScreen()
    }

    private func showOnboardingStartScreen() {
        let vc = OnboardingStartVC()
        vc.onRestoreWallet = { [weak self] in
            //     self?.showImportWalletScreen()
        }
        vc.onCreateWallet = { [weak self] in
            self?.showEnterNameScreen()
        }
        rootNavigationController.pushViewController(vc, animated: false)
    }
    
    
    func showEnterNameScreen() {
        let vc = EnterNameVC()
        vc.onContinue = { [weak self] in
            self?.showPasscodeInfoScreen()
        }
        rootNavigationController.pushViewController(vc, animated: true)
    }
    
//    private func showImportWalletScreen() {
//        let vc = ImportWalletVC()
//        rootNavigationController.pushViewController(vc, animated: true)
//        vc.onWalletAccessed = { [weak self] in
//            self?.showDecryptWalletScreen()
//        }
//    }
//
//    private func showDecryptWalletScreen() {
//        let vc = DecryptWalletVC()
//        vc.onWalletDecrypted = { [weak self] in
//            DispatchQueue.main.async {
//                self?.onFlowFinish?()
//            }
//        }
//        rootNavigationController.pushViewController(vc, animated: true)
//    }
//
    private func showPasscodeInfoScreen() {
        let vc = PasscodeInfoVC()
        rootNavigationController.pushViewController(vc, animated: true)
        vc.onNext = { [weak self] in
            self?.showEnterPasscodeScreen()
        }
    }
    
    private func showEnterPasscodeScreen() {
        let enterPasscodeVC = EnterPasscodeVC(title: "set_passcode".localized)
        rootNavigationController.pushViewController(enterPasscodeVC, animated: true)
        enterPasscodeVC.onPasscodeEntered = { [weak self] passcode in
            self?.showRepeatPasscodeScreen(code: passcode)
        }
    }

    private func showRepeatPasscodeScreen(code: String) {
        let enterPasscodeVC = RepeatPasscodeVC(title: "repeat_passcode".localized, code: code)
        rootNavigationController.pushViewController(enterPasscodeVC, animated: true)
        enterPasscodeVC.onPasscodeValidated = { [weak self] in
            self?.showBackupScreen()
        }
    }

    private func showBackupScreen() {
        let vc = BackupVC()
        vc.onNext = { [weak self] in
            self?.onFlowFinish?()
        }
        rootNavigationController.pushViewController(vc, animated: true)
    }
}
