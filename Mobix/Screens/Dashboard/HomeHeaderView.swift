// 

import Foundation
import UIKit

struct HomeHeaderViewViewModel {
    let balance: String
}


class HomeHeaderView: UIView {
    private let walletLogoImageView = UIImageView(image: UIImage(named: "logo"))
    let balanceLabel = UILabel()
    let transferButton = UIButton()
    init() {
        super.init(frame: .zero)
        addSubviews()
        applyConstraints()
        backgroundColor = Colors.lightBackground
        balanceLabel.font = Fonts.quicksandMedium.withSize(40)
        transferButton.setTitle("Send", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: HomeHeaderViewViewModel) {
        balanceLabel.text = viewModel.balance
    }
    
    func addSubviews() {
        addSubview(walletLogoImageView)
        addSubview(balanceLabel)
        addSubview(transferButton)
    }
    
    func applyConstraints() {
        walletLogoImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        transferButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(walletLogoImageView)
            make.trailing.equalTo(walletLogoImageView.snp.leading).offset(-40)
        }
        balanceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(walletLogoImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(30)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
    }
}
