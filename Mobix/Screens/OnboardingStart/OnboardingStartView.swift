// 

import UIKit

class OnboardingStartView: UIView {
    let imageView = UIImageView(image: UIImage(named: "coin_signet"))
    let welcomelabel = UILabel()
    let messageLabel = UILabel()
    let createWalletButton = DefaultButton(color: Colors.buttonsColor1)
    let restoreWalletButton = UIButton()
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = Colors.lightBackground
        addSubviews()
        applyConstraints()
        setUpButtons()
        setUpLabels()
        imageView.contentMode = .scaleAspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(imageView)
        addSubview(welcomelabel)
        addSubview(messageLabel)
        addSubview(createWalletButton)
        addSubview(restoreWalletButton)
    }
    
    private func applyConstraints() {
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide).inset(40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(250)
        }
        welcomelabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        messageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(welcomelabel.snp.bottom).offset(15)
            make.leading.trailing.equalTo(welcomelabel)
        }
        createWalletButton.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(restoreWalletButton.snp.height)
            make.bottom.equalTo(restoreWalletButton.snp.top).offset(-20)
        }
        restoreWalletButton.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().inset(50)
        }
    }
    
    private func setUpLabels() {
        welcomelabel.text = "welcome".localized
        welcomelabel.textAlignment = .center
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.text = "welcome_message".localized
        welcomelabel.font = Fonts.quicksandRegular.withSize(40)
        messageLabel.font = Fonts.robotoCondensedRegular.withSize(18)
    }
    
    private func setUpButtons() {
        let createWallettAtributedText = NSAttributedString(string: "create_wallet".localized, attributes: [.foregroundColor : UIColor.black])
        createWalletButton.setAttributedTitle(createWallettAtributedText, for: .normal)
        let restoreWalletttAributedText = NSAttributedString(string: "restore_wallet".localized, attributes: [.foregroundColor : Colors.buttonsTextColor, .underlineStyle: NSUnderlineStyle.single.rawValue, .font: Fonts.robotoCondensedBold.withSize(18)])
        restoreWalletButton.setAttributedTitle(restoreWalletttAributedText, for: .normal)
    }
    
}
