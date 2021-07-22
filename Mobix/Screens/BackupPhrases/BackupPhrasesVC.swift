// 

import UIKit
import KeychainAccess

class BackupPhrasesVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    private let titleLabel = UILabel()
    private let imageView = UIImageView(image: UIImage(named: "mnemonic"))
    var onContinue: (()->())?
    let shareButton = DefaultButton(color: Colors.buttonFilledColor)
    let continueButton = DefaultButton(color: Colors.buttonFilledColor)
    lazy var buttonsStack = UIStackView(arrangedSubviews: [shareButton, continueButton])
    private var phrases: [String]
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "pattern")!)
        collectionView.dataSource = self
        setUpView()
        collectionView.register(BackupPhraseCell.self, forCellWithReuseIdentifier: "cell")
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
        let walletUUID = try! AccountStore.shared.getAccount()!.walletUUID
        let keychainAccess = Keychain(service: Constants.Auth.keychainServiceIdentifier)
        phrases = keychainAccess[walletUUID]?.split(separator: " ").map{String($0)} ?? [String]()
        super.init(nibName: nil, bundle: nil)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BackupPhraseCell
        cell.configure(text: phrases[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 25)
    }
    
    func setUpView() {
        view.addSubview(titleLabel)
        view.addSubview(imageView)
        view.addSubview(collectionView)
        view.addSubview(buttonsStack)
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        buttonsStack.snp.makeConstraints { (make) in
            make.top.equalTo(collectionView.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(Constants.UI.buttonHeight)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
        }
    }
    
    private func setUpButtons() {
        let continueAtributedText = NSAttributedString(string: "continue".localized, attributes: [.foregroundColor : Colors.buttonFilledTextColor])
        continueButton.setAttributedTitle(continueAtributedText, for: .normal)
        shareButton.setImage(UIImage(named: "share"), for: .normal)
        continueButton.addTarget(self, action: #selector(continueAction), for: .touchUpInside)
    }
}
