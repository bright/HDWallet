// 

import Foundation
import UIKit


class ImportWalletInfoVC: UIViewController {
    private let mainView = ImportWalletInfoView()
    var onContinue: (()->())?

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.continueButton.addTarget(self, action: #selector(restoreWalletAction), for: .touchUpInside)
        setUpFullscreenView(mainView: mainView)
    }
    
    @objc func restoreWalletAction() {
        onContinue?()
    }
}

