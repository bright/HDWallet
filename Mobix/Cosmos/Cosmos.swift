// 

import Foundation
import Combine
import HDWalletKit
import GRPC
import NIO
import KeychainAccess

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

class Cosmos {
    private let defaultSession = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?

    private let provider: Provider
    var account: Account!

    var address: String = try! AccountStore.shared.getAccount()!.bech32Address

    init(provider: Provider) {
        self.provider = provider
    }
    
    func attachAccount(_ account: Account) {
        self.account = account
    }
    
    func getBalances(completion: @escaping ((Result<CosmosBankV1beta1QueryAllBalancesResponse, CosmosError>)->())) {
        let request = CosomosRequest.getBalance(address: account.bech32Address, provider: provider)
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
                    print(balances)
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

    func onBroadcastGrpcTx() {
        let walletUUID = try! AccountStore.shared.getAccount()!.walletUUID
        let keychainAccess = Keychain(service: Constants.Auth.keychainServiceIdentifier)
        let words = keychainAccess[walletUUID]!
        let seed = Mnemonic.createSeed(mnemonic: words)
        let rootPrivateKey = PrivateKey(seed: seed, coin: .atom)
        
        let purpose = rootPrivateKey.derived(at: .hardened(44))
        let coinType = purpose.derived(at: .hardened(118))
        let account = coinType.derived(at: .hardened(0))
        let change = account.derived(at: .notHardened(0))
        // m/44'/118'/0'/0/0
        let pKey = change.derived(at: .notHardened(0))
        
        let toAddress = "fetch18r4zusmc0vzsn8l3ujzclyc80vpzc7dne9d7vr"
        let fee = Fee("200000", [Coin("stake", "50")])
        let amount = [Coin("stake", "60")]
        let reqTxBytes = Signer.genSignedSendTxBytes(pKey: pKey)
        
        
        let rawTransaction = RawTransaction(tx_bytes: reqTxBytes)
        let rawTransactionEncoded = try! JSONEncoder().encode(rawTransaction)
        let request = CosomosRequest.postRawTransaction(rawTransaction: rawTransactionEncoded, provider: provider)
        
        
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
                    print(data)
                    let responseData = String(data: data, encoding: .utf8)
                    let decoder = JSONDecoder()
                    let auth = try decoder.decode(CosmosAuthV1Beta1QueryAccountResponse.self, from: responseData)
                    print(responseData)
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
    
    
    func fetchAuth() {
        let request = CosomosRequest.querryAccount(for: address)

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
                    let responseData = String(data: data, encoding: .utf8)
                    print(responseData)
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
    
    private func getCallOptions() -> CallOptions {
        var callOptions = CallOptions()
        callOptions.timeLimit = TimeLimit.timeout(TimeAmount.milliseconds(80000))
        return callOptions
    }
    
    private func getConnection(_ group: MultiThreadedEventLoopGroup) -> ClientConnection {
        let host = "rpc-andromeda.fetch.ai"
        let port = 443
        return ClientConnection.insecure(group: group).connect(host: host, port: port)
    }
}

