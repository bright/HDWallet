// 

import Foundation
import UIKit

class DefaultButton: HighlightableButton {
    override init(color: UIColor, highlightedColor: UIColor? = nil) {
        super.init(color: color, highlightedColor: highlightedColor)
        titleLabel?.font = Fonts.barlowBold.withSize(22)
        setTitleColor(.lightGray, for: .disabled)
        setTitleColor(.black, for: .normal)
        layer.cornerRadius = CGFloat(Constants.UI.buttonHeight/2)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
