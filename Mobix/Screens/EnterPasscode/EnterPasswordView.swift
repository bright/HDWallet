
import Foundation
import UIKit

class EnterPasswordView: UIView {
    
    let passcode = Passcode()
    let titleLabel = UILabel()

    init() {
        super.init(frame: CGRect.zero)
        addSubviews()
        applyConstraints()
        titleLabel.textAlignment = .center
        titleLabel.font = Fonts.quicksandMedium
        backgroundColor = Colors.lightBackground
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(passcode)
    }
    
    private func applyConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide).inset(40)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        passcode.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(50)
        }
    }
}
