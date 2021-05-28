// 

import Foundation
import GRPC
import NIO
import SwiftProtobuf
import Combine

enum CosmosError: Error {
    case couldNotFetchBalance
}

class Cosmos {
    
    static var shared = Cosmos()
    
    var publisher: AnyPublisher<Cosmos_Base_V1beta1_Coin?, Never> {
        // Here we're "erasing" the information of which type
        // that our subject actually is, only letting our outside
        // code know that it's a read-only publisher:
        subject.eraseToAnyPublisher()
    }

    // By storing our subject in a private property, we'll only
    // be able to send new values to it from within this class:
    private let subject = CurrentValueSubject<Cosmos_Base_V1beta1_Coin?, Never>(nil)
    var address: String = "iaa1cv7mhcylar04wpxrtz6n6chtmh0lu6dl5d5dsq"

    
    private init() {}
    
    
    func onFetchgRPCNodeInfo() {
        DispatchQueue.global().async {
            let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
            defer { try! group.syncShutdownGracefully() }
            
            let channel = self.getConnection(group)
            defer { try! channel.close().wait() }
            
            let req = Cosmos_Base_Tendermint_V1beta1_GetNodeInfoRequest()
            
            do {
                let response = try Cosmos_Base_Tendermint_V1beta1_ServiceClient(channel: channel).getNodeInfo(req).response.wait()
                print(response)
            } catch {
                print("onFetchgRPCNodeInfo failed: \(error)")
            }
            
        }
    }
    
    func getConnection(_ group: MultiThreadedEventLoopGroup) -> ClientConnection {
        return ClientConnection.insecure(group: group).connect(host: "lcd-iris-app.cosmostation.io", port: 9090)
    }
    
    
    
    func fetchBalance(_ address: String, _ offset:Int) {
//        print("onFetchgRPCDelegations")
        DispatchQueue.global().async {
            let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
            defer { try! group.syncShutdownGracefully() }
            
            let channel = self.getConnection(group)
            defer { try! channel.close().wait() }
            
            let req = Cosmos_Bank_V1beta1_QueryAllBalancesRequest.with {
                $0.address = address
            }
            do {
                let response = try Cosmos_Bank_V1beta1_QueryClient(channel: channel).allBalances(req, callOptions: self.getCallOptions()).response.wait()
//                print("onFetchgRPCBalance: \(response.balances)")
                response.balances.forEach { balance in
                    print(balance)
                }
                
            } catch {
                print("onFetchgRPCBalance failed: \(error)")
            }
        }
    }
    
    func fetchCosmosCoin() {
//        print("onFetchgRPCDelegations")
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
                let response = try Cosmos_Bank_V1beta1_QueryClient(channel: channel).balance(req).response.wait()
//                print("onFetchgRPCBalance: \(response.balances)")
                print(response)
                let balance = response.balance
                self.subject.send(balance)
            } catch {
                print("onFetchgRPCBalance failed: \(error)")
            }
        }
    }
    
    func getCallOptions() -> CallOptions {
        var callOptions = CallOptions()
        callOptions.timeLimit = TimeLimit.timeout(TimeAmount.milliseconds(8000))
        return callOptions
    }
}
