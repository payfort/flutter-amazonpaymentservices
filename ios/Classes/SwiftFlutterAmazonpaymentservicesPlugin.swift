import Flutter
import UIKit
import PayFortSDK
import AVFoundation
import Foundation

public class SwiftFlutterAmazonpaymentservicesPlugin:NSObject, FlutterPlugin {
    var payFortController = PayFortController.init(enviroment: .sandBox)
//    PayFortEnviroment
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_amazonpaymentservices", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterAmazonpaymentservicesPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "normalPay" {
          if let param = call.arguments as? [String: Any],
                             let requestParam = param["requestParam"] as? [String:String] {
              
              if let enviroment = param["environmentType"], enviroment as! String == "production" {
                  payFortController = PayFortController.init(enviroment: .production)
              }
              payFortController.isShowResponsePage = param["isShowResponsePage"] as? Bool ?? false
              payFortController.presentAsDefault = true
                          payFortController.callPayFort(withRequest: requestParam,
                                                           currentViewController: ViewHelper.visibleViewController()) {
                            (requestDic, responeDic) in
                          
                            result(responeDic)
                        } canceled: { (requestDic, responeDic) in
                          
                            result(FlutterError(code: "onCancel",
                                                   message: "Canceled",
                                                   details: responeDic))
                        } faild: { (requestDic, responeDic, message) in
                    

                            result(FlutterError(code: "onFailure",
                                                   message: message,
                                                   details: responeDic))
                        }
                          }
    }else if call.method == "getUDID" {
    result(payFortController.getUDID())
    }else  if call.method == "validateApi" {
     if let param = call.arguments as? [String: Any],
                                 let requestParam = param["requestParam"] as? [String:String]
                                 {
         if let enviroment = param["environmentType"], enviroment as! String == "production" {
             payFortController = PayFortController.init(enviroment: .production)
         }
                       payFortController.callValidateAPI(with: requestParam) {


                               } success: { (requestDic) in
                                   result(requestDic)

                               } faild: { (requestDic, responeDic, message) in
                                   result(FlutterError(code: "Faild",
                                                   message: "messaage",
                                                   details: responeDic))

                               }

                   }
                   }
  }
}


