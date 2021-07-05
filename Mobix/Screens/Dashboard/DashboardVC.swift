// 

import UIKit
import Combine

class HomeVC: UITableViewController {
//    let cancellable = Cosmos.shared.publisher.sink { (cosmosCoin) in
//        print(cosmosCoin)
//    }
    private var publishers = [AnyCancellable]()
    private var headerView: HomeHeaderView!
    var onOpenMenu: (()->())?
    let cosmos = Cosmos(provider: FetchAIMainnetProvider())
    lazy var balanceTracker = WalletBalanceTracker(cosmos: cosmos, denom: "atestfet")
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addMenuBarButtonItem()
        let account = try! AccountStore.shared.getAccount()!
        cosmos.attachAccount(account)
        balanceTracker.startTracking(for: account)
        balanceTracker.publisher.sink(
            receiveCompletion: { completion in
                // Called once, when the publisher was completed.
                print(completion)
            },
            receiveValue: { [unowned self] value in
                // Can be called multiple times, each time that a
                // new value was emitted by the publisher.
                print(value)
                guard let value = value else {return}
                let vm = HomeHeaderViewViewModel(balance: value)
                DispatchQueue.main.async {
                    self.headerView.configure(with: vm)
                }
            }
        ).store(in: &publishers)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpHeader()
    }
    
    @objc func openMenu() {
        onOpenMenu?()
    }
    
    private func addMenuBarButtonItem() {
        let item = UIBarButtonItem()
        let menuButton = UIButton()
        menuButton.setImage(UIImage(named: "menu"), for: .normal)
        menuButton.addTarget(self, action: #selector(openMenu), for: .touchUpInside)
        item.customView = menuButton
        item.customView?.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        navigationItem.leftBarButtonItem = item
    }
    
    func setUpHeader() {
        headerView = HomeHeaderView()
        let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var frame = headerView.frame
        frame.size.height = height
        headerView.frame = frame
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()
    }
    
}


class HomeHeaderView: UIView {
    private let walletLogoImageView = UIImageView(image: UIImage(named: "coin_signet"))
    let balanceLabel = UILabel()
    init() {
        super.init(frame: .zero)
        addSubviews()
        applyConstraints()
        backgroundColor = Colors.lightBackground
        balanceLabel.font = Fonts.quicksandMedium.withSize(40)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: HomeHeaderViewViewModel) {
        balanceLabel.text = viewModel.balance
    }
    
    func addSubviews() {
        addSubview(walletLogoImageView)
        addSubview(balanceLabel)
    }
    
    func applyConstraints() {
        walletLogoImageView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(50)
            make.centerX.equalToSuperview()
        }
        balanceLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(walletLogoImageView)
            make.leading.trailing.equalToSuperview().inset(30)
        }
    }
}
struct HomeHeaderViewViewModel {
    let balance: String
}
