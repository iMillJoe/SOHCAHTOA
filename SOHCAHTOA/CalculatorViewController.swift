//
//  CalculatorViewController.swift
//  SOHCAHTOA
//
//  Created by Joe Million on 10/22/14.
//  Copyright (c) 2014 iMillIndustries. All rights reserved.
//

import UIKit


class CalculatorViewController: UIViewController {
    

    @IBOutlet weak var currentExpression: UILabel!
    @IBOutlet weak var answerTextView: UITextView!
    
    
    
    var lastAnswer: NSString?
    var userIsInTheMiddelOfEnteringAnExpression: Bool = false
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
    @IBAction func digitPressed(sender: UIButton) {
        
        let digit = sender.currentTitle
        if (userIsInTheMiddelOfEnteringAnExpression == true) {
            currentExpression.text = currentExpression.text?.stringByAppendingString(digit!)
        }
        else if (currentExpression.text == "0") {
            currentExpression.text = digit!
            userIsInTheMiddelOfEnteringAnExpression = true
        }
    }
    
    
    @IBAction func operatorPressed(sender: UIButton) {
        
        if (lastAnswer != nil && userIsInTheMiddelOfEnteringAnExpression == false ) {
                currentExpression.text = lastAnswer! + sender.currentTitle!
                userIsInTheMiddelOfEnteringAnExpression = true
            }
        else if (currentExpression.text != "0" ) {
            currentExpression.text = currentExpression.text! + sender.currentTitle!
            
        } else {
            currentExpression.text = sender.currentTitle?
            userIsInTheMiddelOfEnteringAnExpression = true
        }
    }
    
    
    
    @IBAction func squarePressed(sender: UIButton) {
        
        if (self.userIsInTheMiddelOfEnteringAnExpression == false && currentExpression.text? == "0") {
            
            if (lastAnswer?.doubleValue != nil) {
                currentExpression.text = lastAnswer
                userIsInTheMiddelOfEnteringAnExpression = true
            }
        }
        currentExpression.text = currentExpression.text?.stringByAppendingString("²")
    }
    
    
    
    @IBAction func enterPressed(sender: UIButton) {
        
        userIsInTheMiddelOfEnteringAnExpression = false
        
        if (currentExpression.text != nil) {
            var ans = IMCalculator.evaluateExpression(currentExpression.text!)
            if (ans.result != nil) {
                lastAnswer = ans.result!.stringValue
                answerTextView.text = answerTextView.text + "\r \(currentExpression.text!) = \(ans.result!.stringValue)"
            }
            else if (ans.syntaxError != nil) {
                lastAnswer = nil
                answerTextView.text = answerTextView.text + "\r \(currentExpression.text!) = \(ans.syntaxError!)"
            }
            answerTextView.scrollRangeToVisible( NSMakeRange(countElements(answerTextView.text), 0))
            
            
        }
        
        currentExpression.text = "0";
        
    }
    
    
    @IBAction func backSpacePressed(sender: UIButton) {
        
        if (currentExpression.text?.isEmpty != true) {
            if (self.currentExpression.text != "0") {
                currentExpression.text = currentExpression.text!.substringToIndex( currentExpression.text!.endIndex.predecessor() )
            }
        }
        
        if (currentExpression.text!.isEmpty) {
            currentExpression.text = "0"
            userIsInTheMiddelOfEnteringAnExpression = false
        }
    }
    
    
    @IBAction func clearPressed(sender: UIButton) {
        
        if (currentExpression.text == "0")
        {
            answerTextView.text = ""
            lastAnswer = nil
        }
        currentExpression.text = "0"
        userIsInTheMiddelOfEnteringAnExpression = false
    }
    
 
    @IBAction func negitivePressed(sender: UIButton) {
        
        if (currentExpression.text!.hasSuffix("*") || currentExpression.text!.hasSuffix("/") ||
            currentExpression.text!.hasSuffix("+") || currentExpression.text!.hasSuffix("-") ||
            currentExpression.text!.hasSuffix(")") || currentExpression.text!.hasSuffix("√") ||
            currentExpression.text!.hasSuffix("n") || currentExpression.text!.hasSuffix("s") ){
                currentExpression.text! + currentExpression.text! + "⁻"
        }
        else if (currentExpression.text! == "0")
        {
            currentExpression.text = "⁻"
            userIsInTheMiddelOfEnteringAnExpression = true
        }
    }
    
    
    @IBAction func lastAnswerPressed(sender: UIButton) {
        
        if (lastAnswer != nil) {
            if (currentExpression.text == "0") {
                currentExpression.text = lastAnswer
            }
            else {
                currentExpression.text = currentExpression.text! + lastAnswer!
            }
        }
    }
    
    
    @IBAction func sqrtPressed(sender: UIButton) {
        
        if (userIsInTheMiddelOfEnteringAnExpression == false) {
            userIsInTheMiddelOfEnteringAnExpression = true
            currentExpression.text = "√"
        }
        
        else {
           currentExpression.text = currentExpression.text! + "√" 
        }
        
    }
    
    
}

