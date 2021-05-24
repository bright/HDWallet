import UIKit
import Foundation
import SnapKit

public extension UIViewController {
    func setUpFullscreenView(mainView: UIView) {
        self.view.addSubview(mainView)
        mainView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
    }
}
