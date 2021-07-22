// 

import Foundation
import UIKit

class PasscodeInfoView: UIView {
    private let titleLabel = UILabel()
    private let imageView = UIImageView(image: UIImage(named: "pin"))
    private let infoLabel = UILabel()
    let button = DefaultButton(color: .white)
    
    init() {
        super.init(frame: CGRect.zero)
        addSubviews()
        applyConstraints()
        setUpLabels()
        backgroundColor = UIColor(patternImage: UIImage(named: "pattern")!)
        button.setTitle("ok_understand".localized, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(imageView)
        addSubview(infoLabel)
        addSubview(button)
    }
    
    private func applyConstraints() {
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide).inset(40)
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        infoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        button.snp.makeConstraints { (make) in
            make.top.equalTo(infoLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.height.equalTo(Constants.UI.buttonHeight)
            make.width.equalTo(200)
        }
    }
    
    private func setUpLabels() {
        titleLabel.textAlignment = .center
        infoLabel.textAlignment = .center
        titleLabel.font = Fonts.barlowBold.withSize(35)
        titleLabel.text = "passcode".localized
        infoLabel.text = "passcode_info_detail".localized
        infoLabel.font = Fonts.barlowRegular.withSize(18)
        infoLabel.numberOfLines = 0
        titleLabel.textColor = Colors.textMain
        infoLabel.textColor = Colors.textMain
    }
}
