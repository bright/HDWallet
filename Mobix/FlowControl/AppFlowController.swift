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
    private var rootViewController: UIViewController!
    init(_ window: UIWindow) {
        self.window = window
        rootViewController = UIViewController()
    }
    
    private func setUpRootViewController() {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
    
    func runOnboardingFlow() {
        onboardingFlowController = OnboardingFlowController(window)
        onboardingFlowController?.onFlowFinish = { [weak self] in
//            self?.showTokensFetchingScreen()
            self?.onboardingFlowController = nil
        }
        onboardingFlowController?.runFlow()
    }
}
