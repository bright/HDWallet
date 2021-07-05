//

import Foundation
import BigInt

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

struct Utils {
    public static func parseToBigUInt(_ amount: String, decimals: Int = 18) -> BigUInt? {
        let separators = CharacterSet(charactersIn: ".,")
        let components = amount.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: separators)
        guard components.count == 1 || components.count == 2 else {return nil}
        let unitDecimals = decimals
        guard let beforeDecPoint = BigUInt(components[0], radix: 10) else {return nil}
        var mainPart = beforeDecPoint*BigUInt(10).power(unitDecimals)
        if (components.count == 2) {
            let numDigits = components[1].count
            guard numDigits <= unitDecimals else {return nil}
            guard let afterDecPoint = BigUInt(components[1], radix: 10) else {return nil}
            let extraPart = afterDecPoint*BigUInt(10).power(unitDecimals-numDigits)
            mainPart = mainPart + extraPart
        }
        return mainPart
    }
}
