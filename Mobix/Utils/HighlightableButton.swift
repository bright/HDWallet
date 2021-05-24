// 

import Foundation
import SnapKit
import UIKit

open class HighlightableButton: UIButton {

    public var highlightedColor: UIColor
    public var color: UIColor {
        didSet {
            self.backgroundColor = color
        }
    }

    public override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? highlightedColor : self.color
        }
    }

    public init(color: UIColor, highlightedColor: UIColor? = nil) {
        if let highlightedColor = highlightedColor {
            self.highlightedColor = highlightedColor
        } else {
            self.highlightedColor = color.withAlphaComponent(0.7)
        }
        self.color = color
        super.init(frame: CGRect.zero)
        self.backgroundColor = color
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
