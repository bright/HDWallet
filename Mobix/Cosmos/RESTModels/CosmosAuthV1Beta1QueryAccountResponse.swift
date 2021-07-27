// 

import Foundation

// MARK: - CosmosAuthV1Beta1QueryAccountResponse
struct CosmosAuthV1Beta1QueryAccountResponse: Codable {
    let height: String
    let result: Result
    // MARK: - Result
    struct Result: Codable {
        let type: String
        let value: Value
        // MARK: - Value
        struct Value: Codable {
            let address: String
            let publicKey: PublicKey
            let accountNumber: String
            let sequence: String?
            
            enum CodingKeys: String, CodingKey {
                case address
                case publicKey = "public_key"
                case accountNumber = "account_number"
                case sequence
                // MARK: - PublicKey
            }
            struct PublicKey: Codable {
                let type, value: String
            }
        }
    }
}


