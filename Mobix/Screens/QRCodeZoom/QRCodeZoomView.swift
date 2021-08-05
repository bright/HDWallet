// 

import Foundation
import UIKit

class QRCodeZoomView: UIView {
    let qrImageView = UIImageView()
    private let titleLabel = UILabel()
    let closeButton = HighlightableButton(color: Colors.buttonsColor1)
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor(patternImage: UIImage(named: "dark_bg")!)
        addSubviews()
        applyConstraints()
        setUpLabels()
        closeButton.setAttributedTitle(NSAttributedString(string: "Close".localized, attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, .font: Fonts.barlowBold.withSize(21)]), for: .normal)
        closeButton.layer.cornerRadius = CGFloat(Constants.UI.buttonHeight/2)
        closeButton.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(qrImageView)
        addSubview(closeButton)
    }
    
    private func applyConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide).inset(30)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        qrImageView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(70)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(qrImageView.snp.width)
        }
        closeButton.snp.makeConstraints { (make) in
            make.top.equalTo(qrImageView.snp.bottom).offset(40)
            make.height.equalTo(Constants.UI.buttonHeight)
            make.width.equalTo(100)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setUpLabels() {
        titleLabel.text = "scan_to_send".localized
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = Fonts.barlowBold.withSize(40)
    }
    
}
