// 

import Foundation
import BigInt

public struct TransactionInfo: Codable {
    public var coin: Coin?
    public var toAddress: String
    public var fee: Fee?
    
    enum CodingKeys: String, CodingKey {
        case coin = "v"
        case toAddress = "a"
        case fee = "fee"
    }
    
    public init(coin: Coin? = nil, address: String) {
        self.coin = coin
        self.toAddress = address
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(coin, forKey: .coin)
        try container.encode(toAddress, forKey: .toAddress)
    }
}
