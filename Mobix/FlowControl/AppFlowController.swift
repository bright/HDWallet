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
        if let _ = AccountManager.shared.getAccount() {
            showDashboardScreen()
//            development()
        } else {
            runOnboardingFlow()
        }
    }
    func development() {
        showBackupPhraseScreen()
    }
    private func showBackupPhraseScreen() {
        setUpRootViewController()
        let vc = BackupPhrasesVC()
        rootNavigationController.pushViewController(vc, animated: false)
    }
    private let window: UIWindow
    private var onboardingFlowController: OnboardingFlowController?
    private var tradingFlowController: TradingFlowController?
    private var receiveFlowController: ReceiveFlowController?
    private var rootNavigationController = UINavigationController()
    
    init(_ window: UIWindow) {
        self.window = window
    }
    
    private func setUpRootViewController() {
        window.rootViewController = rootNavigationController
        rootNavigationController.navigationBar.isTranslucent = true
        rootNavigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        rootNavigationController.navigationBar.shadowImage = UIImage()
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
        let config = Cosmos.Config(provider: FetchAIMainnetProvider(), chainId: "andromeda-1")
        let cosmos = Cosmos(config: config)
        let balanceTracker = WalletBalanceTracker(cosmos: cosmos, denom: "nanomobx")
        let vc = HomeVC(walletBalanceTracker: balanceTracker, cosmos: cosmos)
        vc.onOpenMenu = { [unowned self] in
            self.showMenu()
        }
        vc.onTransfer = { [unowned self] currencyInfo in
            self.runTransferFlow(walletBalanceTracker: balanceTracker, currencyInfo: currencyInfo, cosmos: cosmos)
        }

        vc.onReceive = { [unowned self] currencyInfo in
            self.runReceiveFlow(walletBalanceTracker: balanceTracker, currencyInfo: currencyInfo, cosmos: cosmos)
        }
        rootNavigationController.pushViewController(vc, animated: false)
    }
    
    func runReceiveFlow(walletBalanceTracker: WalletBalanceTracker,
                        currencyInfo: CurrencyInfo, cosmos: Cosmos) {
        receiveFlowController = ReceiveFlowController(self.rootNavigationController, walletBalanceTracker: walletBalanceTracker, currencyInfo: currencyInfo, cosmos: cosmos)
        receiveFlowController?.runFlow()
        receiveFlowController?.onFlowFinish = { [unowned self] in
            self.receiveFlowController = nil
        }
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


