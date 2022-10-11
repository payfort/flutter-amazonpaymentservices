//
//  ViewHelper.swift
//
//
//

import UIKit
import Flutter


 public class ViewHelper {

static func visibleViewController()-> UIViewController{

    if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                if presentedViewController is UIAlertController {
                    presentedViewController.dismiss(animated: false, completion: nil)
                    break
                }
                topController = presentedViewController
            }
                    return topController

        }
        return UIViewController()
}
}

