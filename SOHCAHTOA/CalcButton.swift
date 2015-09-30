//
//  CalcButton.swift
//  SOHCAHTOA
//
//  Created by iMillJoe on 2/21/15.
//  Copyright (c) 2015 iMillIndustries. All rights reserved.
//

import UIKit

@IBDesignable class CalcButton: UIButton {

//    
//     Only override drawRect: if you perform custom drawing.
//     An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        self.window?.backgroundColor = UIColor.grayColor()
        self.tintColor = UIColor.grayColor()
        self.alpha = 1
        self.tintColorDidChange()
        self.titleLabel?.textColor = UIColor.greenColor()
        
        
    }
    

}
