// 

import UIKit

class DashboardTableVC: UITableViewController {
//    let cancellable = Cosmos.shared.publisher.sink { (cosmosCoin) in
//        print(cosmosCoin)
//    }
    var onOpenMenu: (()->())?
    let balanceTracker = WalletBalanceTracker.shared

    let cosmos = Cosmos(provider: FetchAIMainnetProvider())
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
        balanceTracker.startTracking(for: account)
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
    
}


