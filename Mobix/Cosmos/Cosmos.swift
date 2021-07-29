// 

import Foundation
import Combine
import HDWalletKit

enum CosmosError: Error {
    case couldNotFetchBalance
    case couldNotSaveKeystoreToFile
    case couldNotReadWalletFromFile
}

public struct Account: Codable {
    let bech32Address: String
    let walletUUID: String
}

protocol Provider {
    var host: String {get}
    var port: Int {get}
}

struct FetchAIMainnetProvider: Provider {
    var host = "rest-andromeda.t-v2-london-c.fetch-ai.com"
    var port = 443
}
extension Cosmos {
    struct Config {
        let provider: Provider
        let chainId: String
        let denom: String
    }
}

class Cosmos {
    private let defaultSession = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?
    var accountManager: AccountManager!
    let config: Config
    var address: String!

    init(config: Config) {
        self.config = config
    }
    
    func attachAccountManager(_ accountManager: AccountManager) {
        self.accountManager = accountManager
        self.address = accountManager.getAccount()!.bech32Address
    }
    
    func getBalances(completion: @escaping ((Result<CosmosBankV1beta1QueryAllBalancesResponse, CosmosError>)->())) {
        guard let account = accountManager.getAccount() else {
            completion(.failure(CosmosError.couldNotFetchBalance))
            return
        }
        let request = CosomosRequest.getBalance(address: account.bech32Address, provider: config.provider)
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
                    let balances = try decoder.decode(CosmosBankV1beta1QueryAllBalancesResponse.self, from: data)
                    completion(.success(balances))
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

    func onBroadcastTx(auth: CosmosAuthV1Beta1QueryAccountResponse, transactionInfo: TransactionInfo) -> AnyPublisher<Data, Error> {
        let pKey = accountManager.getPrivateKey()
        let reqTxBytes = Signer.genSignedSendTxBytes(auth, transactionInfo, pKey, config.chainId)
        let rawTransaction = RawTransaction(tx_bytes: reqTxBytes)
        let rawTransactionEncoded = try! JSONEncoder().encode(rawTransaction)
        let request = CosomosRequest.postRawTransaction(rawTransaction: rawTransactionEncoded, provider: config.provider)
        
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError{$0 as Error}
            .map{$0.data}            
            .eraseToAnyPublisher()
    }
    
    
    func fetchAuth() -> AnyPublisher<CosmosAuthV1Beta1QueryAccountResponse, Error>{
        let request = CosomosRequest.querryAccount(for: address, provider: config.provider)
        return URLSession.shared.dataTaskPublisher(for: request)
            .map{$0.data}
            .decode(type: CosmosAuthV1Beta1QueryAccountResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

