// 

import Foundation
import UIKit

class RequestStartView: UIView {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let detailsLabel = UILabel()
    let QRImageView = UIImageView()
    let qrBackground = UIView()
    let shareButton = DefaultButton(color: Colors.buttonsColor1)
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor(patternImage: UIImage(named: "pattern")!)
        addSubviews()
        applyConstraints()
        setUpLabels()
        setUpQRBackground()
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up")?.withTintColor(.black), for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with currencyInfo: CurrencyInfo) {
        detailsLabel.text = String.localizedStringWithFormat("request_details".localized, currencyInfo.symbol)
    }
    
    private func addSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(qrBackground)
        contentView.addSubview(QRImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailsLabel)
        contentView.addSubview(shareButton)
    }
    
    private func applyConstraints() {
        scrollView.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(self)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
        }
        detailsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        QRImageView.snp.makeConstraints { (make) in
            make.top.equalTo(detailsLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(QRImageView.snp.width)
        }
        qrBackground.snp.makeConstraints { (make) in
            make.center.equalTo(QRImageView)
            make.width.height.equalTo(QRImageView.snp.width).offset(20)
        }
        shareButton.snp.makeConstraints { (make) in
            make.top.equalTo(qrBackground.snp.bottom).offset(30)
            make.height.equalTo(Constants.UI.buttonHeight)
            make.bottom.equalToSuperview().inset(100)
            make.centerX.equalToSuperview()
            make.width.equalTo(90)
        }
    }
    
    private func setUpLabels() {
        titleLabel.text = "request_title".localized
        detailsLabel.textAlignment = .center
        detailsLabel.numberOfLines = 0
        titleLabel.font = Fonts.barlowBold.withSize(40)
        detailsLabel.font = Fonts.barlowRegular.withSize(21)
        titleLabel.textColor = Colors.textMain
        detailsLabel.textColor = Colors.textMain
    }
    
    private func setUpQRBackground() {
        qrBackground.backgroundColor = .white
        qrBackground.layer.cornerRadius = 8
        qrBackground.layer.shadowColor = UIColor.black.cgColor
        qrBackground.layer.shadowOpacity = 0.2
        qrBackground.layer.shadowOffset = CGSize(width: 0, height: 0)
        qrBackground.layer.shadowRadius = 3
    }
}

