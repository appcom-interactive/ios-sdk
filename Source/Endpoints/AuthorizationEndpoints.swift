//
//  Authorization.swift
//  Figo
//
//  Created by Christian König on 27.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


public extension FigoClient {
    
    /**
     CREDENTIAL LOGIN
     
     Requests authorization with credentials. Authorization can be obtained as long
     as the user has not revoked the access granted to your application.
     
     The returned refresh token can be stored by the client for future logins, but only
     in a securely encryped store like the keychain or a SQLCipher database.
     
     - Parameter username: The figo account email address
     - Parameter password: The figo account password
     - Parameter clientID: Client ID
     - Parameter clientSecret: Client secret
     - Parameter completionHandler: Returns refresh token or error
     */
    public func loginWithUsername(username: String, password: String, clientID: String, clientSecret: String, _ completionHandler: (Result<String>) -> Void) {
        self.basicAuthCredentials = base64EncodeBasicAuthCredentials(clientID, clientSecret)
        request(.LoginUser(username: username, password: password)) { response in
            
            let unboxingResult: Result<Authorization> = decodeUnboxableResponse(response)
            switch unboxingResult {
            case .Success(let authorization):
                self.accessToken = authorization.accessToken
                self.refreshToken = authorization.refreshToken
                completionHandler(Result.Success(authorization.refreshToken!))
                break
            case .Failure(let error):
                completionHandler(.Failure(error))
                break
            }
        }
    }
    
    /**
     EXCHANGE REFRESH TOKEN
     
     Requests new access token with refresh token. New access tokens can be obtained as long
     as the user has not revoked the access granted to your application.
     
     - Parameter refreshToken: The refresh token returned from a previous CREDENTIAL LOGIN
     - Parameter clientID: Client ID
     - Parameter clientSecret: Client secret
     - parameter completionHandler: Returns nothing or error
     */
    public func loginWithRefreshToken(refreshToken: String, clientID: String, clientSecret: String, _ completionHandler: VoidCompletionHandler) {
        self.basicAuthCredentials = base64EncodeBasicAuthCredentials(clientID, clientSecret)
        request(Endpoint.RefreshToken(refreshToken)) { response in

            let unboxingResult: Result<Authorization> = decodeUnboxableResponse(response)
            switch unboxingResult {
            case .Success(let authorization):
                self.accessToken = authorization.accessToken
                self.refreshToken = authorization.refreshToken
                completionHandler(.Success())
                break
            case .Failure(let error):
                completionHandler(.Failure(error))
                break
            }
        }
    }
    
    /**
     REVOKE TOKEN
     
     Invalidates the session's access token for simulating an expired access token.
     
     After revoking the access token, with the next API call a new one is fetched automatically if the refresh token is still valid.
     
     - Parameter completionHandler: Returns nothing or error
     */
    public func revokeAccessToken(completionHandler: VoidCompletionHandler) {
        guard let accessToken = self.accessToken else {
            completionHandler(.Failure(Error.NoActiveSession))
            return
        }
        request(.RevokeToken(accessToken)) { response in
            self.accessToken = nil
            completionHandler(decodeVoidResponse(response))
        }
    }
    
    /**
     REVOKE TOKEN
     
     Invalidates access token and refresh token, after that CREDENTIAL LOGIN is required.
     
     You might call this **LOGOUT**.
     
     - Parameter refreshToken: The client's refresh token, defaults to the session's refresh token
     - Parameter completionHandler: Returns nothing or error
     */
    public func revokeRefreshToken(refreshToken: String, _ completionHandler: VoidCompletionHandler) {
        request(.RevokeToken(refreshToken)) { response in
            self.accessToken = nil
            self.refreshToken = nil
            completionHandler(decodeVoidResponse(response))
        }
    }
    
}

