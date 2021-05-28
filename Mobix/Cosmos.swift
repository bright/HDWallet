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
    let address: String
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
    let provider: Provider
    // By storing our subject in a private property, we'll only
    // be able to send new values to it from within this class:
    private let balanceSubject = CurrentValueSubject<Cosmos_Base_V1beta1_Coin?, Never>(nil)
    var address: String = "iaa1cv7mhcylar04wpxrtz6n6chtmh0lu6dl5d5dsq"

    init(provider: Provider) {
        self.provider = provider
    }
    
    func attachKeystore() {
        
    }
    
    func refreshBalance() {
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
