// 

import Foundation
import BigInt

public struct TransactionInfo: Codable {
    public var amountOfTokens: BigUInt?
    public var address: String
    
    enum CodingKeys: String, CodingKey {
        case amountOfTokens = "v"
        case address = "a"
    }
    
    public init(amountOfTokens: BigUInt? = nil, address: String) {
        self.amountOfTokens = amountOfTokens
        self.address = address
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(amountOfTokens, forKey: .amountOfTokens)
        try container.encode(address, forKey: .address)
    }
}
