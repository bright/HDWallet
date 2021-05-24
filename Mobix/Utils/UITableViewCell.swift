import Foundation
import UIKit

public extension UITableViewCell {
    class var identifier: String{
        return String(describing: self)
    }
}


public extension UITableViewHeaderFooterView {
    class var identifier: String{
        return String(describing: self)
    }
}
