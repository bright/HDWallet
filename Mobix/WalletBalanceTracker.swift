// 

import Foundation
import ActivityIndicator

@objc public class WalletBalanceTracker: NSObject {
    private let defaultSession = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?
    public func received(message: Any) {
        print(message)
    }
    
    public func gotError(error: Error) {
        print(error)
    }
    
    private var walletStore: AccountStore = AccountStore.shared
    @objc dynamic public var balanceFormattedDescription: String = ""
//    public var balance: BigUInt?
    static let shared = WalletBalanceTracker()
    private var account: Account!
    private var timer: Timer? {
        didSet {
            oldValue?.invalidate()
        }
    }
    public func startTracking(for account: Account) {
        self.account = account
        startTracking()
    }
    
    private override init() {
        super.init()
    }
    
    public func startTracking() {
        print("will start tracking balance")
        self.timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { [weak self] _ in
            self?.updateWalletBalance()
        })
    }
    
    public func updateWalletBalance() {
        let request = getRequest()
        dataTask = defaultSession.dataTask(with: request) { [weak self] data, response, error in
            defer {
                self?.dataTask = nil
            }
            if let error = error {
                print(error)
            } else if let data = data,
                      let response = response as? HTTPURLResponse,
                      response.statusCode == 200 {
                do {
                    let decoder = JSONDecoder()
                    let balance = try decoder.decode(CosmosBankV1beta1QueryAllBalancesResponse.self, from: data)
                    print(balance)
                } catch {
                    print(error)
                }
            } else if let response = response as? HTTPURLResponse,
                      response.statusCode >= 400 {
                print(error)
            }
        }
        dataTask?.resume()
    }
    
    private func getRequest() -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "rest-stargateworld.t-v2-london-c.fetch-ai.com"
        components.path = "/cosmos/bank/v1beta1/balances/\(account.bech32Address)"
        components.port = 443
        let url = components.url!
        let request = URLRequest(url: url)
        return request
    }
}

struct CosmosBankV1beta1QueryAllBalancesResponse: Decodable {
  var balances: [CosmosBaseV1beta1Coin] = []
}

struct CosmosBaseV1beta1Coin: Decodable {

  var denom: String

  var amount: String
}
