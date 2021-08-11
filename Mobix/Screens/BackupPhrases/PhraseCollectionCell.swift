// 

import Foundation
import UIKit

struct PhraseCollectionCellViewModel {
    let num: String
    let phrase: String
}
class PhraseCollectionCell: UICollectionViewCell {
    let numLabel = UILabel()
    let phraseLabel = UILabel()
    lazy var labelsStack = UIStackView(arrangedSubviews: [numLabel, phraseLabel])
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.layer.borderWidth = 3
        contentView.layer.borderColor = Colors.phraseCollectionOverlayColor.cgColor
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        backgroundColor = UIColor.clear
        addSubviews()
        applyConstraints()
        numLabel.backgroundColor = Colors.phraseCollectionOverlayColor
        numLabel.textColor = Colors.phraseCollectionNumColor
        phraseLabel.textColor = Colors.textMain
        numLabel.textAlignment = .center
        phraseLabel.textAlignment = .center
        numLabel.font = Fonts.barlowBold.withSize(22)
        phraseLabel.font = Fonts.barlowBold.withSize(22)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with vm: PhraseCollectionCellViewModel) {
        numLabel.text = vm.num
        phraseLabel.text = vm.phrase
    }
    
    private func addSubviews() {
        contentView.addSubview(labelsStack)
    }
    
    private func applyConstraints() {
        numLabel.snp.makeConstraints { (make) in
            make.width.equalTo(40)
        }
        labelsStack.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(3)
        }
    }
    
}

