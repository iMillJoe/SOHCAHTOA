//
//  IMCalculator.swift
//  SOHCAHTOA
//
//  Created by iMillJoe on 12/9/14.
//  Copyright (c) 2014 iMillIndustries. All rights reserved.
//
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

import Foundation

extension String {
    func asDouble() -> Double? {
        
        if let dub: Double = (self as NSString).doubleValue {
            return dub
        }
        return nil
    }
}

private struct IMShuntingToken: CustomStringConvertible {
    
    var precedence: Int?
    var isRightAssociative: Bool?
    var isFunction: Bool?
    var numberValue: NSNumber?
    var stringValue: NSString?
    var description: String {
        return "Token '\(stringValue)', prec: \(precedence) rightAss: \(isRightAssociative) strValue: \(stringValue) numValue: \(numberValue)"
    }
    
    init(initFromObject input: AnyObject) {
        
        
        if (input.isKindOfClass(NSString)) {
            stringValue = input as? NSString
        }
        else if (input.isKindOfClass(NSNumber)) {
            numberValue = input.doubleValue
            stringValue = input.stringValue
        }
        
        if let inpt = stringValue {

            switch inpt {
                case "^", "√":
                    precedence = 4
                    isRightAssociative = true
                    stringValue = inpt
                
                case "*" , "/":
                    precedence = 3
                    isRightAssociative = false
                    stringValue = inpt
                
                case "⁻", "∫", "⊂", "⊃":
                    precedence = 3
                    isRightAssociative = true
                    stringValue = inpt
            
                case "+", "-":
                    precedence = 2
                    isRightAssociative = false
                    stringValue = inpt
                
                case "(", ")", ",":
                    stringValue = inpt
                
                case "π":
                    stringValue = inpt
                    numberValue = M_PI
                
                default:
                    if (numberValue != nil) {
                        stringValue = numberValue!.stringValue
                    }
                    else {
                    stringValue = "IMShuntingToken Error"
                    }
            }
        }
    }
}

class IMCalculator {
    
    
    /// returns an NSNumber 'result' and a String 'syntaxError' of an expression.
    class func evaluateExpression(input: String) -> (result: NSNumber?, syntaxError: String?) {

        
        // sin="∫" cos="⊂" tan="⊃"
        let filters = [
            "SIN": "∫",  "COS": "⊂", "TAN": "⊃",
            "SQRT": "√", "²": "^2",  "pi": "π",
            "--": "-⁻",  "*-": "*⁻", "+-": "+⁻",
            "/-": "/⁻",  "**": "^",  " " : ""
        ]
        
