// 

import Foundation
import UIKit

struct HomeViewViewModel {
    let balance: String
}

class HomeView: UIView {
    let balanceLabel = UILabel()
    private let walletLogoImageView = UIImageView(image: UIImage(named: "coin_signet"))
    let sendButton = HighlightableButton(color: .white)
    let receiveButton = HighlightableButton(color: .white)
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
    
    private func addSubviews() {
        addSubview(walletLogoImageView)
        addSubview(balanceLabel)
        addSubview(buttonsStack)
    }
    
    private func applyConstraints() {
        walletLogoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide).inset(40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(170)
        }
        balanceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(walletLogoImageView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        buttonsStack.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(144)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func setUpLabels() {
        balanceLabel.textAlignment = .center
    }
    
    private func setUpButtons() {
        sendButton.backgroundColor = .white
        let sendButtonAttributedText = NSAttributedString(string: "send_button".localized, attributes: [.foregroundColor: UIColor.black, .font: Fonts.barlowRegular.withSize(22)])
        sendButton.setAttributedTitle(sendButtonAttributedText, for: .normal)
        sendButton.setImage(UIImage(named: "send"), for: .normal)
        let receiveButtonAttributedText = NSAttributedString(string: "receive_button".localized, attributes: [.foregroundColor: UIColor.black, .font: Fonts.barlowRegular.withSize(22)])
        receiveButton.setImage(UIImage(named: "Receive"), for: .normal)
        receiveButton.setAttributedTitle(receiveButtonAttributedText, for: .normal)

        [sendButton,receiveButton].forEach{
            $0.layer.cornerRadius = 8
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.4
            $0.layer.shadowOffset = CGSize(width: 2, height: 2)
            $0.layer.shadowRadius = 5
        }
        buttonsStack.spacing = 20
        buttonsStack.distribution = .fillEqually
    }
}

