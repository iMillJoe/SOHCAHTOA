//
//  SOHCAHTOATests.swift
//  SOHCAHTOATests
//
//  Created by Joe Million on 10/22/14.
//  Copyright (c) 2014 iMillIndustries. All rights reserved.
//

import UIKit
import XCTest

class SOHCAHTOATests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
       // XCTAssert(true, "Pass")
        
        
        let test3 = IMCalculator.evaluateExpression("12.3*15.2/2.3223*π")
        println(test3)
        
        let test4 = IMCalculator.evaluateExpression("12.3.4*15.2/2.3223*π")
        println(test4)
        
        let test5 = IMCalculator.evaluateExpression("5(SIN30)")
        println(test5)
        
        let test6 = IMCalculator.evaluateExpression("5(COS30)")
        println(test6)
        
        let test7 = IMCalculator.evaluateExpression("5(TAN30)")
        println(test7)
        
        let test8 = IMCalculator.evaluateExpression("5(TAN30)+0")
        println(test8)
        
        println("\n***TEST***")
        var test = ""
        test = "3.1*5/(3^π)SQRT"
        var result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        
        
        test = "3.1*5"
        println("\n***TEST **** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        
        test = "something stupid"
        println("\n***TEST **** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        
        test = "****** Like Nic is A Fag ******"
        println("\n***TEST **** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        
        test = "2*9/3^2"
        println("\n***TEST **** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        
        test = "5(C30)²"
        println("\n***TEST **** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        
        
        
        
        
    }
    
    //func testPerformanceExample() {
        // This is an example of a performance test case.
      //  self.measureBlock() {
            // Put the code you want to measure the time of here.
        //}
    //}
    
}