        var filteredInput = input
        for (oldStr, newStr) in filters {
            filteredInput = filteredInput.stringByReplacingOccurrencesOfString(oldStr, withString: newStr, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        }
        
        if (filteredInput.hasPrefix("-"))
        {
            filteredInput = filteredInput.stringByReplacingOccurrencesOfString("-", withString: "⁻", options: NSStringCompareOptions.CaseInsensitiveSearch, range: filteredInput.startIndex ..< filteredInput.startIndex.successor() )
        }
        
        
        print("input: \(input)")
        // println("filteredInput: \(filteredInput)")
        
        var syntaxError: String? = nil
    
        // Wrap the input string into an Array called inputCue
        var inputCue: Array<Character> = []
        
        for char in filteredInput.characters {
            inputCue.append(char)
        }
        
        // println(" ** inputCue: \(inputCue)")
        
        var numberBuilder = ""
        var tokenized = Array<IMShuntingToken>()
        //var tokenizer: NSMutableArray = []
        
        while (inputCue.count > 0) {
            var inputChar: Character = inputCue.first!
            //println(inputChar)
            
            switch inputChar {
                
            // If inputChar is a space, remove it and move on
            case " ":
                inputCue.removeAtIndex(0)
                inputChar = inputCue.first!
                
            // if inputChar is an operator or function
                // sin= "∫" cos="⊂" tan="⊃"
            case "*", "/", "+", "-", "∫", "⊂", "⊃", "(", ")", "π", "√", "²", "⁻", "^":
                
                // if numberBuilder has a value
                if (!numberBuilder.isEmpty) {
                    // Add numberbuilder to tokenized
                    tokenized.append(IMShuntingToken(initFromObject: numberBuilder.asDouble()! ))
                    numberBuilder = ""
                }
                tokenized.append(IMShuntingToken(initFromObject: "\(inputChar)"))
                
            // If input char could make a number
            case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ".":
                
                var peek = false
                for char in numberBuilder.characters {
                    if (char == "." && inputChar == ".") {
                        peek = true
                        syntaxError = "Bad Decimal"
                    }
                }
                if !peek {
                    numberBuilder.append(inputChar)
                }
                
            default:
                syntaxError = "syntaxError"
            }
            inputCue.removeAtIndex(0);
        }
        
        //append any remaing number
        if (!numberBuilder.isEmpty) {
            tokenized.append(IMShuntingToken(initFromObject: numberBuilder.asDouble()!))
        }
        
        //quit now if error
        if (syntaxError != nil) {
            return (nil, syntaxError!)
        }
        
        var operandStack = Array<NSNumber>()
        var outputQue = Array<IMShuntingToken>()
        var stack = Array<IMShuntingToken>()
        
        // insert tokens for implicit multiplcation
        for var index = 0; index < tokenized.count; ++index {
            var strVal: String
            let token = tokenized[index]
            if (token.numberValue == nil || token.stringValue == "π") {
                strVal = token.stringValue! as String
                if (strVal == "(" && index > 0) {
                    if (tokenized[index-1].numberValue != nil) {
                        tokenized.insert(IMShuntingToken(initFromObject: "*"), atIndex: index)
                    }
                    else if (tokenized[index-1].stringValue == ")") {
                        tokenized.insert(IMShuntingToken(initFromObject: "*"), atIndex: index)
                    }
                }
                else if (strVal == "π" && index > 0) {
                    if (tokenized[index-1].numberValue != nil) {
                        tokenized.insert(IMShuntingToken(initFromObject: "*"), atIndex: index)
                    }
                }

            }
            else if (token.numberValue != nil) {
                if (index > 0) {
                    if (tokenized[index-1].stringValue == ")" || tokenized[index-1].stringValue == "π") {
                        tokenized.insert(IMShuntingToken(initFromObject: "*"), atIndex: index)
                    }
                }
            }
            
        }
        
        
        /*******  SHUNTING-YARD  *********/
        // While there are tokens to be read:
        while (tokenized.last != nil) {
            
            // Read a token.
            let tok:IMShuntingToken = tokenized.first!
            tokenized.removeAtIndex(0)
            
            // If the token is a number, then add it to the output queue.
            if ((tok.numberValue) != nil) {
                outputQue.append(tok)
            }
            // If the token is a function token, then push it onto the stack.
            else if ((tok.isFunction) != nil) {
                stack.append(tok)
            }
            // If the token is a function argument separator (e.g., a comma):
            else if (tok.stringValue == ",") {
                // Until the token at the top of the stack is a left parenthesis, pop operators off the stack onto the output queue. If no left parentheses are encountered, either the separator was misplaced or parentheses were mismatched.
            }
            
            // If the token is an operator, o1, then:
            else if (tok.precedence != nil) {
                // while there is an operator token, o2, at the top of the stack, and
                // either o1 is left-associative and its precedence is *less than or equal* to that of o2,
                // or o1 if right associative, and has precedence *less than* that of o2,
                // (tok is o1 stack.last is o2)
                while ( (stack.last != nil) &&
                    (( tok.isRightAssociative == false && tok.precedence <= stack.last?.precedence) ||
                      (tok.isRightAssociative == true  && tok.precedence < stack.last?.precedence) )) {
                    // then pop o2 off the stack, onto the output queue;
                    outputQue.append(stack.removeLast())
                }
                
                // push o1 onto the stack.
                stack.append(tok)
            } 

            // If the token is a left parenthesis, then push it onto the stack.
            else if (tok.stringValue! == "(") {
                stack.append(tok)
            }
            
            // If the token is a right parenthesis:
            else if (tok.stringValue == ")")
            {
                
                // Until the token at the top of the stack is a left parenthesis, pop operators off the stack onto the output queue.
                var peek = false
                while (stack.last != nil) {
                    if (stack.last?.stringValue! == "(") {
                        peek = true
                        break;
                    }
                    else {
                        outputQue.append(stack.removeLast())
                        
                    }
                }
                
                // If the stack runs out without finding a left parenthesis, then there are mismatched parentheses.
                if (peek == false) {
                    syntaxError = "mismatched parentheses"
                    return (nil, syntaxError)
                }
    
                // Pop the left parenthesis from the stack, but not onto the output queue.
                stack.removeLast()
                
                // If the token at the top of the stack is a function token, pop it onto the output queue.
                if ((stack.last?.isFunction) != nil) {
                    outputQue.append(stack.removeLast())
                }
            }
            // When there are no more tokens to read:
            if (tokenized.count == 0) {
                // While there are still operator tokens in the stack:
                while (stack.last != nil) {
                    // If the operator token on the top of the stack is a parenthesis, then there are mismatched parentheses.
                    if (stack.last?.stringValue == ")" || stack.last?.stringValue == "(") {
                        syntaxError = "mismatched parentheses"
                    }
                    // Pop the operator onto the output queue.
                    outputQue.append(stack.removeLast())
                }
            }
        }
        
        /*******  END SHUNTING-YARD  *********/
        
        var result: Double?
        
        // While the ouputCue has objects,
        while ((outputQue.last) != nil) {
 
            let token = outputQue.removeAtIndex(0)
            let strVal = token.stringValue
            
            if (token.numberValue != nil) {
                let dub = token.numberValue?.doubleValue
                operandStack.append(dub!)
            }
            
            else if (strVal == "+" && operandStack.count > 1) {
                result = operandStack.removeLast().doubleValue + operandStack.removeLast().doubleValue
                operandStack.append(result!)
            }
            
            else if (strVal == "*" && operandStack.count > 1) {
                result = operandStack.removeLast().doubleValue * operandStack.removeLast().doubleValue
                operandStack.append(result!)
            }
            else if (strVal == "⁻" && operandStack.count > 0) {
                result = operandStack.removeLast().doubleValue * -1.0
                operandStack.append(result!)
            }
            else if (strVal == "-" && operandStack.count > 1) {
                let subtrahend = operandStack.removeLast().doubleValue
                result = operandStack.removeLast().doubleValue - subtrahend
                operandStack.append(result!)
            }
            else if (strVal == "/" && operandStack.count > 1) {
                let divisor = operandStack.removeLast().doubleValue
                if (divisor.isZero) {
                    syntaxError = "division by zero"
                }
                else {
                    result = operandStack.removeLast().doubleValue / divisor
                    operandStack.append(result!)
                }
                
            }
            else if (strVal == "^" && operandStack.count > 1) {
                let exponate = operandStack.removeLast().doubleValue
                let base = operandStack.removeLast().doubleValue
                operandStack.append(pow(base, exponate))
            }
            else if (strVal == "SIN" && !operandStack.isEmpty) {
                result = sin( (operandStack.removeLast().doubleValue * M_PI / 180) )
                operandStack.append(result!)
            }
            else if (strVal == "COS" && !operandStack.isEmpty) {
                result = cos(operandStack.removeLast().doubleValue * M_PI / 180)
                operandStack.append(result!)
            }
            else if (strVal == "TAN" && !operandStack.isEmpty) {
                result = tan(operandStack.removeLast().doubleValue * M_PI / 180)
                operandStack.append(result!)
            }
            
            else if (strVal == "SQRT" && !operandStack.isEmpty) {
                operandStack.append(sqrt(operandStack.removeLast().doubleValue) )
            }
            else if (syntaxError == nil) {
                syntaxError = "syntaxError"
            }
        }
        
        //if the the operandStack contains more than one operand
        //something went wrong!!
        if(operandStack.count > 1) {
            
            syntaxError = "syntaxError"
            print("operandStack \(operandStack)")
        }
        
        if (syntaxError != nil) {
            return (nil, syntaxError)
        }
        
        else {
            return (operandStack.first, syntaxError)
        }
    }

}
