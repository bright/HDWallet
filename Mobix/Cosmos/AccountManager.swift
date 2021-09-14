
import Foundation
import CommonCrypto
import HDWalletKit
import CryptoSwift
import KeychainAccess

class AccountManager {
    static let shared = AccountManager()
    var account: Account?
    var accountStore: AccountStore
    private init(accountStore: AccountStore = AccountStore()) {
        self.accountStore = accountStore
        self.account = try? accountStore.getAccount()
    }
    
    func getPrivateKey() -> PrivateKey {
        let walletUUID = try! accountStore.getAccount()!.walletUUID
        let keychainAccess = Keychain(service: Constants.Auth.keychainServiceIdentifier)
        let words = keychainAccess[walletUUID]!
        let seed = Mnemonic.createSeed(mnemonic: words)
        let rootPrivateKey = PrivateKey(seed: seed, coin: .bitcoin)
        
        let purpose = rootPrivateKey.derived(at: .hardened(44))
        let coinType = purpose.derived(at: .hardened(118))
        let account = coinType.derived(at: .hardened(0))
        let change = account.derived(at: .notHardened(0))
        // m/44'/118'/0'/0/0
        let pKey = change.derived(at: .notHardened(0))
        return pKey
    }
    
    func getMnemonicPhrases() -> String? {
        let keychainAccess = Keychain(service: Constants.Auth.keychainServiceIdentifier)
        let phrases = keychainAccess[account!.walletUUID]
        return phrases
    }
    
    func getAccount() -> Account? {
        return account
    }
    
    func generateWallet(chainType: ChainType, password: String) -> Account {
        var mnemonic = Mnemonic.create()

//        #if DEBUG
//        mnemonic = "join column ridge cook craft menu purchase owner rough grid poet piece leisure meat baby crystal obscure action coach false kid point meat bronze"
//        #endif
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let rootPrivateKey = PrivateKey(seed: seed, coin: .bitcoin)
        let purpose = rootPrivateKey.derived(at: .hardened(44))

        // m/44'/118'
        let coinType = purpose.derived(at: .hardened(118))

        // m/44'/118'/0'
        let accountPath = coinType.derived(at: .hardened(0))

        // m/44'/118'/0'/0
        let change = accountPath.derived(at: .notHardened(0))

        // m/44'/118'/0'/0/0
        let firstPrivateKey = change.derived(at: .notHardened(0))
        let firstPublicKeyCompressed = firstPrivateKey.publicKey.get()
        
        let address = getPubToDpAddress(firstPublicKeyCompressed, chainType.addressHrp)
        let walletUUID = UUID().uuidString
        let keychain = Keychain(service: Constants.Auth.keychainServiceIdentifier)
        keychain[walletUUID] = mnemonic
        account = Account(bech32Address: address, walletUUID: walletUUID)
        try! accountStore.setAccount(account: account!)
        return account!
    }
    
    private func getPubToDpAddress(_ pubHex:String, _ hrp: String) -> String {
        var result = ""
        let dataPub = Data.fromHex(pubHex)!
        let sha256 = dataPub.sha256()
        let ripemd160 = RIPEMD160.hash(message: sha256)
        result = try! SegwitAddrCoder.shared.encode2(hrp: "fetch", program: ripemd160)
        return result
    }
}
