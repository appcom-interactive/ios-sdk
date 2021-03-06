//
//  Resources.swift
//  Figo
//
//  Created by Christian König on 24.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


enum Resources: String {

    case Account
    case Balance
    case TanScheme
    case SyncStatus
    case User
    case PaymentParametersIntTextKeys
    case PaymentParametersStringTextKeys
    case TaskState
    case SupportedBanks
    case Transaction
    case Security
    case StandingOrder
    
    var JSONObject: [String: AnyObject] {
        let JSON: [String: AnyObject] = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as! [String: AnyObject]
        return JSON
    }
    
    var data: NSData {
        let bundle = NSBundle(forClass: BaseTestCaseWithLogin.classForCoder())
        let path = bundle.pathForResource(self.rawValue, ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        return data
    }
}

func nearlyEqual(a: Float, b: Float, epsilon: Float = 0.0001) -> Bool {
    return a - b < epsilon && b - a < epsilon
}

