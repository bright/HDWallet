// 

import Foundation
import UIKit

class EnterMnemonicView: UIView {
    let imageView = UIImageView(image: UIImage(named: "mnemonic"))
    let titleLabel = UILabel()
    let messageLabel = UILabel()
    let textField = UITextField()
    let continueButton = DefaultButton(color: Colors.buttonFilledColor)

    init() {
        super.init(frame: CGRect.zero)
        addSubviews()
        backgroundColor = UIColor(patternImage: UIImage(named: "pattern")!)
        applyConstraints()
        setUpButtons()
        setUpLabels()
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(messageLabel)
        addSubview(textField)
        addSubview(continueButton)
    }
    
    private func applyConstraints() {
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide).inset(40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(170)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        messageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
            make.leading.trailing.equalTo(titleLabel)
        }
        textField.snp.makeConstraints { (make) in
            make.top.equalTo(messageLabel.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        continueButton.snp.makeConstraints { (make) in
            make.top.equalTo(textField.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.height.equalTo(Constants.UI.buttonHeight)
            make.width.equalTo(180)
        }
    }
    
    private func setUpLabels() {
        titleLabel.text = "Phrase 1".localized
        titleLabel.textAlignment = .center
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.text = "restore_wallet_message".localized
        titleLabel.font = Fonts.barlowBold.withSize(35)
        messageLabel.font = Fonts.barlowRegular.withSize(18)
        messageLabel.textColor = Colors.textMain
        titleLabel.textColor = Colors.textMain
    }
    
    private func setUpButtons() {
        let createWallettAtributedText = NSAttributedString(string: "continue".localized, attributes: [.foregroundColor : Colors.buttonFilledTextColor])
        continueButton.setAttributedTitle(createWallettAtributedText, for: .normal)
    }
}

