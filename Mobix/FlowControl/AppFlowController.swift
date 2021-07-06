import Foundation
import UIKit
import SideMenu

protocol FlowController {
    func runFlow()
}

class AppFlowController: FlowController {
    var menu: MenuVC!
    var leftMenuNavigationController: SideMenuNavigationController!
    func runFlow() {
        if let _ = try? AccountStore.shared.getAccount() {
//            showDashboardScreen()
            showBackupPhraseScreen()
        } else {
            runOnboardingFlow()
        }
    }
    private func showBackupPhraseScreen() {
        setUpRootViewController()
        let vc = BackupPhrasesVC()
        rootNavigationController.pushViewController(vc, animated: false)
    }
    private let window: UIWindow
    private var onboardingFlowController: OnboardingFlowController?
    private var tradingFlowController: TradingFlowController?
    private var rootNavigationController = UINavigationController()
    
    init(_ window: UIWindow) {
        self.window = window
    }
    
    private func setUpRootViewController() {
        window.rootViewController = rootNavigationController
        window.makeKeyAndVisible()
    }
    
    func runOnboardingFlow() {
        onboardingFlowController = OnboardingFlowController(window)
        onboardingFlowController?.onFlowFinish = { [weak self] in
            self?.showDashboardScreen()
            self?.onboardingFlowController = nil
        }
        onboardingFlowController?.runFlow()
    }
    
    func runTransferFlow(walletBalanceTracker: WalletBalanceTracker,
                         currencyInfo: CurrencyInfo,
                         cosmos: Cosmos) {
        tradingFlowController = TradingFlowController(walletBalanceTracker: walletBalanceTracker, currencyInfo: currencyInfo, cosmos: cosmos, nv: rootNavigationController)
        tradingFlowController?.runFlow()
    }
    
    func showDashboardScreen() {
        setUpSlideMenu()
        setUpRootViewController()
        let cosmos = Cosmos(provider: FetchAIMainnetProvider())
        let balanceTracker = WalletBalanceTracker(cosmos: cosmos, denom: "atestfet")
        let vc = HomeVC(walletBalanceTracker: balanceTracker, cosmos: cosmos)
        vc.onOpenMenu = { [unowned self] in
            self.showMenu()
        }
        vc.onTransferTap = { [unowned self] currencyInfo in
            self.runTransferFlow(walletBalanceTracker: balanceTracker, currencyInfo: currencyInfo, cosmos: cosmos)
        }
        rootNavigationController.pushViewController(vc, animated: false)
    }
    
    func showMenu() {
        rootNavigationController.present(leftMenuNavigationController, animated: true, completion: nil)
    }
    
    private func setUpSlideMenu() {
        
        var set = SideMenuSettings()
        set.statusBarEndAlpha = 0
        set.presentationStyle = SideMenuPresentationStyle.menuSlideIn
        set.presentationStyle.presentingEndAlpha = 0.5
        
        menu = MenuVC()
        menu.onCredentialVerification = { [weak self] in
        }
        menu.onCredentialsIssued = { [weak self] in
        }
        menu.onHome = { [weak self] in
            self?.menu.dismiss(animated: true, completion: nil)
        }

        leftMenuNavigationController = SideMenuNavigationController(rootViewController: menu)
        leftMenuNavigationController.navigationBar.isHidden = true
        leftMenuNavigationController.settings = set
        SideMenuManager.default.leftMenuNavigationController = leftMenuNavigationController
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.rootNavigationController.view)
        leftMenuNavigationController.menuWidth = UIScreen.main.bounds.width*0.9
    }

}
