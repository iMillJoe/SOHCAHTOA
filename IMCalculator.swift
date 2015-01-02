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
    
    init(initFromObject input: AnyObject) {
        
        var inpt: NSString
        
        if (input.isKindOfClass(NSString)) {
            stringValue = input as? NSString
        }
        else if (input.isKindOfClass(NSNumber)) {
            numberValue = input.doubleValue
            stringValue = input.stringValue
        }
        
        if (stringValue != nil) {
            inpt = stringValue!

            switch inpt {
                case "^":
                    precedence = 4
                    isRightAssociative = true
                    stringValue = inpt
                
                case "√":
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
                
                case  "∫", "⊂", "⊃":
                    //sin= "∫" cos="⊂" tan="⊃"
                    precedence = 3
                    isRightAssociative = true
                    switch inpt {
                        case "∫":
                        stringValue = "SIN"
                        
                        case "⊂":
                        stringValue = "COS"
                        
                        case "⊃":
                        stringValue = "TAN"
                        
                        default:
                        stringValue = "IMShunting token: Trig Error"
                    }
                
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
    class func evaluateExpression(input: String) ->(result: NSNumber?, syntaxError: String?){

        
        // sin="∫" cos="⊂" tan="⊃"
        let filters = ["SIN": "∫", "COS": "⊂", "TAN": "⊃", "SQRT": "√","²": "^2", "pi": "π"]
        var filteredInput = input
        for (oldStr, newStr) in filters {
            filteredInput = filteredInput.stringByReplacingOccurrencesOfString(oldStr, withString: newStr, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        }

        println("input: \(input)")
        // println("filteredInput: \(filteredInput)")
        
        var syntaxError: String? = nil
    
        // Wrap the input string into an Array called inputCue
        var inputCue: Array<Character> = []
        
        for char in filteredInput {
            inputCue.append(char)
        }
        
        // println(" ** inputCue: \(inputCue)")
        
        var numberBuilder: String = ""
        var tokenized: Array <IMShuntingToken> = []
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
                    let str: NSString = numberBuilder as NSString
                    let tok: IMShuntingToken = IMShuntingToken(initFromObject: str.doubleValue)
                    tokenized.append(tok)
                    numberBuilder = ""
                }
                
                var opr: NSString = String.convertFromStringInterpolationSegment(inputChar)
                var tok: IMShuntingToken = IMShuntingToken(initFromObject: opr)
                
                tokenized.append(tok)
                
                
            // If input char could make a number
            case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ".":
                
                var peek: Bool = false
                for char in numberBuilder {
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
        
        if (!numberBuilder.isEmpty) {
            // Add numberbuilder to tokenized
            let str: NSString = numberBuilder as NSString
            let num: NSNumber = str.doubleValue
            let tokn: IMShuntingToken = IMShuntingToken(initFromObject: num)
            
            tokenized.append(tokn)
        }
        
        if (syntaxError != nil) {
            return (nil, syntaxError!)
        }
        
        var operandStack: Array <NSNumber> = []
        var outputQue: Array<IMShuntingToken> = []

        var stack: Array<IMShuntingToken>  = []
        
        // insert tokens for implicit multiplcation
        for var index = 0; index < tokenized.count; ++index {
            var strVal: String
            var numVal: Double?
            let token = tokenized[index]
            if (token.numberValue == nil || token.stringValue == "π") {
                strVal = token.stringValue!
                
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
                
                //tok is o1 stack.last is o2
            
                while ( (stack.last != nil) &&
                    (( tok.isRightAssociative == false && tok.precedence? <= stack.last?.precedence?) ||
                      (tok.isRightAssociative == true  && tok.precedence? < stack.last?.precedence?) )) {
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
                if (!peek) {
                    syntaxError = "mismatched parentheses"
                }
                
                // Pop the left parenthesis from the stack, but not onto the output queue.
                stack.removeLast()
                
                // If the token at the top of the stack is a function token, pop it onto the output queue.
                if ((stack.last?.isFunction?) != nil) {
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
        var result: Double?
        
        // While the ouputCue has objects,
        while ((outputQue.last?) != nil) {
 
            let token = outputQue.first?
            outputQue.removeAtIndex(0)
            let strVal = token?.stringValue
            
            if (token?.numberValue != nil) {
                let dub = token?.numberValue?.doubleValue
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
            else if (strVal == "⁻" && operandStack.count > 1) {
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
            println("operandStack \(operandStack)")
        }
        
        if (syntaxError != nil) {
            return (nil, syntaxError?)
        }
        
        else {
            return (operandStack.first, syntaxError?)
        }
    }

}
