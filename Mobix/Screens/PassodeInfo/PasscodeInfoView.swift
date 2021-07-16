// 

import Foundation
import UIKit

class PasscodeInfoView: UIView {
    private let titleLabel = UILabel()
    private let imageView = UIImageView(image: UIImage(named: "pin"))
    private let infoLabel = UILabel()
    private let accessoryImageView = UIImageView(image: UIImage(named: "warning"))
    let button = DefaultButton(color: .white)
    
    init() {
        super.init(frame: CGRect.zero)
        addSubviews()
        applyConstraints()
        setUpLabels()
        backgroundColor = Colors.lightBackground
        button.setTitle("ok_understand".localized, for: .normal)
        accessoryImageView.contentMode = .scaleAspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(imageView)
        addSubview(infoLabel)
        addSubview(accessoryImageView)
        addSubview(button)
    }
    
    private func applyConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide).inset(40)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        infoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.leading.equalTo(accessoryImageView.snp.trailing).offset(5)
            make.trailing.equalToSuperview().inset(20)
        }
        accessoryImageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(infoLabel)
        }
        button.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(Constants.UI.buttonHeight)
        }
    }
    
    private func setUpLabels() {
        titleLabel.textAlignment = .center
        titleLabel.font = Fonts.barlowBold.withSize(40)
        titleLabel.text = "passcode".localized
        infoLabel.text = "passcode_info_detail".localized
        infoLabel.font = Fonts.barlowRegular.withSize(18)
        infoLabel.numberOfLines = 0
    }
}
