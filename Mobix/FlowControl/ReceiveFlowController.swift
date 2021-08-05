// 

import Foundation
import UIKit

class ReceiveFlowController: FlowController {
    var onFlowFinish: (()->())?
    private let rootNavigationController: UINavigationController
    private let currencyInfo: CurrencyInfo
    private let walletBalanceTracker: WalletBalanceTracker
    private let cosmos: Cosmos
    
    init(_ rootNavigationController: UINavigationController,
         walletBalanceTracker: WalletBalanceTracker,
         currencyInfo: CurrencyInfo,
         cosmos: Cosmos) {
        self.currencyInfo = currencyInfo
        self.rootNavigationController = rootNavigationController
        self.walletBalanceTracker = walletBalanceTracker
        self.cosmos = cosmos
    }
    
    func runFlow() {
        showRequestStartScreen(address: cosmos.address)
    }
    
//    func showSetAmountScreen(transaction: TransactionInfo) {
//        let vc = SetAmountVC(transaction: transaction, walletBalanceTracker: walletBalanceTracker, currencyInfo: currencyInfo, amountValidator: ReceiveAmountValidator(walletBalanceTracker: walletBalanceTracker), transferType: .receive)
//        vc.onContinue = { [unowned self] transaction in
//            self.showRequestAmountScreen(transaction: transaction)
//        }
//        rootNavigationController.pushViewController(vc, animated: true)
//    }
//
//    private func showRequestAmountScreen(transaction: TransactionInfo) {
//        let vc = RequestAmountVC(transaction: transaction, currencyInfo: currencyInfo)
//        vc.onContinue = { [unowned self] transaction in
//            self.showWaitingForPaymentScreen()
//        }
//        vc.onScaleUp = { [unowned self] transaction in
//            self.showQRCodeZoomScreen(transaction)
//        }
//        rootNavigationController.pushViewController(vc, animated: true)
//    }
    
    private func showRequestStartScreen(address: String) {
        let vc = RequestStartVC(currencyInfo: currencyInfo, address: address)
        vc.onScaleUp = { [unowned self] transaction in
            self.showQRCodeZoomScreen(transaction)
        }
        vc.onSetAmount = { [unowned self] transaction in
          //  self.showSetAmountScreen(transaction: transaction)
        }
        vc.onDisappeared = { [unowned self] in
            self.onFlowFinish?()
        }
        rootNavigationController.pushViewController(vc, animated: true)
    }
    
    private func showQRCodeZoomScreen(_ transaction: TransactionInfo) {
        let vc = QRCodeZoomVC(transaction: transaction)
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        rootNavigationController.present(vc, animated: true, completion: nil)
    }

}
