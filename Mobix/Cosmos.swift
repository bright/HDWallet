// 

import Foundation
import GRPC
import NIO
import SwiftProtobuf
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
//
//class CosmosClient {
//    static var shared = CosmosClient()
//    let cosmos: Cosmos
//    private init() {
//        self.cosmos = Cosmos(provider: FetchAIMainnetProvider())
//    }
//
//}

protocol Provider {
    var host: String {get}
    var port: Int {get}
}

struct FetchAIMainnetProvider: Provider {
    var host = "rpc-stargateworld.t-v2-london-c.fetch-ai.com"
    var port = 443
}

class Cosmos {
    var publisher: AnyPublisher<Cosmos_Base_V1beta1_Coin?, Never> {
        // Here we're "erasing" the information of which type
        // that our subject actually is, only letting our outside
        // code know that it's a read-only publisher:
        balanceSubject.eraseToAnyPublisher()
    }
    private let provider: Provider
    var keystore: Data?
    // By storing our subject in a private property, we'll only
    // be able to send new values to it from within this class:
    private let balanceSubject = CurrentValueSubject<Cosmos_Base_V1beta1_Coin?, Never>(nil)
    var address: String = try! AccountStore.shared.getAccount()!.bech32Address

    init(provider: Provider) {
        self.provider = provider
    }
    
    func attachKeystore(_ data: Data) {
        keystore = data
    }
    
    func fetchBalance() {

    }
    
    func transfer() {
        
    }
    
    private func getCallOptions() -> CallOptions {
        var callOptions = CallOptions()
        callOptions.timeLimit = TimeLimit.timeout(TimeAmount.milliseconds(8000))
        return callOptions
    }
    
    private func getConnection(_ group: MultiThreadedEventLoopGroup) -> ClientConnection {
        return ClientConnection.insecure(group: group).connect(host: provider.host, port: provider.port)
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

