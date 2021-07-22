// 

import Foundation
import UIKit


class BackupPhraseCell: UICollectionViewCell {
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        applyConstraints()
        label.textColor = Colors.textMain
        label.font = Fonts.barlowBold.withSize(18)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(text: String) {
        self.label.text = text
    }
    
    func addSubviews() {
        contentView.addSubview(label)
    }
    
    func applyConstraints() {
        label.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

