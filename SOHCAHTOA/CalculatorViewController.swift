//
//  CalculatorViewController.swift
//  SOHCAHTOA
//
//  Created by iMillJoe on 10/22/14.
/*
< SOHCOATOA, an app for working with triangles >
Copyright (C) <2014>  <iMill Industries>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. (see AppDelegate.swift) If not, see <http://www.gnu.org/licenses/>.
*/

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
                currentExpression.text = (lastAnswer! as String) + sender.currentTitle!
                userIsInTheMiddelOfEnteringAnExpression = true
            }
        else if (currentExpression.text != "0" ) {
            currentExpression.text = currentExpression.text! + sender.currentTitle!
            
        } else {
            currentExpression.text = sender.currentTitle
            userIsInTheMiddelOfEnteringAnExpression = true
        }
    }
    
    
    @IBAction func squarePressed(sender: UIButton) {
        
        if (self.userIsInTheMiddelOfEnteringAnExpression == false && currentExpression.text == "0") {
            
            if (lastAnswer?.doubleValue != nil) {
                currentExpression.text = lastAnswer as? String
                userIsInTheMiddelOfEnteringAnExpression = true
            }
        }
        currentExpression.text = currentExpression.text?.stringByAppendingString("²")
    }
    
    
    @IBAction func enterPressed(sender: UIButton) {
        
        if (currentExpression.text != nil) {
            let ans = IMCalculator.evaluateExpression(currentExpression.text!)
            if (ans.result != nil) {
                lastAnswer = ans.result!.stringValue
                answerTextView.text = answerTextView.text + "\r \(currentExpression.text!) = \(ans.result!.stringValue)"
            }
            else if (ans.syntaxError != nil) {
                lastAnswer = nil
                answerTextView.text = answerTextView.text + "\r \(currentExpression.text!) = \(ans.syntaxError!)"
            }
            answerTextView.scrollRangeToVisible( NSMakeRange(answerTextView.text.characters.count, 0))
        }
        userIsInTheMiddelOfEnteringAnExpression = false
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
        
        let suffix = currentExpression.text!.substringFromIndex(currentExpression.text!.endIndex.predecessor())
        
        var shouldAppenedNegitiveForSuffix: Bool {
            switch suffix {
            case "*","/", "+", "-", "(", ")", "n", "s", "√": return true
            default: return false
            }
        }
        
        if (shouldAppenedNegitiveForSuffix == true) {
                currentExpression.text = currentExpression.text! + "⁻"
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
                currentExpression.text = lastAnswer as? String
            }
            else {
                currentExpression.text = currentExpression.text! + (lastAnswer! as String)
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

