//
//  RzpCheckoutPlugin.swift
//  App
//
//  Created by Vivek Rajesh Shindhe on 07/12/21.
//

import Foundation
import Capacitor
import Razorpay

@objc(RzpCheckoutPlugin)
public class RzpChekcoutPlugin: CAPPlugin{
   
    var call: CAPPluginCall?
    
    @objc func startPayment(_ call: CAPPluginCall){
        self.call = call
                let key = call.getString("key") ?? ""
                guard let options = call.options else { return }
                DispatchQueue.main.async {
                    let rzpObj = RazorpayCheckout.initWithKey(key, andDelegateWithData: self)
                    rzpObj.setExternalWalletSelectionDelegate(self)
                    rzpObj.open(options)
                }

    }
    
}

extension RzpChekcoutPlugin: RazorpayPaymentCompletionProtocolWithData, ExternalWalletSelectionProtocol{
    
    public func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
            var resObj = JSObject()
        resObj["code"] = code as JSValue
            resObj["description"] = str
            if(hasListeners("PAYMENT_FAILED")){
                notifyListeners("PAYMENT_FAILED", data: resObj)
            }
            if let call = call {
                        call.reject("\(code): \(str)")
                    }
        }
        
        public func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
            if(hasListeners("PAYMENT_SUCCESS")){
                var responseObj = [String: Any]()
                responseObj["value"] = payment_id
                notifyListeners("PAYMENT_SUCCESS", data: responseObj)
            }
//            if let call = call{
//                var responseObj = [String: Any]()
//                responseObj["response"] = response
//                call.resolve(["response":(response) as Any])
//            }
        }
        
        public func onExternalWalletSelected(_ walletName: String, withPaymentData paymentData: [AnyHashable : Any]?) {
            
            if let call = call {
                        call.reject(walletName)
                    }
        }

    
}


