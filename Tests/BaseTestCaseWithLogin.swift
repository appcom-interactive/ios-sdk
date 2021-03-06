//
//  BaseTestCaseWithLogin.swift
//  Figo
//
//  Created by Christian König on 24.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation
import XCTest
import Figo


let logger = XCGLogger.defaultInstance()
let figo = FigoClient(logger: logger)


class BaseTestCaseWithLogin: XCTestCase {
    
    let username = "christian@koenig.systems"
    let password = "eVPVdiL7"
    let clientID = "C3XGp3LGISZFwJSsDfxwhHvXT1MjCoF92lOJ3VZrKeBI"
    let clientSecret = "SJtBMNCn6KrIkjQSCkV-xU3_ob0sUTHAFLy-K1V86SpY"

    var refreshToken: String?
    
    override class func setUp() {
        super.setUp()
        
        logger.setup(.Verbose, showFunctionName: false, showDate: false, showThreadName: false, showLogLevel: false, showFileNames: false, showLineNumbers: false, writeToFile: nil, fileLogLevel: .None)
    }
    
    func login(completionHandler: () -> Void) {
        guard refreshToken == nil else {
            debugPrint("Active session, skipping Login")
            completionHandler()
            return
        }
        debugPrint("Begin Login")
        figo.loginWithUsername(username, password: password, clientID: clientID, clientSecret: clientSecret) { refreshToken in
            self.refreshToken = refreshToken.value
            XCTAssertNotNil(refreshToken.value)
            XCTAssertNil(refreshToken.error)
            debugPrint("End Login")
            completionHandler()
        }
    }
    
    func logout(completionHandler: () -> Void) {
        guard refreshToken != nil else {
            debugPrint("No active session, skipping Logout")
            completionHandler()
            return
        }
        debugPrint("Begin Logout")
        figo.revokeRefreshToken(self.refreshToken!) { result in
            XCTAssertNil(result.error)
            debugPrint("End Logout")
            completionHandler()
        }
    }
}