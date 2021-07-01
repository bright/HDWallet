// 

import Foundation
import UIKit

class MenuCell: UITableViewCell {
    let accessoryImageView = UIImageView()
    let label = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        applyConstraints()
//        label.font = Fonts.quicksandRegular.withSize(18)
        accessoryImageView.contentMode = .scaleAspectFit
        setUpSelectedView()
        label.font = Fonts.quicksandMedium.withSize(18)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
    }
    
    func addSubviews() {
        contentView.addSubview(accessoryImageView)
        contentView.addSubview(label)
    }
    
    func applyConstraints() {
        accessoryImageView.snp.makeConstraints { (make) in
            make.trailing.top.bottom.equalToSuperview().inset(16)
            make.width.height.equalTo(24)
        }
        label.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(accessoryImageView.snp.leading).offset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    func setUpSelectedView() {
        let bgColorView = UIView()
        bgColorView.backgroundColor = Colors.secondaryBackground
        bgColorView.layer.cornerRadius = 15
        bgColorView.clipsToBounds = true
        selectedBackgroundView = bgColorView
    }
    
    
}
