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
    var host = "rest-stargateworld.t-v2-london-c.fetch-ai.com"
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
    
    
    
    
    func transfer() {
        let walletUUID = try! AccountStore.shared.getAccount()!.walletUUID
        let keychainAccess = Keychain(service: Constants.Auth.keychainServiceIdentifier)
        let words = keychainAccess[walletUUID]!.split(separator: " ").map{String($0)}
        let reqTx = Signer.genSignedSendTxgRPC(<#T##auth: Cosmos_Auth_V1beta1_QueryAccountResponse##Cosmos_Auth_V1beta1_QueryAccountResponse#>, <#T##toAddress: String##String#>, <#T##amount: Array<Coin>##Array<Coin>#>, <#T##fee: Fee##Fee#>, <#T##memo: String##String#>, <#T##pKey: <<error type>>##<<error type>>#>, <#T##chainId: String##String#>)
        
        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        defer { try! group.syncShutdownGracefully() }
        
        let channel = BaseNetWork.getConnection(self.pageHolderVC.chainType!, group)!
        defer { try! channel.close().wait() }
        
        do {
            let response = try Cosmos_Tx_V1beta1_ServiceClient(channel: channel).broadcastTx(reqTx).response.wait()
//                print("response ", response.txResponse.txhash)
            DispatchQueue.main.async(execute: {
                if (self.waitAlert != nil) {
                    self.waitAlert?.dismiss(animated: true, completion: {
                        self.onStartTxDetailgRPC(response)
                    })
                }
            });
        } catch {
            print("onBroadcastGrpcTx failed: \(error)")
        }
    }
}




struct ChainType {
    let addressHrp: String
    private init(addressHrp: String) {
        self.addressHrp = addressHrp
    }
    static var FETCH_AI_MAIN: ChainType {
        return ChainType(addressHrp: "fetch")
    }
}

class CosomosRequest {
    static func getBalance(address: String, provider: Provider) -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = provider.host
        components.path = "/cosmos/bank/v1beta1/balances/\(address)"
        components.port = provider.port
        let url = components.url!
        let request = URLRequest(url: url)
        return request
    }
}

