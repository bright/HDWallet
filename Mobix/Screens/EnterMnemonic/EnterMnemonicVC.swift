// 

import Foundation
import UIKit

class EnterMnemonicVC: UIViewController {
    private let mainView = EnterMnemonicView()
    var onContinue: (()->())?

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFullscreenView(mainView: mainView)
    }
}

