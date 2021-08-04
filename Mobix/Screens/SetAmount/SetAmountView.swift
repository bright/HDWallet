// 

import Foundation
import UIKit

class SetAmountView: UIView {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let detailsLabel = UILabel()
    let textField = UITextField()
    let continueButton = DefaultButton(color: Colors.buttonsColor1)
    let imageView = UIImageView(image: UIImage(named: "set_amount"))


    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .white
        addSubviews()
        applyConstraints()
        setUpTextField()
        setUpLabels()
        setDisabledButton()
        continueButton.setTitle("continue".localized, for: .normal)
        backgroundColor = UIColor(patternImage: UIImage(named: "pattern")!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with detailText: String) {
        detailsLabel.text = detailText
    }
    
    private func addSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailsLabel)
        contentView.addSubview(textField)
        contentView.addSubview(continueButton)
    }
    
    private func applyConstraints() {
        scrollView.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(self)
        }
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(30)
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
            make.centerX.equalToSuperview()
            make.width.equalTo(170)
            make.top.equalTo(textField.snp.bottom).offset(20)
            make.height.equalTo(Constants.UI.buttonHeight)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setUpTextField() {
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .roundedRect
        textField.placeholder = "set_amount_placeholder".localized
        textField.keyboardType = .decimalPad
        textField.textAlignment = .center
    }
    
    private func setUpLabels() {
        titleLabel.text = "set_amount_title".localized
        textField.font = Fonts.barlowRegular.withSize(20)
        detailsLabel.textAlignment = .center
        detailsLabel.numberOfLines = 0
        titleLabel.font = Fonts.barlowBold.withSize(40)
        detailsLabel.font = Fonts.barlowRegular.withSize(18)
        titleLabel.textColor = Colors.textMain
        detailsLabel.textColor = Colors.textMain
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
    }
    
    func setEnabledButton() {
        continueButton.isEnabled = true
        continueButton.color = Colors.buttonsColor1
    }
    
    func setDisabledButton() {
        continueButton.isEnabled = false
        continueButton.color = Colors.buttonsColor1Disabled
    }
}
