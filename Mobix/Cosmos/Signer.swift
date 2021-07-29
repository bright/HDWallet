// 

import Foundation
import HDWalletKit

class Signer {
    static func genSignedSendTxBytes(_ auth: CosmosAuthV1Beta1QueryAccountResponse,
                                     _ transactionInfo: TransactionInfo,
                                     _ pKey: PrivateKey,
                                     _ chainId: String,
                                     _ memo: String = "") -> Data{

        let sendCoin = Cosmos_Base_V1beta1_Coin.with {
            $0.denom = transactionInfo.coin!.denom
            $0.amount = transactionInfo.coin!.amount.description
        }
        let sendMsg = Cosmos_Bank_V1beta1_MsgSend.with {
            $0.fromAddress = auth.result.value.address
            $0.toAddress = transactionInfo.toAddress
            $0.amount = [sendCoin]
        }
        
        let anyMsg = Google_Protobuf2_Any.with {
            $0.typeURL = "/cosmos.bank.v1beta1.MsgSend"
            $0.value = try! sendMsg.serializedData()
        }
        //Memo, a note or comment to send with the transaction.
        let txBody = getTxBody([anyMsg], memo);

        // ------------------------authInfo - signer iffo-------------------
        
        
        let signerInfo = getSignerInfo(auth, pKey.publicKey.compressedPublicKey);

        //----------------------auth info --------------------

        
        let authInfo = getAuthInfo(signerInfo, transactionInfo.fee!);

        
        let rawTx = getRawTx(txBody, authInfo, pKey, chainId);
        return try! rawTx.serializedData()
        
    }
    
    
    static func getRawTx(_ txBody: Cosmos_Tx_V1beta1_TxBody, _ authInfo: Cosmos_Tx_V1beta1_AuthInfo, _ pKey: PrivateKey, _ chainId: String) -> Cosmos_Tx_V1beta1_TxRaw {
        let signDoc = Cosmos_Tx_V1beta1_SignDoc.with {
            $0.bodyBytes = try! txBody.serializedData()
            $0.authInfoBytes = try! authInfo.serializedData()
            $0.chainID = chainId
            $0.accountNumber = 2901
        }
        let sigbyte = getByteSingleSignature(pKey, try! signDoc.serializedData())
        return Cosmos_Tx_V1beta1_TxRaw.with {
            $0.bodyBytes = try! txBody.serializedData()
            $0.authInfoBytes = try! authInfo.serializedData()
            $0.signatures = [sigbyte]
        }
    }
    
    static func getTxBody(_ msgAnys: Array<Google_Protobuf2_Any>, _ memo: String) -> Cosmos_Tx_V1beta1_TxBody {
        return Cosmos_Tx_V1beta1_TxBody.with {
            $0.memo = memo
            $0.messages = msgAnys
        }
    }
    
    static func getAuthInfo(_ signerInfo: Cosmos_Tx_V1beta1_SignerInfo, _ fee: Fee) -> Cosmos_Tx_V1beta1_AuthInfo{
        let feeCoin = Cosmos_Base_V1beta1_Coin.with {
            $0.denom = fee.amount[0].denom
            $0.amount = fee.amount[0].amount.description
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
    
    static func getSignerInfo(_ auth: CosmosAuthV1Beta1QueryAccountResponse, _ publicKey: Data) -> Cosmos_Tx_V1beta1_SignerInfo {
        let single = Cosmos_Tx_V1beta1_ModeInfo.Single.with {
            $0.mode = Cosmos_Tx_Signing_V1beta1_SignMode.direct
        }
        let mode = Cosmos_Tx_V1beta1_ModeInfo.with {
            $0.single = single
        }
        let pub = Cosmos_Crypto_Secp256k1_PubKey.with {
            $0.key = publicKey
        }
        let pubKey = Google_Protobuf2_Any.with {
            $0.typeURL = "/cosmos.crypto.secp256k1.PubKey"
            $0.value = try! pub.serializedData()
        }
        let sequence =  UInt64(auth.result.value.sequence ?? "0")!
        return Cosmos_Tx_V1beta1_SignerInfo.with {
            $0.publicKey = pubKey
            $0.modeInfo = mode
            $0.sequence = sequence
        }
    }
    
    static func getByteSingleSignature(_ pKey: PrivateKey, _ toSignByte: Data) -> Data {
        let hash = toSignByte.sha256()
        let signedData = try! ECDSA.compactsign(hash, privateKey: pKey.raw)
        return signedData
    }
}
