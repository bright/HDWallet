// 

import Foundation


struct ChainType {
    let addressHrp: String
    let chainId: String
    private init(addressHrp: String, chainId: String) {
        self.addressHrp = addressHrp
        self.chainId = chainId
    }
    static var FETCH_AI_MAIN: ChainType {
        return ChainType(addressHrp: "fetch", chainId: "andromeda-1")
    }
}
