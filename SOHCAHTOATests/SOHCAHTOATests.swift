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
        
        var test = ""
        test = "5+1"
        println("\n*** TEST *** \(test)")
        var result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        if (result.result != 6.0 || result.syntaxError != nil)
        {
            XCTFail("\(test) failed")
        }
        
 
        test = "3.1*5"
        println("\n*** TEST *** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        if (result.result != 15.5 || result.syntaxError != nil)
        {
            XCTFail("\(test) failed")
        }

        test = "something stupid"
        println("\n*** TEST *** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        if (result.result != nil || result.syntaxError != "syntaxError")
        {
            XCTFail("\(test) failed")
        }
        
        
        test = "****** Like Nic is A Fag ******"
        println("\n*** TEST *** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        if (result.result != nil || result.syntaxError != "syntaxError")
        {
            XCTFail("\(test) failed")
        }

        test = "2*9/3^2"
        println("\n*** TEST *** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        if (result.result != 2.0 || result.syntaxError != nil)
        {
            XCTFail("\(test) failed")
        }

        test = "5*(SIN30)²"
        println("\n*** TEST *** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        let sinDub = 5.0 * (sin(30.0 * M_PI / 180) * sin(30.0 * M_PI / 180))
        if (result.result != sinDub || result.syntaxError != nil)
        {
            XCTFail("\(test) failed")
        }
        
        test = "5+4(14²/4)"
        println("\n*** TEST *** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        if (result.result != 201.0 || result.syntaxError != nil)
            {
                XCTFail("\(test) failed")
        }
        
        test = "5+4*(14²/4)"
        println("\n*** TEST *** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        if (result.result != 201.0 || result.syntaxError != nil)
        {
            XCTFail("\(test) failed")
        }
        
        test = "π2"
        println("\n*** TEST *** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        if (result.result != M_PI * 2.0 || result.syntaxError != nil)
        {
            XCTFail("\(test) failed")
        }
        
        test = "π2"
        println("\n*** TEST *** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        if (result.result != M_PI * 2.0 || result.syntaxError != nil)
        {
            XCTFail("\(test) failed")
        }
        
        test = "("
        println("\n*** TEST *** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        if (result.result != nil || result.syntaxError != "mismatched parentheses")
        {
            XCTFail("\(test) failed")
        }
        
        test = ")"
        println("\n*** TEST *** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        if (result.result != nil || result.syntaxError != "mismatched parentheses")
        {
            XCTFail("\(test) failed")
        }
        
        test = "(3+5)2π"
        println("\n*** TEST *** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        if (result.result != (3 + 5) * M_PI * 2.0 || result.syntaxError != nil)
        {
            XCTFail("\(test) failed")
        }
        
        test = "5+4(14²/4)"
        println("\n*** TEST *** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        if (result.result != 201.0 || result.syntaxError != nil)
        {
            XCTFail("\(test) failed")
        }
        
        test = "5+4(14²/4)^2"
        println("\n*** TEST *** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        if (result.result != 9609.0 || result.syntaxError != nil)
        {
            XCTFail("\(test) failed")
        }
        
        test = "5+4(14²/4)2"
        println("\n*** TEST *** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        if (result.result != 397.0 || result.syntaxError != nil)
        {
            XCTFail("\(test) failed is \(result.result) should be 397.0")
        }
        
        
        test = "2(3+5)"
        println("\n*** TEST *** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        if (result.result != 16.0 || result.syntaxError != nil)
        {
            XCTFail("\(test) failed is \(result.result)" )
        }
        
        test = "(3+5)2"
        println("\n*** TEST *** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        if (result.result != 16.0 || result.syntaxError != nil)
        {
            XCTFail("\(test) failed is \(result.result)" )
        }
        
        test = "2*2*2"
        println("\n*** TEST *** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        if (result.result != 8.0 || result.syntaxError != nil)
        {
            XCTFail("\(test) failed is \(result.result)" )
        }
        
        test = "2(3*3)+15/3"
        println("\n*** TEST *** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        if (result.result != 23.0 || result.syntaxError != nil)
        {
            XCTFail("\(test) failed is \(result.result)" )
        }
        
        test = "3(4(5(6*7²)))"
        println("\n*** TEST *** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        if (result.result != 17640.0 || result.syntaxError != nil)
        {
            XCTFail("\(test) failed is \(result.result)" )
        }
        
        test = "3((4*5)(5-1))²"
        println("\n*** TEST *** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        if (result.result != 19200.0 || result.syntaxError != nil)
        {
            XCTFail("\(test) failed is \(result.result)" )
        }
        
        test = "2.3*4.53((π²9)"
        println("\n*** TEST *** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        if (result.result != nil || result.syntaxError != "mismatched parentheses")
        {
            XCTFail("\(test) failed is \(result.result)" )
        }
        
        test = "2pi"
        println("\n*** TEST *** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        if (result.result != M_PI * 2 || result.syntaxError != nil)
        {
            XCTFail("\(test) failed is \(result.result)" )
        }
        
        test = "π²+π3((13π/π12))"
        println("\n*** TEST *** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        var pDub: Double = (M_PI * M_PI) + (M_PI * 3) * ((13 * M_PI / M_PI * 12))
        if (result.result != pDub || result.syntaxError != nil)
        {
            XCTFail("\(test) failed is \(result.result) should be \(pDub)" )
        }
        
        test = "13π/π12"
        println("\n*** TEST *** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        pDub = ((13 * M_PI / M_PI * 12))
        if (result.result != pDub || result.syntaxError != nil)
        {
            XCTFail("\(test) failed is \(result.result) should be \(pDub)" )
        }
        
        test = "13*3/3*12"
        println("\n*** TEST *** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        pDub = ((13 * 3 / 3 * 12))
        if (result.result != pDub || result.syntaxError != nil)
        {
            XCTFail("\(test) failed is \(result.result) should be \(pDub)" )
        }
        
        test = "1+2-3+4"
        println("\n*** TEST *** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        if (result.result != 4.0 || result.syntaxError != nil)
        {
            XCTFail("\(test) failed is \(result.result)" )
        }
        
        test = "(5-3)/(3-3)"
        println("\n*** TEST *** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        if (result.result != nil || result.syntaxError != "division by zero")
        {
            XCTFail("\(test) failed is \(result.result)" )
        }
        
        test = "3-0.0"
        println("\n*** TEST *** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        if (result.result != 3.0 || result.syntaxError != nil)
        {
            XCTFail("\(test) failed is \(result.result)" )
        }
        
        test = "3-3"
        println("\n*** TEST *** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        if (result.result != 0.0 || result.syntaxError != nil)
        {
            XCTFail("\(test) failed is \(result.result)" )
        }
        
        test = "0.0"
        println("\n*** TEST *** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        if (result.result != 0.0 || result.syntaxError != nil)
        {
            XCTFail("\(test) failed is \(result.result)" )
        }
        
        test = "1+"
        println("\n*** TEST *** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        if (result.result != nil || result.syntaxError != "syntaxError")
        {
            XCTFail("\(test) failed is \(result.result)" )
        }
        
        test = "1-"
        println("\n*** TEST *** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        if (result.result != nil || result.syntaxError != "syntaxError")
        {
            XCTFail("\(test) failed is \(result.result)" )
        }
        
        test = "⁻4*5"
        println("\n*** TEST *** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        if (result.result != -20.0 || result.syntaxError != nil)
        {
            XCTFail("\(test) failed is \(result.result)" )
        }
        
        test = "5*⁻15(13pi²/⁻14)/4+5-1/2"
        println("\n*** TEST *** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        pDub = 5 * -15 * ( 13 * (M_PI * M_PI ) / -14 ) / 4 + 5 - 1 / 2
        if (result.result != pDub || result.syntaxError != nil)
        {
            XCTFail("\(test) failed is \(result.result), should be \(pDub)" )
        }
        
        test = "(5*⁻15(13pi²/⁻14)/4+5-1/2)*76/14(3^8)"
        println("\n*** TEST *** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        pDub = pDub * (76 / 14 * ( pow(3,8)  ))
        if (result.result != pDub || result.syntaxError != nil)
        {
            XCTFail("\(test) failed is \(result.result), should be \(pDub)" )
        }
        
        //unary minus testing (with binary minus operator)
        test = "5*-3"
        println("\n*** TEST *** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        if (result.result != -15.0 || result.syntaxError != nil)
        {
            XCTFail("\(test) failed is \(result.result), should be -15.0)" )
        }
        
        test = "-5*3"
        println("\n*** TEST *** \(test)")
        result = IMCalculator.evaluateExpression(test)
        println("***TEST RESULTS:\(result)  ****\n")
        if (result.result != -15.0 || result.syntaxError != nil)
        {
            XCTFail("\(test) failed is \(result.result), should be -15.0)" )
        }
    }
    
    //func testPerformanceExample() {
        // This is an example of a performance test case.
      //  self.measureBlock() {
            // Put the code you want to measure the time of here.
        //}
    //}
    
}
