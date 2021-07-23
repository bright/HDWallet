// 

import Foundation
import HDWalletKit

class Signer {
    
    static func genSignedSendTxgRPC(_ auth: Cosmos_Auth_V1beta1_QueryAccountResponse,
                                    _ toAddress: String, _ amount: Array<Coin>, _ fee: Fee, _ memo: String,
                                    _ pKey: PrivateKey, _ chainId: String)  -> Cosmos_Tx_V1beta1_BroadcastTxRequest{
        let sendCoin = Cosmos_Base_V1beta1_Coin.with {
            $0.denom = amount[0].denom
            $0.amount = amount[0].amount
        }
        let sendMsg = Cosmos_Bank_V1beta1_MsgSend.with {
//            $0.fromAddress = WUtils.onParseAuthGrpc(auth).0!
            $0.toAddress = toAddress
            $0.amount = [sendCoin]
        }
        let anyMsg = Google_Protobuf2_Any.with {
            $0.typeURL = "/cosmos.bank.v1beta1.MsgSend"
            $0.value = try! sendMsg.serializedData()
        }
        let txBody = getGrpcTxBody([anyMsg], memo);
        let signerInfo = getGrpcSignerInfo(auth, pKey);
        let authInfo = getGrpcAuthInfo(signerInfo, fee);
        let rawTx = getGrpcRawTx(auth, txBody, authInfo, pKey, chainId);
        return Cosmos_Tx_V1beta1_BroadcastTxRequest.with {
            $0.mode = Cosmos_Tx_V1beta1_BroadcastMode.async
            $0.txBytes = try! rawTx.serializedData()
        }
    }
    
    
    static func getGrpcRawTx(_ auth: Cosmos_Auth_V1beta1_QueryAccountResponse, _ txBody: Cosmos_Tx_V1beta1_TxBody, _ authInfo: Cosmos_Tx_V1beta1_AuthInfo, _ pKey: PrivateKey, _ chainId: String) -> Cosmos_Tx_V1beta1_TxRaw {
        let signDoc = Cosmos_Tx_V1beta1_SignDoc.with {
            $0.bodyBytes = try! txBody.serializedData()
            $0.authInfoBytes = try! authInfo.serializedData()
            $0.chainID = chainId
//            $0.accountNumber = WUtils.onParseAuthGrpc(auth).1!
        }
        let sigbyte = getGrpcByteSingleSignature(pKey, try! signDoc.serializedData())
        return Cosmos_Tx_V1beta1_TxRaw.with {
            $0.bodyBytes = try! txBody.serializedData()
            $0.authInfoBytes = try! authInfo.serializedData()
            $0.signatures = [sigbyte]
        }
    }
    
    static func getGrpcTxBody(_ msgAnys: Array<Google_Protobuf2_Any>, _ memo: String) -> Cosmos_Tx_V1beta1_TxBody {
        return Cosmos_Tx_V1beta1_TxBody.with {
            $0.memo = memo
            $0.messages = msgAnys
        }
    }
    
    static func getGrpcAuthInfo(_ signerInfo: Cosmos_Tx_V1beta1_SignerInfo, _ fee: Fee) -> Cosmos_Tx_V1beta1_AuthInfo{
        let feeCoin = Cosmos_Base_V1beta1_Coin.with {
            $0.denom = fee.amount[0].denom
            $0.amount = fee.amount[0].amount
        }
        let txFee = Cosmos_Tx_V1beta1_Fee.with {
            $0.amount = [feeCoin]
            $0.gasLimit = UInt64(fee.gas)!
        }
        return Cosmos_Tx_V1beta1_AuthInfo.with {
            $0.fee = txFee
            $0.signerInfos = [signerInfo]
        }
    }
    
    static func getGrpcSignerInfo(_ auth: Cosmos_Auth_V1beta1_QueryAccountResponse, _ pKey: PrivateKey) -> Cosmos_Tx_V1beta1_SignerInfo {
        let single = Cosmos_Tx_V1beta1_ModeInfo.Single.with {
            $0.mode = Cosmos_Tx_Signing_V1beta1_SignMode.direct
        }
        let mode = Cosmos_Tx_V1beta1_ModeInfo.with {
            $0.single = single
        }
        let pub = Cosmos_Crypto_Secp256k1_PubKey.with {
//            $0.key = pKey.extendedPublicKey().raw
            $0.key = pKey.publicKey.uncompressedPublicKey
        }
        let pubKey = Google_Protobuf2_Any.with {
            $0.typeURL = "/cosmos.crypto.secp256k1.PubKey"
            $0.value = try! pub.serializedData()
        }
        return Cosmos_Tx_V1beta1_SignerInfo.with {
            $0.publicKey = pubKey
            $0.modeInfo = mode
//            $0.sequence = WUtils.onParseAuthGrpc(auth).2!
        }
    }
    
    static func getGrpcByteSingleSignature(_ pKey: PrivateKey, _ toSignByte: Data) -> Data {
        let hash = toSignByte.sha256()
        let signedData = try! ECDSA.compactsign(hash, privateKey: pKey.raw)
        return signedData
    }
}



public struct Coin: Codable {
    var denom: String = ""
    var amount: String = ""
    
    init(){}
    
    init(_ dictionary: [String: Any]) {
        self.denom = dictionary["denom"] as? String ?? ""
        self.amount = dictionary["amount"] as? String ?? ""
    }
    
    init(_ dictionary: NSDictionary?) {
        self.denom = dictionary?["denom"] as? String ?? ""
        self.amount = dictionary?["amount"] as? String ?? ""
    }
    
    init(_ denom:String, _ amount:String) {
        self.denom = denom
        self.amount = amount
    }
    
    func isIbc() -> Bool {
        if (denom.starts(with: "ibc/")) {
            return true
        }
        return false
    }
    
    func getIbcHash() -> String? {
        if (!isIbc()) {return nil}
        return denom.replacingOccurrences(of: "ibc/", with: "")
    }
}

public struct Fee: Codable{
    var gas: String = ""
    var amount: Array<Coin> = Array<Coin>()
    
    init() {}
    
    init(_ dictionary: [String: Any]) {
        self.gas = dictionary["gas"] as? String ?? ""
        self.amount.removeAll()
        if let rawAmounts = dictionary["amount"] as? Array<NSDictionary>  {
            for amount in rawAmounts {
                self.amount.append(Coin(amount as! [String : Any]))
            }
        }
    }
    
    init(_ gas:String, _ amount:Array<Coin>) {
        self.gas = gas
        self.amount = amount
    }
}
