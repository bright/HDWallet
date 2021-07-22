
import Foundation
import UIKit

class EnterPasswordView: UIView {
    private let imageView = UIImageView(image: UIImage(named: "pin"))

    let passcode = Passcode()
    let titleLabel = UILabel()

    init() {
        super.init(frame: CGRect.zero)
        addSubviews()
        applyConstraints()
        backgroundColor = UIColor(patternImage: UIImage(named: "pattern")!)
        setUpLabels()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        addSubview(imageView)

        addSubview(titleLabel)
        addSubview(passcode)
    }
    
    private func applyConstraints() {
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide).inset(40)
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        passcode.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(50)
        }
    }
    
    private func setUpLabels() {
        titleLabel.textColor = Colors.textMain
        titleLabel.textAlignment = .center
        titleLabel.font = Fonts.barlowBold.withSize(35)
    }
    
}
