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
            self?.showImportWalletScreen()
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
    
    private func showImportWalletScreen() {
        let vc = ImportWalletInfoVC()
        rootNavigationController.pushViewController(vc, animated: true)
        vc.onContinue = { [weak self] in
            self?.showEnterMnemonicScreen()
        }
    }

    private func showEnterMnemonicScreen() {
        let vc = EnterMnemonicVC()
        
        rootNavigationController.pushViewController(vc, animated: true)
    }

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
            self?.showBackupPhraseScreen()
        }
    }

    
    private func showBackupPhraseScreen() {
        let vc = BackupPhrasesVC()
        vc.onContinue = { [weak self] in
            self?.onFlowFinish?()
        }
        rootNavigationController.pushViewController(vc, animated: false)
    }
    
    private func showBackupPhraseInfoScreen() {
        
    }
}
