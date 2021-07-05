// 

import UIKit
import Combine

class HomeVC: UITableViewController {
    private var publishers = [AnyCancellable]()
    var onTransferTap: ((CurrencyInfo)->())?
    private var headerView: HomeHeaderView!
    var onOpenMenu: (()->())?
    private let cosmos: Cosmos
    private var balanceTracker: WalletBalanceTracker
    init(walletBalanceTracker: WalletBalanceTracker,
         cosmos: Cosmos) {
        self.cosmos = cosmos
        self.balanceTracker = walletBalanceTracker
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
        balanceTracker.publisher.sink { [unowned self] value in
            guard let value = value else {return}
            let vm = HomeHeaderViewViewModel(balance: value)
            DispatchQueue.main.async {
                self.headerView.configure(with: vm)
            }
        }.store(in: &publishers)
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
        headerView.transferButton.addTarget(self, action: #selector(transferButtonTap), for: .touchUpInside)
    }
    
    @objc func transferButtonTap() {
        let currencyInfo = CurrencyInfo(name: "Mobix", symbol: "MOBX")
        onTransferTap?(currencyInfo)
    }
    
}


