// 

import Foundation
import UIKit

class TradingFlowController: FlowController {
    var rootNavigationController: UINavigationController
    private let walletBalanceTracker: WalletBalanceTracker
    private let cosmos: Cosmos
    var onOpenMenu: (()->())?
    var onTokenChange: (()->())?
    private let currencyInfo: CurrencyInfo
    
    init(walletBalanceTracker: WalletBalanceTracker,
         currencyInfo: CurrencyInfo,
         cosmos: Cosmos,
         nv: UINavigationController) {
        self.cosmos = cosmos
        self.rootNavigationController = nv
        self.walletBalanceTracker = walletBalanceTracker
        self.currencyInfo = currencyInfo
    }
    
    func runFlow() {
        showEnterAddressScreen()
    }
    
    func showEnterAddressScreen() {
        let vc = EnterAddressVC(currencyInfo: currencyInfo)
        vc.onContinue = { [unowned self] transaction in
            self.showSetAmountScreen(transaction: transaction)
        }
        rootNavigationController.pushViewController(vc, animated: true)
    }
    
    func showConfirmTransactionScreen(_ transaction: TransactionInfo) {
        let vc = ConfirmTransactionVC(transaction,
                                      currencyInfo: currencyInfo,
                                      cosmos: cosmos,
                                      walletBalanceTracker: walletBalanceTracker)
        vc.onDone = { [unowned self] in
            self.rootNavigationController.popToRootViewController(animated: true)
        }
        vc.onCancell = { [unowned self] in
            self.rootNavigationController.popToRootViewController(animated: true)
        }
        vc.onScanAnotherCode = { [unowned self] in
            let scannerVC = rootNavigationController.viewControllers.first{$0 is ScannerVC}!
            self.rootNavigationController.popToViewController(scannerVC, animated: true)
        }
        rootNavigationController.pushViewController(vc, animated: true)
    }

    func showScannerVC() {
        let vc = ScannerVC(currencyInfo: currencyInfo)
        vc.onTransactionWithAmount = { [unowned self] transaction in
            self.showConfirmTransactionScreen(transaction)
        }
        vc.onTransactionWithoutAmount = { [unowned self] transaction in
            self.showSetAmountScreen(transaction: transaction)
        }
        vc.onEnterManually = { [unowned self] in
            self.showEnterAddressScreen()
        }
        rootNavigationController.pushViewController(vc, animated: true)
    }
    
    func showSetAmountScreen(transaction: TransactionInfo) {
        let vc = SetAmountVC(transaction: transaction, walletBalanceTracker: walletBalanceTracker, currencyInfo: currencyInfo, amountValidator: SendAmountValidator(walletBalanceTracker: walletBalanceTracker), transferType: .send)
        vc.onContinue = { [unowned self] transaction in
            self.showConfirmTransactionScreen(transaction)
        }
        rootNavigationController.pushViewController(vc, animated: true)
    }
}
