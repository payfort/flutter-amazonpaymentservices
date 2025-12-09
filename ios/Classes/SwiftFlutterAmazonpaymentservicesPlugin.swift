import AVFoundation
import Flutter
import Foundation
import PayFortSDK
import UIKit
import PassKit

public class SwiftFlutterAmazonpaymentservicesPlugin: NSObject, FlutterPlugin {
  var payFortController = PayFortController.init(enviroment: .sandBox)
  //    PayFortEnviroment
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "flutter_amazonpaymentservices", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterAmazonpaymentservicesPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "normalPay" {
      if let param = call.arguments as? [String: Any],
        let requestParam = param["requestParam"] as? [String: String]
      {

        if let enviroment = param["environmentType"], enviroment as! String == "production" {
          payFortController = PayFortController.init(enviroment: .production)
        }
        payFortController.isShowResponsePage = param["isShowResponsePage"] as? Bool ?? false
        payFortController.presentAsDefault = true
        payFortController.callPayFort(
          withRequest: requestParam,
          currentViewController: ViewHelper.visibleViewController()
        ) {
          (requestDic, responeDic) in

          result(responeDic)
        } canceled: { (requestDic, responeDic) in

          result(
            FlutterError(
              code: "onCancel",
              message: "Canceled",
              details: responeDic))
        } faild: { (requestDic, responeDic, message) in

          result(
            FlutterError(
              code: "onFailure",
              message: message,
              details: responeDic))
        }
      }
    } else if call.method == "getUDID" {
      result(payFortController.getUDID())
    } else if call.method == "validateApi" {
      if let param = call.arguments as? [String: Any],
        let requestParam = param["requestParam"] as? [String: String]
      {
        if let enviroment = param["environmentType"], enviroment as! String == "production" {
          payFortController = PayFortController.init(enviroment: .production)
        }
        payFortController.callValidateAPI(with: requestParam) {

        } success: { (requestDic) in
          result(requestDic)

        } faild: { (requestDic, responeDic, message) in
          result(
            FlutterError(
              code: "Faild",
              message: "messaage",
              details: responeDic))

        }

      }
    } else if call.method == "applePay" {
      handleApplePay(call: call, result: result)
    }
  }

  var flutterResult: FlutterResult?

  private var storedRequestDetails: [String: String]?

  private func handleApplePay(call: FlutterMethodCall, result: @escaping FlutterResult) {
      self.flutterResult = result 

      guard let args = call.arguments as? [String: Any],
          let requestParam = args["requestParam"] as? [String: Any] else {
          result(FlutterError(code: "INVALID_PARAMETERS", message: "Missing Apple Pay parameters", details: call.arguments))
          return
      }

      if let enviroment = args["environmentType"], enviroment as! String == "production" {
        payFortController = PayFortController.init(enviroment: .production)
      }

      print("Received Apple Pay requestParam: \(requestParam)") // Debugging output

      guard let amount = requestParam["displayAmount"] as? String,
          let countryCode = requestParam["countryCode"] as? String,
          let currencyCode = requestParam["currencyCode"] as? String,
          let supportedNetworks = requestParam["supportedNetworks"] as? [String],
          let merchantId = requestParam["merchantIdentifier"] as? String else {
          result(FlutterError(code: "INVALID_PARAMETERS", message: "Missing required Apple Pay parameters", details: requestParam))
          return
      }

      if let transactionDetails = requestParam["transactionDetails"] as? [String: String] {
          if let digitalWallet = transactionDetails["digital_wallet"], digitalWallet == "APPLE_PAY" {
              self.storedRequestDetails = transactionDetails
          } else {
              result(FlutterError(code: "MISSING_TRANSACTION_DETAILS", message: "Missing/Invalid parameter digital_wallet: APPLE_PAY expected", details: nil))
              return
          }
      } else {
          result(FlutterError(code: "MISSING_TRANSACTION_DETAILS", message: "Transaction details missing", details: nil))
          return
      }

      let paymentRequest = PKPaymentRequest()
      paymentRequest.merchantIdentifier = merchantId
      // paymentRequest.supportedNetworks = [.visa, .masterCard, .amex]
      paymentRequest.merchantCapabilities = .threeDSecure
      paymentRequest.countryCode = countryCode
      paymentRequest.currencyCode = currencyCode
      paymentRequest.supportedNetworks = supportedNetworks.compactMap { network in
          switch network.lowercased() {
              case "visa": return .visa
              case "mastercard": return .masterCard
              case "amex": return .amex
              case "mada": return .mada
              default: return nil
          }
      }

      paymentRequest.paymentSummaryItems = [
          PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(string: amount))
      ]

      guard let viewController = UIApplication.shared.windows.first?.rootViewController else {
          result(FlutterError(code: "NO_VIEW_CONTROLLER", message: "No view controller available", details: nil))
          return
      }

      if let paymentController = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest) {
          self.flutterResult = result  
          paymentController.delegate = self
          viewController.present(paymentController, animated: true, completion: nil)
      } else {
          result(FlutterError(code: "APPLE_PAY_UNAVAILABLE", message: "Unable to present Apple Pay", details: nil))
      }

  }
}



extension SwiftFlutterAmazonpaymentservicesPlugin: PKPaymentAuthorizationViewControllerDelegate {
    
    public func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
        flutterResult?(FlutterError(code: "APPLE_PAY_CANCELLED", message: "User cancelled Apple Pay", details: "Payment Cancelled"))
    }

    public func paymentAuthorizationViewController(
        _ controller: PKPaymentAuthorizationViewController,
        didAuthorizePayment payment: PKPayment,
        completion: @escaping (PKPaymentAuthorizationStatus) -> Void
    ) {
        let paymentToken = String(data: payment.token.paymentData, encoding: .utf8) ?? "Invalid Token"

        guard let transactionDetails = self.storedRequestDetails else {
            completion(.failure) // Ensure transaction details are present
            flutterResult?(FlutterError(code: "MISSING_TRANSACTION_DETAILS", message: "Transaction details are missing", details: nil))
            return
        }

        print("Apple Pay Token: \(paymentToken)")

        if (payment.token.paymentData.count != 0) {
            
          // Call PayFort SDK to process the Apple Pay payment
            payFortController.callPayFortForApplePay(
              withRequest: transactionDetails,
              applePayPayment: payment,
              currentViewController: ViewHelper.visibleViewController()
          ) { (requestDic, responseDic) in
              print("----Success-----")
              print("Request: \(requestDic)")
              print("Response: \(responseDic)")

              // Only call completion(.success) once here
              completion(.success)

              // Send response back to Flutter
              self.flutterResult?(responseDic)

          } faild: { (requestDic, responseDic, message) in
              print("----Failed-----")
              print("Request: \(requestDic)")
              print("Response: \(responseDic)")
              print("Message: \(message)")
              // Call failure in Apple Pay authorization
              completion(.failure)
              // Send error response to Flutter
              self.flutterResult?(FlutterError(code: "PAYMENT_FAILED", message: message, details: responseDic))

          }
        } else {
            completion(.failure)
        }
    }
}
