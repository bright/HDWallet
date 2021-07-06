//

import Foundation

protocol AmountValidator {
    var walletBalanceTracker: WalletBalanceTracker {get}
    func checkIfValidAmount(_ text: String) -> Bool
}

struct SendAmountValidator: AmountValidator {
    var walletBalanceTracker: WalletBalanceTracker
    func checkIfValidAmount(_ text: String) -> Bool {
        guard let currentBalance = walletBalanceTracker.balance,
              let amount =  Utils.parseToBigUInt(text)
        else {return false}
        return amount <= currentBalance
    }
}

struct ReceiveAmountValidator: AmountValidator {
    var walletBalanceTracker: WalletBalanceTracker
    func checkIfValidAmount(_ text: String) -> Bool {
        return Utils.parseToBigUInt(text) != nil
    }
}
