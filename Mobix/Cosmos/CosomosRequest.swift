// 

import Foundation

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
    
    static func postRawTransaction(rawTransaction: Data, provider: Provider) -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = provider.host
        components.path = "/cosmos/tx/v1beta1/txs"
        components.port = provider.port
        let url = components.url!
        var request = URLRequest(url: url)
        request.httpBody = rawTransaction
        request.httpMethod = "POST"
        return request
    }
    
    static func querryAccount(for address: String, provider: Provider) -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = provider.host
        components.path = "/auth/accounts/\(address)"
        components.port = provider.port
        let url = components.url!
        var request = URLRequest(url: url)
        return request
    }
}
