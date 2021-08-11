
import UIKit
import KeychainAccess

class BackupPhrasesVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    private let titleLabel = UILabel()
    private let imageView = UIImageView(image: UIImage(named: "mnemonic"))
    var onContinue: (()->())?
    let shareButton = DefaultButton(color: Colors.buttonsColor1)
    let continueButton = DefaultButton(color: Colors.buttonsColor1)
    lazy var buttonsStack = UIStackView(arrangedSubviews: [shareButton, continueButton])
    private var phrases: [String]
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    var collectionCellsViewModel: [PhraseCollectionCellViewModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "pattern")!)
        collectionView.dataSource = self
        setUpView()
        collectionView.register(PhraseCollectionCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        titleLabel.text = "backup_phrase".localized
        titleLabel.textAlignment = .center
        titleLabel.textColor = Colors.textMain
        titleLabel.font = Fonts.barlowBold.withSize(35)
        buttonsStack.alignment = .center
        buttonsStack.spacing = 20
        setUpButtons()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        phrases = AccountManager.shared.getMnemonicPhrases()?.split(separator: " ").map{String($0)} ?? [String]()
        super.init(nibName: nil, bundle: nil)
        makeCollectionCellsViewModel(for: phrases)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func continueAction() {
        onContinue?()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        phrases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhraseCollectionCell
        cell.configure(with: collectionCellsViewModel[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = collectionCellsViewModel[indexPath.row].phrase
        let phraseTextSize = item.size(withAttributes: [
            NSAttributedString.Key.font : Fonts.barlowBold.withSize(22)
        ])
        return CGSize(width: phraseTextSize.width + 70, height: 40)
    }
    
    
    
    func setUpView() {
        view.addSubview(titleLabel)
        view.addSubview(imageView)
        view.addSubview(collectionView)
        view.addSubview(buttonsStack)
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        buttonsStack.snp.makeConstraints { (make) in
            make.top.equalTo(collectionView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
        }
        continueButton.snp.makeConstraints { (make) in
            make.height.equalTo(Constants.UI.buttonHeight)
            make.width.equalTo(120)
        }
        shareButton.snp.makeConstraints { (make) in
            make.height.equalTo(Constants.UI.buttonHeight)
            make.width.equalTo(shareButton.snp.height)
        }
    }
    
    private func setUpButtons() {
        let continueAtributedText = NSAttributedString(string: "continue".localized, attributes: [.foregroundColor : Colors.buttonFilledTextColor])
        continueButton.setAttributedTitle(continueAtributedText, for: .normal)
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up")?.withTintColor(.black), for: .normal)
        continueButton.addTarget(self, action: #selector(continueAction), for: .touchUpInside)
    }
    
    private func makeCollectionCellsViewModel(for phrases: [String]) {
        var num = 0
        collectionCellsViewModel = phrases.map({ (phrase) -> PhraseCollectionCellViewModel in
            num+=1
            return PhraseCollectionCellViewModel(num: num.description, phrase: phrase)
        })
    }
}
