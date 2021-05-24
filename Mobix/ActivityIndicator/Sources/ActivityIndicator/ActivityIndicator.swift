//

import Foundation
import UIKit
import Lottie

public class Loader {
    private init() {}
    public static let shared = Loader()
    let path = Bundle.module.url(forResource: "loading", withExtension: "json")!.path
    lazy var loadingAnimation = AnimationView(filePath: path)
    var tasksCount: UInt = 0 {
        didSet {
            if tasksCount == 0 {
                hideActivityIndicator()
            }
        }
    }

    private lazy var view: UIView = {
        let dimmingView = UIView()
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        loadingAnimation.loopMode = .loop
        dimmingView.addSubview(loadingAnimation)
        loadingAnimation.center = dimmingView.center
        return dimmingView
    }()
    
    public func start() {
        showActivityIndicatorIfNeeded()
    }
    
    public func stop() {
        hideActivityIndicator()
    }
    
    public func incrementActivityTask() {
        tasksCount += 1
        showActivityIndicatorIfNeeded()
    }
    
    public func decrementActivityTask() {
        tasksCount -= 1
    }
    
    public func isActivityIndicatorAminating() -> Bool {
        return view.superview != nil
    }
    
    private func showActivityIndicatorIfNeeded() {
        guard !isActivityIndicatorAminating() else {return}
        DispatchQueue.main.async { [weak self] in
            guard self != nil else {return}
            let window = UIApplication.shared.keyWindow!
            self?.view.frame = window.bounds
            self?.loadingAnimation.play()
            self?.loadingAnimation.center = self!.view.center
            window.addSubview(self!.view)
        }
    }
    
    private func hideActivityIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.view.removeFromSuperview()
        }
    }
}

