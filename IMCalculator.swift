//
//  IMCalculator.swift
//  SOHCAHTOA
//
//  Created by Joe Million on 12/9/14.
//  Copyright (c) 2014 iMillIndustries. All rights reserved.
//

import Foundation


struct IMShuntingToken: Printable {
    
    var precedence: Int?
    var isRightAssociative: Bool?
    var isFunction: Bool?
    var numberValue: NSNumber?
    var stringValue: NSString?
    
    var description: String {
        return "Token '\(stringValue)', prec: \(precedence) rightAss: \(isRightAssociative) strValue: \(stringValue) numValue: \(numberValue)"
    }
    
    init(initFromObject input: AnyObject)
    {
        
        var inpt: NSString
        
        if (input.isKindOfClass(NSString))
        {
            stringValue = input as? NSString
        }
        else if (input.isKindOfClass(NSNumber))
        {
            numberValue = input.doubleValue
            stringValue = input.stringValue
        }
        
        if (stringValue != nil)
        {
            inpt = stringValue!

            switch inpt {
                case "^":
                    precedence = 4
                    isRightAssociative = true
                    stringValue = inpt
                
                case "Q":
                    precedence = 4
                    isRightAssociative = false
                    stringValue = "SQRT"
                
                case "*" , "/":
                    precedence = 3
                    isRightAssociative = false
                    stringValue = inpt
                
                case "⁻":
                    precedence = 3
                    isRightAssociative = true
                    stringValue  = inpt
            
                case "+", "-":
                    precedence = 2
                    isRightAssociative = false
                    stringValue = inpt
                
                case "S", "C", "T":
                    precedence = 3
                    isRightAssociative = true
                    switch inpt
                    {
                        case "S":
                        stringValue = "SIN"
                        
                        case "T":
                        stringValue = "TAN"
                        
                        case "C":
                        stringValue = "COS"
                        
                        default:
                        stringValue = "IMShunting token: Trig Function Error"
                    }
                
                case "(", ")", ",":
                    stringValue = inpt
                
                case "π":
                    stringValue = inpt
                    numberValue = M_PI
                case "²":
                    stringValue = "² still getting in"
                
                default:
                    if (numberValue != nil)
                    {
                        stringValue = numberValue!.stringValue
                    }
                    else
                    {
                    stringValue = "IMShuntingToken Error"
                    }
            }
        }
        
        println(description)
    }
}

class IMCalculator {
    
    
    /// returns an NSNumber 'result' or a String 'syntaxError' of an expression.
    class func evaluateExpression(input: String) ->(result: NSNumber?, syntaxError: String?){
        
        
        var filteredInput = input.stringByReplacingOccurrencesOfString("SIN", withString: "S", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        filteredInput = filteredInput.stringByReplacingOccurrencesOfString("COS", withString: "C", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        filteredInput = filteredInput.stringByReplacingOccurrencesOfString("TAN", withString: "T", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        filteredInput = filteredInput.stringByReplacingOccurrencesOfString("SQRT", withString: "Q", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        filteredInput = filteredInput.stringByReplacingOccurrencesOfString("²", withString: "^2", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        println("input: \(input)")
        println("filteredInput: \(filteredInput)")
        

        var syntaxError: String = ""
        
        // Wrap the input string into an Array called inputCue
        var inputCue: Array<Character> = []
        
        for char in filteredInput
        {
            inputCue.append(char)
        }
        
        println(" ** inputCue: \(inputCue)")
        
        var numberBuilder: String = ""
        var tokenized: Array <IMShuntingToken> = []
        //var tokenizer: NSMutableArray = []
        
        while (inputCue.count > 0)
        {
            var inputChar: Character = inputCue.first!
            //println(inputChar)
            
            switch inputChar {
                
            // If inputChar is a space, remove it and move on
            case " ":
                inputCue.removeAtIndex(0)
                inputChar = inputCue.first!
                
            // if inputChar is an operator or function
            case "*", "/", "+", "-", "S", "C", "T", "(", ")", "π", "√", "²", "⁻", "^":
                
                // if numberBuilder has a value
                
                if (!numberBuilder.isEmpty) {
                    
                    // Add numberbuilder to tokenized
                    let str: NSString = numberBuilder as NSString
                    let num: NSNumber = str.doubleValue
                    let tok: IMShuntingToken = IMShuntingToken(initFromObject: num)
                    tokenized.append(tok)
                    numberBuilder = ""
                }
                
                var opr: NSString = String.convertFromStringInterpolationSegment(inputChar)
                var tok: IMShuntingToken = IMShuntingToken(initFromObject: opr)
                
                tokenized.append(tok)
                
                
            // If input char could make a number
            case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ".":
                
                var peek: Bool = false
                for char in numberBuilder
                {
                    if (char == "." && inputChar == ".")
                    {
                        peek = true
                        syntaxError = "Bad Decimal"
                    }
                }
                
                if !peek
                {
                    numberBuilder.append(inputChar)
                }
                
            default:
                syntaxError = "Fuck Off" //throw exeption
            }
            inputCue.removeAtIndex(0);
        }
        
        if (!numberBuilder.isEmpty)
        {
            // Add numberbuilder to tokenized
            let str: NSString = numberBuilder as NSString
            let num: NSNumber = str.doubleValue
            let tokn: IMShuntingToken = IMShuntingToken(initFromObject: num)
            
            tokenized.append(tokn)
        }
        
        var operandStack: Array <NSNumber> = []
        
        return (nil, syntaxError)
        
        
        /*

        While there are tokens to be read:
            Read a token.
            If the token is a number, then add it to the output queue.
            If the token is a function token, then push it onto the stack.
            If the token is a function argument separator (e.g., a comma):
                Until the token at the top of the stack is a left parenthesis, pop operators off the stack onto the output queue. If no left parentheses are encountered, either the separator was misplaced or parentheses were mismatched.
            If the token is an operator, o1, then:
                while there is an operator token, o2, at the top of the stack, and
                either o1 is left-associative and its precedence is *less than or equal* to that of o2,
                or o1 if right associative, and has precedence *less than* that of o2,
                    then pop o2 off the stack, onto the output queue;
                push o1 onto the stack.
            If the token is a left parenthesis, then push it onto the stack.
            If the token is a right parenthesis:
                Until the token at the top of the stack is a left parenthesis, pop operators off the stack onto the output queue.
                Pop the left parenthesis from the stack, but not onto the output queue.
                If the token at the top of the stack is a function token, pop it onto the output queue.
                If the stack runs out without finding a left parenthesis, then there are mismatched parentheses.
        
        When there are no more tokens to read:
            While there are still operator tokens in the stack:
                If the operator token on the top of the stack is a parenthesis, then there are mismatched parentheses.
                Pop the operator onto the output queue.

        */
        
        
        
        

    }
    
    
    
}