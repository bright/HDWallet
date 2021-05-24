// 

import UIKit

class BackupVC: UIViewController {
    var onNext: (()->())?
    var mainView: BackupView
    
    init(){
        self.mainView = BackupView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "create_wallet".localized
        setUpFullscreenView(mainView: mainView)
        mainView.button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    @objc func buttonAction() {
        backupWallet()
    }
    
    private func backupWallet() {
//        var keyDataUrl: URL?
//        do {
//            let wallet = try WalletStore.shared.getWallet()!
//            keyDataUrl = try WalletHelper.convertKeystoreToTextFile(wallet)
//        } catch {
//            print(error)
//        }
//        guard keyDataUrl != nil else {return}
//        let activityViewController = UIActivityViewController(activityItems: [keyDataUrl!], applicationActivities: nil)
//        activityViewController.completionWithItemsHandler = { [weak self] (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
//            if completed {
//                self?.onNext?()
//            }
//        }
//           self.present(activityViewController, animated: true, completion: nil)
    }

}
