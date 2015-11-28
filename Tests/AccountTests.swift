//
//  Figo_iOS_Tests.swift
//  Figo iOS Tests
//
//  Created by Christian König on 20.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import XCTest
import Figo


class AccountTests: BaseTestCaseWithLogin {
    
    let demoBankCode = "90090042"
    let demoCredentials = ["demo", "demo"]
    
    func testShowsSimplestRetrieveAccountsCallWithoutErrorHandling() {
        
        let expectation = self.expectationWithDescription("Wait for all asyc calls to return")
        login() {
            self.figo.retrieveAccounts() { accounts, _ in
                if let accounts = accounts {
                    XCTAssertGreaterThan(accounts.count, 0)
                }
                expectation.fulfill()
            }
        }

        self.waitForExpectationsWithTimeout(30, handler: nil)

    }
    
    func testThatRetrieveAccountsYieldsObjects() {
        let expectation = self.expectationWithDescription("Wait for all asyc calls to return")
        login() {
            self.figo.retrieveAccounts() { accounts, error in
                if let accounts = accounts {
                    XCTAssertGreaterThan(accounts.count, 0)
                }
                XCTAssertNil(error)
                expectation.fulfill()
            }
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    func testThatRetrieveAccountYieldsObject() {
        let expectation = self.expectationWithDescription("Wait for all asyc calls to return")
        login() {
            self.figo.retrieveAccount("A1079434.5") { account, error in
                XCTAssertNil(error)
                if let account = account {
                    XCTAssertEqual(account.account_number, "1146174")
                    XCTAssertNil(error)
                    expectation.fulfill()
                }
            }
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    func testRemovePin() {
        let expectation = self.expectationWithDescription("Wait for all asyc calls to return")
        login() {
            self.figo.removeStoredPinFromBankContact("B1079434.3") { error in
                XCTAssertNil(error)
                expectation.fulfill()
            }
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    
    func testSetupNewAccount() {

        let expectation = self.expectationWithDescription("Wait for all asyc calls to return")
        login() {
            let account = NewAccount(bank_code: self.demoBankCode, iban: nil, credentials: self.demoCredentials, save_pin: true, disable_first_sync: nil, sync_tasks: nil)
            self.figo.setupNewBankAccount(account) { result in
                XCTAssertNil(result.error)
                expectation.fulfill()
            }
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)

    }
    

}