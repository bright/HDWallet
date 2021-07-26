// 

import Foundation
import CommonCrypto
import HDWalletKit
import CryptoSwift
import KeychainAccess


class HDWalletProvider {
    static let mnemonic = "join column ridge cook craft menu purchase owner rough grid poet piece leisure meat baby crystal obscure action coach false kid point meat bronze"

    static func generateWallet(chainType: ChainType, password: String) -> Account {
//        let mnemonic = Mnemonic.create()

        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let rootPrivateKey = PrivateKey(seed: seed, coin: .atom)
        
        let purpose = rootPrivateKey.derived(at: .hardened(44))

        // m/44'/118'
        let coinType = purpose.derived(at: .hardened(118))

        // m/44'/118'/0'
        let account = coinType.derived(at: .hardened(0))

        // m/44'/118'/0'/0
        let change = account.derived(at: .notHardened(0))

        // m/44'/118'/0'/0/0
        let firstPrivateKey = change.derived(at: .notHardened(0))
        let firstPublicKeyCompressed = firstPrivateKey.publicKey.get()
        
        let address = getPubToDpAddress(firstPublicKeyCompressed, chainType.addressHrp)
        let walletUUID = UUID().uuidString
        let keychain = Keychain(service: Constants.Auth.keychainServiceIdentifier)
        keychain[walletUUID] = mnemonic
        return Account(bech32Address: address, walletUUID: walletUUID)
    }
    
    static func getPubToDpAddress(_ pubHex:String, _ hrp: String) -> String {
        var result = ""
        let dataPub = Data.fromHex(pubHex)!
        let sha256 = dataPub.sha256()
        let ripemd160 = RIPEMD160.hash(message: sha256)
        result = try! SegwitAddrCoder.shared.encode2(hrp: "fetch", program: ripemd160)
        return result
    }
}
