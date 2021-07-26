// 

import Foundation

struct RawTransaction: Codable {
    let tx_bytes: Data
    var mode = "BROADCAST_MODE_SYNC"
}


