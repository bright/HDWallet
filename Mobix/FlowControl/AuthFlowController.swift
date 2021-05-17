import Foundation
import UIKit

class AuthFlowController: FlowController {
    var onFlowFinish: (()->())?
    private let rootNavigationController: UINavigationController
    
    init(_ rootNavigationController: UINavigationController) {
        self.rootNavigationController = rootNavigationController
    }
    func runFlow() {
        showSignUpScreen()
    }

    func showSignUpScreen() {
        // push sign up view controller here
        rootNavigationController.pushViewController(UIViewController(), animated: false)
    }
}

