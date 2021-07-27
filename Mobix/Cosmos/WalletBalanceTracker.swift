// 

import Foundation
import ActivityIndicator
import Combine
import BigInt

public class WalletBalanceTracker {
    
    public var balance: BigUInt?
    // By storing our subject in a private property, we'll only
    // be able to send new values to it from within this class:
    private let balanceSubject = CurrentValueSubject<String?, Never>(nil)
    var publisher: AnyPublisher<String?, Never> {
        // Here we're "erasing" the information of which type
        // that our subject actually is, only letting our outside
        // code know that it's a read-only publisher:
        balanceSubject.eraseToAnyPublisher()
    }
    private var account: Account!
    private var cosmos: Cosmos
    private let denom: String
    private var timer: Timer? {
        didSet {
            oldValue?.invalidate()
        }
    }
    public func startTracking(for account: Account) {
        self.account = account
        updateWalletBalance()
        startTracking()
    }
    
    init(cosmos: Cosmos, denom: String) {
        self.cosmos = cosmos
        self.denom = denom
    }
    
    public func startTracking() {
        print("will start tracking balance")
        self.timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { [weak self] _ in
            self?.updateWalletBalance()
        })
    }
    
    public func updateWalletBalance() {
        cosmos.getBalances { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let cosmosBaseV1beta1Coin):
                guard let balance = (cosmosBaseV1beta1Coin.balances.first {$0.denom == self.denom}) else {return}
                self.balance = BigUInt(balance.amount)
                self.balanceSubject.send(balance.amount)
//                print(cosmosBaseV1beta1Coin)
            case .failure(let error):
                print(error)
            }
        }
    }
}

struct CosmosBankV1beta1QueryAllBalancesResponse: Decodable {
  var balances: [CosmosBaseV1beta1Coin] = []
}

struct CosmosBaseV1beta1Coin: Decodable {

  var denom: String

  var amount: String
}
