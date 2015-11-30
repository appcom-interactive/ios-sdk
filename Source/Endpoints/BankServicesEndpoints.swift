//
//  BankServices.swift
//  Figo
//
//  Created by Christian König on 30.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


struct BanksListEnvelope: Unboxable {
    let banks: [SupportedBank]
//    let services: [SupportedService]
    
    
    init(unboxer: Unboxer) {
        banks = unboxer.unbox("banks")
//        services = unboxer.unbox("services")
    }
}

private struct ServicesListEnvelope: Unboxable {
    let services: [SupportedService]
    
    init(unboxer: Unboxer) {
        services = unboxer.unbox("services")
    }
}


extension FigoSession {
    
    /**
     RETRIEVE LOGIN SETTINGS FOR A BANK OR SERVICE
     
     This only returns the bank accounts the user has chosen to share with your application
     
     - Parameter countryCode: The country the service comes from (Valid values: de)
     - Parameter bankCode: Bank code
     - Parameter completionHandler: Returns login settings or error
     */
    public func retrieveLoginSettings(countryCode: String = "de", bankCode: String, _ completionHandler: (FigoResult<LoginSettings>) -> Void) {
        request(Endpoint.RetrieveLoginSettings(countryCode: countryCode, bankCode: bankCode)) { response in
            let decoded: FigoResult<LoginSettings> = responseUnboxed(response)
            completionHandler(decoded)
        }
    }
    
    /**
     RETRIEVE LIST OF SUPPORTED BANKS, CREDIT CARDS, OTHER PAYMENT SERVICES
     
     - Parameter countryCode: The country the service comes from (Valid values: de)
     */
    public func retrieveSupportedBanks(countryCode: String = "de", _ completionHandler: (FigoResult<[SupportedBank]>) -> Void) {
        request(Endpoint.RetrieveSupportedBanks(countryCode: countryCode)) { response in
            let envelopeUnboxingResult: FigoResult<BanksListEnvelope> = responseUnboxed(response)
            
            switch envelopeUnboxingResult {
            case .Success(let envelope):
//                completionHandler(.Success([]))
                completionHandler(.Success(envelope.banks))
                break
            case .Failure(let error):
                completionHandler(.Failure(error))
                break
            }
        }
    }
    
    /**
     RETRIEVE LIST OF SUPPORTED CREDIT CARDS AND OTHER PAYMENT SERVICES
     
     These services do not use bank codes and are therefore listed seperatly. In order to provide a uniform interface for the remaining process, part of the response is a fake bank code, used as a surrogate for these services in our other calls.
     
     - Parameter countryCode: The country the service comes from (Valid values: de)
     */
    public func retrieveSupportedServices(countryCode: String = "de", _ completionHandler: (FigoResult<[SupportedService]>) -> Void) {
        request(Endpoint.RetrieveSupportedServices(countryCode: countryCode)) { response in
            let envelopeUnboxingResult: FigoResult<ServicesListEnvelope> = responseUnboxed(response)
            
            switch envelopeUnboxingResult {
            case .Success(let envelope):
                completionHandler(.Success(envelope.services))
                break
            case .Failure(let error):
                completionHandler(.Failure(error))
                break
            }
        }
    }
    
    
}