// 

import Foundation
import GRPC
import NIO
import SwiftProtobuf
import Combine

enum CosmosError: Error {
    case couldNotFetchBalance
}

struct Wallet {
    let bech32Address: String
    let keystore: Data
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
    var host = "lcd-iris-app.cosmostation.io"
    var port = 9090
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
    var address: String = "iaa1cv7mhcylar04wpxrtz6n6chtmh0lu6dl5d5dsq"

    init(provider: Provider) {
        self.provider = provider
    }
    
    func attachKeystore(_ data: Data) {
        keystore = data
    }
    
    func fetchBalance() {
        DispatchQueue.global().async {
            let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
            defer { try! group.syncShutdownGracefully() }
            
            let channel = self.getConnection(group)
            defer { try! channel.close().wait() }
            
            let req = Cosmos_Bank_V1beta1_QueryBalanceRequest.with {
                $0.address = self.address
                $0.denom = "uatom"
            }
            do {
                let response = try Cosmos_Bank_V1beta1_QueryClient(channel: channel).balance(req, callOptions: self.getCallOptions()).response.wait()
//                print("onFetchgRPCBalance: \(response.balances)")
                print(response)
                let balance = response.balance
                self.balanceSubject.send(balance)
            } catch {
                print("onFetchgRPCBalance failed: \(error)")
            }
        }
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

import BitcoinKit

class Utils {
    static func getPubToDpAddress(_ pubHex:String, _ chain:ChainType) -> String {
        var result = ""
        let sha256 = Crypto.sha256(Data.fromHex(pubHex)!)
        let ripemd160 = Crypto.ripemd160(sha256)
        if (chain == ChainType.FETCH_AI_MAIN) {
            result = try! SegwitAddrCoder.shared.encode2(hrp: "fetch", program: ripemd160)
        }
       
        return result
    }
}

enum ChainType: String {
    case FETCH_AI_MAIN
}
