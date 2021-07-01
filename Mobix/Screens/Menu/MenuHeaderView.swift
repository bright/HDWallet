// 
import UIKit
import Foundation


class MenuHeaderView: UIView {
    private let walletLogoImageView = UIImageView(image: UIImage(named: "coin_signet"))
    let emojiLabel = UILabel()
    init() {
        super.init(frame: .zero)
        addSubviews()
        applyConstraints()
        backgroundColor = Colors.lightBackground
        emojiLabel.text = "\u{1F977}"
        emojiLabel.font = Fonts.quicksandMedium.withSize(40)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
    }
    
    func addSubviews() {
        addSubview(walletLogoImageView)
        addSubview(emojiLabel)
    }
    
    func applyConstraints() {
        walletLogoImageView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(50)
            make.centerX.equalToSuperview()
        }
        emojiLabel.snp.makeConstraints { (make) in
            make.center.equalTo(walletLogoImageView)
        }
    }
}
