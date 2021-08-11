// 

import Foundation
import UIKit

class EnterNameView: UIView {
    let faceImageView = UIImageView(image: UIImage(named: "face"))
    let continueButton = DefaultButton(color: Colors.buttonsColor1)
    private let titleLabel = UILabel()
    private let detailsLabel = UILabel()
    let textField = UITextField()

    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor(patternImage: UIImage(named: "pattern")!)
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
        addSubview(faceImageView)
        addSubview(titleLabel)
        addSubview(detailsLabel)
        addSubview(textField)
        addSubview(continueButton)
    }
    
    private func applyConstraints() {
        faceImageView.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide).inset(40)
            make.width.height.equalTo(140)
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(faceImageView.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
        detailsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        textField.snp.makeConstraints { (make) in
            make.top.equalTo(detailsLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(70)
        }
        continueButton.snp.makeConstraints { (make) in
            make.top.equalTo(textField.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.height.equalTo(Constants.UI.buttonHeight)
            make.width.equalTo(180)
        }
    }
    
    private func setUpTextField() {
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .roundedRect
        textField.placeholder = "enter_nickname".localized
        textField.keyboardType = .asciiCapable
        textField.textAlignment = .center
        textField.backgroundColor = Colors.overlayColor
    }
    
    private func setUpLabels() {
        titleLabel.text = "make_this_personal".localized
        detailsLabel.text = "make_this_personal_message".localized
        textField.font = Fonts.quicksandMedium
        detailsLabel.textAlignment = .center
        detailsLabel.numberOfLines = 0
        titleLabel.font = Fonts.barlowBold.withSize(35)
        detailsLabel.font = Fonts.barlowRegular.withSize(18)
        detailsLabel.textColor = Colors.textMain
        titleLabel.textColor = Colors.textMain
    }
    
    func setUpButtons() {
        let createWallettAtributedText = NSAttributedString(string: "create_wallet".localized, attributes: [.foregroundColor : Colors.buttonFilledTextColor])
        continueButton.setAttributedTitle(createWallettAtributedText, for: .normal)
        continueButton.setAttributedTitle(createWallettAtributedText, for: .normal)
    }
}
