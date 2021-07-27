//

import Foundation

public class AccountStore {
    let queue = DispatchQueue(label: "com.datarella.mobix.account_store", qos: .userInitiated)
    private var account: Account?
    private let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private let repositoryName = "wallet_repository"
    
    init() {}
    
    public func getAccount() throws -> Account? {
        try queue.sync {
            if let account = account {
                return account
            } else {
                do {
                    if let account = try readAccountFromFile() {
                        return account
                    } else {
                        return nil
                    }
                } catch {
                    throw error
                }
            }
        }
    }
    
    public func setAccount(account: Account) throws {
        try queue.sync {
            do {
                try saveAccountInFiles(account: account)
                self.account = account
            } catch {
                throw error
            }
        }
    }
    
    private func saveAccountInFiles(account: Account) throws {
        print("Saving keydata...")
        do {
            let jsonData = try JSONEncoder().encode(account)
            let fileURL = documentsURL.appendingPathComponent(repositoryName)
            try jsonData.write(to: fileURL, options: .completeFileProtection)
            print("wallet saved successfully.")
        } catch {
            print("Could not save wallet to file.")
            throw CosmosError.couldNotSaveKeystoreToFile
        }
    }
    
    private func readAccountFromFile() throws -> Account? {
        print("Reading wallet...")
        let fileUrl = documentsURL.appendingPathComponent(repositoryName)
        if FileManager.default.fileExists(atPath: fileUrl.path) {
            print("keydata file exist.")
            do {
                let data = try Data(contentsOf: fileUrl)
                let wallet = try JSONDecoder().decode(Account.self, from: data)
                print("Successfully read keydata.")
                return wallet
            } catch {
                print(error)
                throw CosmosError.couldNotReadWalletFromFile
            }
        }
        print("Reading keydata failed. File does not exist.")
        return nil
    }
}
