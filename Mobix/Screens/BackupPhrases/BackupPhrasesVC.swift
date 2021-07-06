// 

import UIKit

class BackupPhrasesVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    private let titleLabel = UILabel()
    let saveButton = DefaultButton(color: Colors.buttonsColor1)
    let skipButton = DefaultButton(color: Colors.buttonsColor1)
    private var phrases: [String]
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        view.backgroundColor = .white
        setUpView()
        collectionView.register(BackupPhraseCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        phrases = ["122", "adsd", "das", "dsad", "dasdas"]
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        return CGSize(width: view.bounds.width/2 - 60, height: 40)
    }
    
    func setUpView() {
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.addSubview(saveButton)
        view.addSubview(skipButton)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(30)
            make.centerX.equalToSuperview()
        }
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        saveButton.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(collectionView.snp.bottom)
            make.height.equalTo(Constants.UI.buttonHeight)
        }
        skipButton.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(saveButton.snp.bottom)
            make.height.equalTo(Constants.UI.buttonHeight)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

class BackupPhraseCell: UICollectionViewCell {
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(text: String) {
        self.label.text = text
    }
    
    func addSubviews() {
        addSubview(label)
    }
    
    func applyConstraints() {
        label.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
