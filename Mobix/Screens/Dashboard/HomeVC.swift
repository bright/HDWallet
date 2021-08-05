// 

import UIKit
import Combine

class HomeVC: UIViewController {
    private let mainView = HomeView()
    var onReceive: ((CurrencyInfo)->())?
    private var publishers = [AnyCancellable]()
    var onTransfer: ((CurrencyInfo)->())?
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
        title = "mobix_wallet".localized
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: Fonts.barlowBold.withSize(18), .foregroundColor: UIColor.white]

        setUpFullscreenView(mainView: mainView)
        addMenuBarButtonItem()
        cosmos.attachAccountManager(AccountManager.shared)
        balanceTracker.startTracking(for: AccountManager.shared.account!)
        balanceTracker.publisher.sink { [unowned self] value in
            guard let value = value else {return}
            var formatted = Utils.formatToPrecision(value, numberDecimals: 9, formattingDecimals: 2, decimalSeparator: ",", fallbackToScientific: false)
            formatted?.append(" MOBX")
            let vm = HomeViewViewModel(balance: formatted ?? "")
            DispatchQueue.main.async {
                self.mainView.configure(with: vm)
            }
        }.store(in: &publishers)
        
        mainView.sendButton.addTarget(self, action: #selector(sendAction), for: .touchUpInside)
        mainView.receiveButton.addTarget(self, action: #selector(receiveAction), for: .touchUpInside)
    }

    @objc func openMenu() {
        onOpenMenu?()
    }
    
    private func addMenuBarButtonItem() {
        let item = UIBarButtonItem()
        let menuButton = UIButton()
        menuButton.setImage(UIImage(named: "menu")?.withTintColor(.white), for: .normal)
        menuButton.addTarget(self, action: #selector(openMenu), for: .touchUpInside)
        item.customView = menuButton
        item.customView?.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        navigationItem.leftBarButtonItem = item
    }
    
    
    @objc func sendAction() {
        let currencyInfo = CurrencyInfo(name: "Mobix", symbol: "MOBX")
        onTransfer?(currencyInfo)
    }
    
    @objc func receiveAction() {
        let currencyInfo = CurrencyInfo(name: "Mobix", symbol: "MOBX")
        onReceive?(currencyInfo)
    }
    
}


