//
//  NetworkManagerTest.swift
//  Happy Shop
//
//  Created by Andoni Dan on 21/04/16.
//  Copyright © 2016 Andoni Dan. All rights reserved.
//

import XCTest
import EVReflection
import Alamofire

@testable import Happy_Shop

private let kTestURL : String = "http://test.com"

class NetworkManagerTest: XCTestCase {
    
    var manager : NetworkManager<EVObject>!
    var internetChecker : ConnectionCheckerMock = ConnectionCheckerMock()
    var alertor : AlertorMinionMock = AlertorMinionMock()
    var networkResponseHandler : NetworkManagerMinionMock<EVObject> = NetworkManagerMinionMock()
    
    override func setUp() {
        super.setUp()
        
        manager = NetworkManager.GET(internetChecker, alertor: alertor, minion: networkResponseHandler)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testObjectAt()
    {
        runGenericResponseTest(self.manager.objectAt)
    }
    
    func testArrayAt()
    {
        runGenericResponseTest(self.manager.arrayAt)
    }
    
    func runGenericResponseTest<T>(managerClosure : (
        
        URLString : NSURL?
        , parameters : [String : AnyObject]?
        , inBackground : Bool
        , responseHandler : (result : Result<T, NSError>) -> Void
        
        ) -> Void)
    {
        runTestWithNoInternetOnClosure{(responseHandler) in
            managerClosure(URLString: nil, parameters: nil, inBackground: false, responseHandler: responseHandler)
        }
        
        var url : NSURL?
        
        runTestWithInternetOnClosure ({(responseHandler) in
            managerClosure(URLString: nil, parameters: nil, inBackground: false, responseHandler: responseHandler)
            }, url : url)
        
        url = NSURL(string: kTestURL)
        
        runTestWithInternetOnClosure ({(responseHandler) in
            managerClosure(URLString: url, parameters: nil, inBackground: false, responseHandler: responseHandler)
            }, url : url)
        
        runTestWithInternetOnClosure ({(responseHandler) in
            managerClosure(URLString: url, parameters: nil, inBackground: false, responseHandler: responseHandler)
            }, url : url)
    }
    
    func runTestWithInternetOnClosure<V>(closure : (responseHandler : (result : Result<V, NSError>) -> Void) -> Void, url : NSURL?)
    {
        setUpWithInternet()
        
        closure {[unowned self] (result) in
            XCTAssert(self.networkResponseHandler.responseWasCalled || url == .None, "No object response received")
        }
    }
    
    func runTestWithNoInternetOnClosure<V>(closure : (responseHandler : (result : Result<V, NSError>) -> Void) -> Void)
    {
        noInternetSetUp()
        
        closure {[unowned self] (result) in
            XCTAssert(result.isFailure && self.alertor.hasAlertedFlag, "Incorrect response while no internet")
        }
    }
    
    func noInternetSetUp()
    {
        internetChecker.internetValue = false
        alertor.hasAlertedFlag = false
    }
    
    func setUpWithInternet()
    {
        internetChecker.internetValue = true
        networkResponseHandler.responseWasCalled = false
    }
}
