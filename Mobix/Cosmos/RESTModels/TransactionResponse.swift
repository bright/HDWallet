// 

import Foundation


// MARK: - TrensactionResponse
struct TransactionResponse: Codable {
    let txResponse: TxResponse

    enum CodingKeys: String, CodingKey {
        case txResponse = "tx_response"
    }
}

// MARK: - TxResponse
extension TransactionResponse {
    struct TxResponse: Codable {
        let height, txhash, codespace: String
        let code: Int
        let data, rawLog, info, gasWanted: String
        let gasUsed, timestamp: String
        
        enum CodingKeys: String, CodingKey {
            case height, txhash, codespace, code, data
            case rawLog = "raw_log"
            case info
            case gasWanted = "gas_wanted"
            case gasUsed = "gas_used"
            case timestamp
        }
    }
}
