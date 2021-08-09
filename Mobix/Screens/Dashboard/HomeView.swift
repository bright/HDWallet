// 

import Foundation
import UIKit

struct HomeViewViewModel {
    let balance: String
}

class HomeView: UIView {
    let balanceLabel = UILabel()
    private let walletLogoImageView = UIImageView(image: UIImage(named: "coin_signet"))
    let sendButton = HighlightableButton(color: Colors.buttonsColor2)
    let receiveButton = HighlightableButton(color: Colors.buttonsColor2)
    lazy var buttonsStack = UIStackView(arrangedSubviews: [sendButton, receiveButton])

    init() {
        super.init(frame: CGRect.zero)
        addSubviews()
        applyConstraints()
        setUpButtons()
        setUpLabels()
        backgroundColor = UIColor(patternImage: UIImage(named: "pattern")!)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: HomeViewViewModel) {
        balanceLabel.text = viewModel.balance
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        receiveButton.centerVertically()
        sendButton.centerVertically()
    }
    
    private func addSubviews() {
        addSubview(walletLogoImageView)
        addSubview(balanceLabel)
        addSubview(buttonsStack)
    }
    
    private func applyConstraints() {
        walletLogoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide).offset(50)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(140)
        }
        balanceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(walletLogoImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        buttonsStack.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(144)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(50)
        }
    }
    
    private func setUpLabels() {
        balanceLabel.textAlignment = .center
        balanceLabel.font = Fonts.barlowBold.withSize(26)
        balanceLabel.textColor = .white
    }
    
    private func setUpButtons() {
        let sendButtonAttributedText = NSAttributedString(string: "send_button".localized, attributes: [.foregroundColor: UIColor.white, .font: Fonts.barlowBold.withSize(18)])
        sendButton.setAttributedTitle(sendButtonAttributedText, for: .normal)
        sendButton.setImage(UIImage(named: "send"), for: .normal)
        let receiveButtonAttributedText = NSAttributedString(string: "receive_button".localized, attributes: [.foregroundColor: UIColor.white, .font: Fonts.barlowBold.withSize(18)])
        receiveButton.setImage(UIImage(named: "receive"), for: .normal)
        receiveButton.setAttributedTitle(receiveButtonAttributedText, for: .normal)
        [sendButton,receiveButton].forEach{
            $0.layer.cornerRadius = 8
            
        }
        buttonsStack.spacing = 20
        buttonsStack.distribution = .fillEqually
    }
}

