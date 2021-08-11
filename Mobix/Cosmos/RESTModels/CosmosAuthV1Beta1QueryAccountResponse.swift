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
            let publicKey: PublicKey?
            let accountNumber: String
            let sequence: String
            
            enum CodingKeys: String, CodingKey {
                case address
                case publicKey = "public_key"
                case accountNumber = "account_number"
                case sequence
                // MARK: - PublicKey
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                address = try container.decode(String.self, forKey: .address)
                publicKey = try? container.decode(PublicKey.self, forKey: .publicKey)
                accountNumber = try container.decode(String.self, forKey: .accountNumber)
                sequence = (try? container.decode(String.self, forKey: .sequence)) ?? "0"
            }
            struct PublicKey: Codable {
                let type, value: String
            }
        }
    }
}


