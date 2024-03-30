//
//  Person.swift
//  Daleel
//
//  Created by mac on 2024/3/21.
//

import Foundation
import metamask_ios_sdk

@objc(JJPerson)

@objcMembers class Person: NSObject {
    var result: String = ""
    var errorMessage: String = ""
    
    var balance : String = ""
    var balanceError : String = ""
    typealias ConnectBlock = (_ isSuccess:Bool, _ account:String) -> ()
    
    var metadata = AppMetadata(name: "MetaMask", url: "https://metamask.io/")
    func connectAndSign(callBlock : @escaping ConnectBlock) async  {
        let connectSignResult = await MetaMaskSDK.shared(metadata).connect()
        let metaDataSDK = MetaMaskSDK.shared(metadata)
        switch connectSignResult {
        case let .success(value):
            result = value
            print("metamask.value = " + value)
            print("metadata.account = " + metaDataSDK.account)
//            let chainIdRequest = EthereumRequest(method: .ethChainId)
//            let chainId = await metaDataSDK.request(chainIdRequest)
//            let account = metaDataSDK.account
            callBlock(true,metaDataSDK.account)
//            let parameters: [String] = [
//                // account to check for balance
//                account,
//                // "latest", "earliest" or "pending" (optional)
//                "latest"
//            ]
//
//            let getBalanceRequest = EthereumRequest(
//                method: .ethGetBalance,
//                params: parameters
//            )

//            // Make request
//            let accountBalance = await metaDataSDK.request(getBalanceRequest)
//            switch accountBalance {
//            case let .success(value):
//                balance = value
//                print("metamask.balance = " + balance)
//                
//            case let .failure(error):
//                balanceError = error.localizedDescription
//                print("metamask.balanceerror = " + balanceError)
//            }
            
        case let .failure(error):
            errorMessage = error.localizedDescription
            print("metamask.error = " + errorMessage)
            callBlock(false,"")

        }
    }
}
