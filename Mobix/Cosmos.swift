// 

import Foundation
import GRPC
import NIO
import SwiftProtobuf
import Combine

enum CosmosError: Error {
    case couldNotFetchBalance
}

struct Wallet {
    let bech32Address: String
    let keystore: Data
}
//
//class CosmosClient {
//    static var shared = CosmosClient()
//    let cosmos: Cosmos
//    private init() {
//        self.cosmos = Cosmos(provider: FetchAIMainnetProvider())
//    }
//
//}

protocol Provider {
    var host: String {get}
    var port: Int {get}
}

struct FetchAIMainnetProvider: Provider {
    var host = "lcd-iris-app.cosmostation.io"
    var port = 9090
}

class Cosmos {
    var publisher: AnyPublisher<Cosmos_Base_V1beta1_Coin?, Never> {
        // Here we're "erasing" the information of which type
        // that our subject actually is, only letting our outside
        // code know that it's a read-only publisher:
        balanceSubject.eraseToAnyPublisher()
    }
    private let provider: Provider
    var keystore: Data?
    // By storing our subject in a private property, we'll only
    // be able to send new values to it from within this class:
    private let balanceSubject = CurrentValueSubject<Cosmos_Base_V1beta1_Coin?, Never>(nil)
    var address: String = "iaa1cv7mhcylar04wpxrtz6n6chtmh0lu6dl5d5dsq"

    init(provider: Provider) {
        self.provider = provider
    }
    
    func attachKeystore(_ data: Data) {
        keystore = data
    }
    
    func fetchBalance() {
        DispatchQueue.global().async {
            let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
            defer { try! group.syncShutdownGracefully() }
            
            let channel = self.getConnection(group)
            defer { try! channel.close().wait() }
            
            let req = Cosmos_Bank_V1beta1_QueryBalanceRequest.with {
                $0.address = self.address
                $0.denom = "uatom"
            }
            do {
                let response = try Cosmos_Bank_V1beta1_QueryClient(channel: channel).balance(req, callOptions: self.getCallOptions()).response.wait()
//                print("onFetchgRPCBalance: \(response.balances)")
                print(response)
                let balance = response.balance
                self.balanceSubject.send(balance)
            } catch {
                print("onFetchgRPCBalance failed: \(error)")
            }
        }
    }
    
    func transfer() {
        
    }
    
    private func getCallOptions() -> CallOptions {
        var callOptions = CallOptions()
        callOptions.timeLimit = TimeLimit.timeout(TimeAmount.milliseconds(8000))
        return callOptions
    }
    
    private func getConnection(_ group: MultiThreadedEventLoopGroup) -> ClientConnection {
        return ClientConnection.insecure(group: group).connect(host: provider.host, port: provider.port)
    }
}



import CommonCrypto
import HDWalletKit
import CryptoSwift



class Crypto {
    static func getSeedFromMnemonic() -> Data {
        let mnemonic = "join column ridge cook craft menu purchase owner rough grid poet piece leisure meat baby crystal obscure action coach false kid point meat bronze"
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        print(seed.toHexString())
        return seed

    }
    
    static func test() {
        let seed = getSeedFromMnemonic()
        
        print("seed: \(seed.hexEncodedString())")
        let rootPrivateKey = PrivateKey(seed: seed, coin: .atom)
        let rootPubkey = PublicKey(base58: rootPrivateKey.publicKey.data, coin: .bitcoin)
        print("root pub \(rootPubkey.uncompressedPublicKey.dataToHexString())")
        
   
        
        let purpose = rootPrivateKey.derived(at: .hardened(44))

        // m/44'/118'
        let coinType = purpose.derived(at: .hardened(118))

        // m/44'/118'/0'
        let account = coinType.derived(at: .hardened(0))

        // m/44'/118'/0'/0
        let change = account.derived(at: .notHardened(0))

        // m/44'/118'/0'/0/0
        let firstPrivateKey = change.derived(at: .notHardened(0))
        let raw = firstPrivateKey.raw
        print("uncompressed: \(firstPrivateKey.wifUncompressed())\n\n")
        print("compressed: \(firstPrivateKey.wifCompressed())")
        print("raw: \(raw.toHexString())\n\n")

        let publicUncomp = firstPrivateKey.publicKey.uncompressedPublicKey.dataToHexString()
        
        print("pub uncompressed: \(publicUncomp)\n\n")
        let pubComp = firstPrivateKey.publicKey.compressedPublicKey.dataToHexString()
        print("pub compressed: \(pubComp)\n\n")
        let firstPublicKey = firstPrivateKey.publicKey
        
        print(getPubToDpAddress(firstPublicKey.get(), "cosmos"))


       
    }
    

    
    static func getPubToDpAddress(_ pubHex:String, _ hrp: String) -> String {
        var result = ""
        let dataPub = Data.fromHex(pubHex)!
        let sha256 = dataPub.sha256()
        print(sha256.dataToHexString())
        let ripemd160 = RIPEMD160.hash(message: sha256)

        print("ripemd160: \(ripemd160.dataToHexString()))")

        result = try! SegwitAddrCoder.shared.encode2(hrp: "cosmos", program: ripemd160)

       
        return result
    }
    
    static func sha256(data : Data) -> Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return Data(hash)
    }
    
    
    
    
}

enum ChainType: String {
    case FETCH_AI_MAIN
}


extension Data{
//    public func sha256() -> String{
//        return hexStringFromData(input: digest(input: self as NSData))
//    }
    
    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
    
    private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }
        
        return hexString
    }
}
//
//public extension String {
//    func sha256() -> String{
//        if let stringData = self.data(using: String.Encoding.utf8) {
//            return stringData.sha256()
//        }
//        return ""
//    }
//}


import secp256k1

// swiftlint:disable:next type_name
class _SwiftKey {
    public static func computePublicKey(fromPrivateKey privateKey: Data, compression: Bool) -> Data {
        guard let ctx = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN)) else {
            return Data()
        }
        defer { secp256k1_context_destroy(ctx) }
        var pubkey = secp256k1_pubkey()
        var seckey: [UInt8] = privateKey.map { $0 }
        if seckey.count != 32 {
            return Data()
        }
        if secp256k1_ec_pubkey_create(ctx, &pubkey, &seckey) == 0 {
            return Data()
        }
        if compression {
            var serializedPubkey = [UInt8](repeating: 0, count: 33)
            var outputlen = 33
            if secp256k1_ec_pubkey_serialize(ctx, &serializedPubkey, &outputlen, &pubkey, UInt32(SECP256K1_EC_COMPRESSED)) == 0 {
                return Data()
            }
            if outputlen != 33 {
                return Data()
            }
            return Data(serializedPubkey)
        } else {
            var serializedPubkey = [UInt8](repeating: 0, count: 65)
            var outputlen = 65
            if secp256k1_ec_pubkey_serialize(ctx, &serializedPubkey, &outputlen, &pubkey, UInt32(SECP256K1_EC_UNCOMPRESSED)) == 0 {
                return Data()
            }
            if outputlen != 65 {
                return Data()
            }
            return Data(serializedPubkey)
        }
    }
}
