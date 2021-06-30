// 

import Foundation
import KeychainAccess

class PasscodeRepository {
    private var keychainAccess: Keychain
    private let passcodeKey = "passcode"
    static let shared = PasscodeRepository()
    
    private init() {
        keychainAccess = Keychain(service: Constants.Auth.keychainServiceIdentifier)
    }
    
    func fetchPasscode() -> String? {
        return keychainAccess[passcodeKey]
    }
    
    func savePasscode(_ code: String?) {
        keychainAccess[passcodeKey] = code
    }
}
