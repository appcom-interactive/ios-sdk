//
//  SecurityEndpoints.swift
//  Figo
//
//  Created by Christian König on 02.12.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


public extension FigoClient {
    
    /**
     RETRIEVE SECURITIES OF ALL ACCOUNTS
     
     Using this endpoint only returns securities on accounts that the user has chosen to share with your application.
     
     - Parameter parameters: (optional) `RetrieveSecuritiesParameters`
     - Parameter completionHandler: Returns `SecurityListEnvelope` or error
     */
    public func retrieveSecurities(parameters: RetrieveSecuritiesParameters = RetrieveSecuritiesParameters(), _ completionHandler: (Result<SecurityListEnvelope>) -> Void) {
        request(.RetrieveSecurities(parameters)) { response in
            completionHandler(decodeUnboxableResponse(response))
        }
    }
    
    /**
     RETRIEVE SECURITIES OF ONE ACCOUNT
     
     Using this endpoint only returns securities on accounts that the user has chosen to share with your application.
     
     - Parameter accountID: The ID of the account for which to retrieve the securities
     - Parameter parameters: (optional) `RetrieveSecuritiesParameters`
     - Parameter completionHandler: Returns `SecurityListEnvelope` or error
     */
    public func retrieveSecuritiesForAccount(accountID: String, parameters: RetrieveSecuritiesParameters = RetrieveSecuritiesParameters(), _ completionHandler: (Result<SecurityListEnvelope>) -> Void) {
        request(.RetrieveSecuritiesForAccount(accountID, parameters: parameters)) { response in
            completionHandler(decodeUnboxableResponse(response))
        }
    }
    
    /**
     RETRIEVE A SECURITY

     - Parameter securityID: ID of the securitiy to retrieve
     - Parameter accountID: ID of the account the security belongs to
     - Parameter completionHandler: Returns security or error
     */
    public func retrieveSecurity(securityID: String, accountID: String, _ completionHandler: (Result<Security>) -> Void) {
        request(.RetrieveSecurity(securityID, accountID: accountID)) { response in
            completionHandler(decodeUnboxableResponse(response))
        }
    }
    
}
