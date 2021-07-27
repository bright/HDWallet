// 

import Foundation

public struct Coin: Codable {
    var denom: String = ""
    var amount: String = ""
    
    init(){}
    
    init(_ dictionary: [String: Any]) {
        self.denom = dictionary["denom"] as? String ?? ""
        self.amount = dictionary["amount"] as? String ?? ""
    }
    
    init(_ dictionary: NSDictionary?) {
        self.denom = dictionary?["denom"] as? String ?? ""
        self.amount = dictionary?["amount"] as? String ?? ""
    }
    
    init(_ denom:String, _ amount:String) {
        self.denom = denom
        self.amount = amount
    }

}
