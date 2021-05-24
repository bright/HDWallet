// 

import UIKit

class BackupView: UIView {
    private let titleLabel = UILabel()
    private let imageView = UIImageView(image: UIImage(named: "backup_cloud"))
    private let detailLabel = UILabel()
    private let accessoryImageView = UIImageView(image: UIImage(named: "warning"))
    let button = DefaultButton(color: .white)
    
    init() {
        super.init(frame: CGRect.zero)
        addSubviews()
        applyConstraints()
        setUpLabels()
        backgroundColor = Colors.lightBackground
        button.setTitle("choose_backup_location".localized, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func addSubviews() {
        addSubview(titleLabel)
        addSubview(imageView)
        addSubview(detailLabel)
        addSubview(button)
    }
    
    func applyConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide).inset(40)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        detailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        button.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(Constants.UI.buttonHeight)
        }
    }
    
    private func setUpLabels() {
        titleLabel.textAlignment = .center
        titleLabel.font = Fonts.quicksandRegular.withSize(40)
        titleLabel.text = "create_backup".localized
        detailLabel.text = "create_backup_description".localized
        detailLabel.font = Fonts.robotoCondensedRegular.withSize(18)
        detailLabel.textAlignment = .center
        detailLabel.numberOfLines = 0
    }
}
