import Foundation
import UIKit

protocol FlowController {
    func runFlow()
}

class AppFlowController: FlowController {
    func runFlow() {
        runOnboardingFlow()
    }
    
    private let window: UIWindow
    private var onboardingFlowController: OnboardingFlowController?
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
    
    func showDashboardScreen() {
        setUpRootViewController()
        let vc = DashboardTableVC()
        rootNavigationController.pushViewController(vc, animated: false)
    }
}
