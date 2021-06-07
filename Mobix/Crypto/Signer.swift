// 

import Foundation

//struct Signer {
//
//    static func genSignedSendTxgRPC(_ auth: Cosmos_Auth_V1beta1_QueryAccountResponse,
//                                    _ toAddress: String, _ amount: Array<Coin>, _ fee: Fee, _ memo: String,
//                                    _ pKey: HDPrivateKey, _ chainId: String)  -> Cosmos_Tx_V1beta1_BroadcastTxRequest{
//        let sendCoin = Cosmos_Base_V1beta1_Coin.with {
//            $0.denom = amount[0].denom
//            $0.amount = amount[0].amount
//        }
//        let sendMsg = Cosmos_Bank_V1beta1_MsgSend.with {
//            $0.fromAddress = WUtils.onParseAuthGrpc(auth).0!
//            $0.toAddress = toAddress
//            $0.amount = [sendCoin]
//        }
//        let anyMsg = Google_Protobuf2_Any.with {
//            $0.typeURL = "/cosmos.bank.v1beta1.MsgSend"
//            $0.value = try! sendMsg.serializedData()
//        }
//        let txBody = getGrpcTxBody([anyMsg], memo);
//        let signerInfo = getGrpcSignerInfo(auth, pKey);
//        let authInfo = getGrpcAuthInfo(signerInfo, fee);
//        let rawTx = getGrpcRawTx(auth, txBody, authInfo, pKey, chainId);
//        return Cosmos_Tx_V1beta1_BroadcastTxRequest.with {
//            $0.mode = Cosmos_Tx_V1beta1_BroadcastMode.async
//            $0.txBytes = try! rawTx.serializedData()
//        }
//    }
//}
