// 

import Foundation
import UIKit

class ScannerView: UIView {
    private let bracketShape = UIImageView(image: UIImage(named: "bracket_shape"))
    private let titleLabel = UILabel()
    private let detailsLabel = UILabel()
    let enterWalletIdManuallyButton = UIButton()
    init() {
        super.init(frame: CGRect.zero)
        addSubviews()
        applyConstraints()
        let attributedText = NSAttributedString(string: "enter_address_manually".localized, attributes: [.foregroundColor : UIColor.white, .underlineStyle: NSUnderlineStyle.single.rawValue])
        enterWalletIdManuallyButton.setAttributedTitle(attributedText, for: .normal)
        enterWalletIdManuallyButton.titleLabel?.font = Fonts.barlowRegular.withSize(20)
        setUpLabels()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with currencyInfo: CurrencyInfo) {
        detailsLabel.text = String.localizedStringWithFormat("scan_the_qr".localized, currencyInfo.symbol)
    }
    
    private func addSubviews() {
        addSubview(bracketShape)
        addSubview(titleLabel)
        addSubview(detailsLabel)
        addSubview(enterWalletIdManuallyButton)
    }
    
    private func applyConstraints() {
        bracketShape.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide).inset(25)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        detailsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        enterWalletIdManuallyButton.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview().inset(30)
            make.height.equalTo(50)
        }
    }
    
    private func setUpLabels() {
        titleLabel.text = "send".localized
        detailsLabel.textAlignment = .center
        detailsLabel.numberOfLines = 0
        titleLabel.font = Fonts.barlowBold.withSize(40)
        detailsLabel.font = Fonts.barlowRegular.withSize(18)
        titleLabel.textColor = .white
        detailsLabel.textColor = .white
        titleLabel.textAlignment = .center
    }
}
