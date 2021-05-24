// 

import Foundation
import UIKit

class EnterNameView: UIView {
    let logoImageView = UIImageView(image: UIImage(named: "logo_welcome"))
    let continueButton = DefaultButton(color: Colors.buttonsColor1)
    private let titleLabel = UILabel()
    private let detailsLabel = UILabel()
    let textField = UITextField()

    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = Colors.lightBackground
        addSubviews()
        applyConstraints()
        setUpButtons()
        setUpLabels()
        setUpTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(logoImageView)
        addSubview(titleLabel)
        addSubview(detailsLabel)
        addSubview(textField)
        addSubview(continueButton)
    }
    
    private func applyConstraints() {
        logoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide).inset(40)
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(logoImageView.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
        detailsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        textField.snp.makeConstraints { (make) in
            make.top.equalTo(detailsLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        continueButton.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(textField)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(Constants.UI.buttonHeight)
        }
    }
    
    private func setUpTextField() {
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .roundedRect
        textField.placeholder = "enter_nickname".localized
        textField.keyboardType = .asciiCapable
    }
    
    private func setUpLabels() {
        titleLabel.text = "welcome".localized
        detailsLabel.text = "welcome_message".localized
        textField.font = Fonts.quicksandMedium
        detailsLabel.textAlignment = .center
        detailsLabel.numberOfLines = 0
        titleLabel.font = Fonts.quicksandMedium
        detailsLabel.font = Fonts.quicksandMedium
    }
    
    func setUpButtons() {
        let createWallettAtributedText = NSAttributedString(string: "create_wallet".localized, attributes: [.font: Fonts.quicksandMedium])
        continueButton.setAttributedTitle(createWallettAtributedText, for: .normal)
        continueButton.setAttributedTitle(createWallettAtributedText, for: .normal)
    }
}
