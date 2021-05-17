import Foundation
import UIKit

protocol FlowController {
    func runFlow()
}

class AppFlowController: FlowController {
    private let window: UIWindow
    private var authFlowController: AuthFlowController?
    private var rootNavigationController: UINavigationController!
    init(_ window: UIWindow) {
        self.window = window
    }
    
    func runFlow() {
        runAuthFlow()
    }
}

private extension AppFlowController {
    
    func runAuthFlow() {
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        authFlowController = AuthFlowController(navigationController)
        authFlowController?.onFlowFinish = { [weak self] in
            self?.showHomeScreen()
            self?.authFlowController = nil
        }
        authFlowController?.runFlow()
    }
    
    func showHomeScreen() {
    }
}



