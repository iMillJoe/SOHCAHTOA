//
//  SecondViewController.swift
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


/* protocol IMTriangleDrawViewDataSource {
    
    func triangle() -> (dataSource: IMTriangle)
}
*/

class TriangleViewController: UIViewController {


    
    @IBOutlet weak var sideATextField: UITextField!
    @IBOutlet weak var sideBTextField: UITextField!
    @IBOutlet weak var sideCTextField: UITextField!
    @IBOutlet weak var angleATextField: UITextField!
    @IBOutlet weak var angleBTextField: UITextField!
    @IBOutlet weak var angleCTextField: UITextField!
    @IBOutlet weak var TriangeDrawView: UIView!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let triangle: IMTriangle = IMTriangle(fromThreeSidesWithSideA: 2.0, sideB: 3.5, andSideC: 4.6, usingDegrees: true)
        print(triangle)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func triangle() -> IMTriangle?
    {
        if ( sideATextField.text != nil && sideBTextField.text != nil && sideCTextField != nil )
        {
            let aS = sideATextField.text! as NSString
            let bS = sideBTextField.text! as NSString
            let cS = sideCTextField.text! as NSString
            
            let a = aS.doubleValue
            let b = bS.doubleValue
            let c = cS.doubleValue
            
            let tri: IMTriangle = IMTriangle(fromThreeSidesWithSideA: a, sideB: b, andSideC: c, usingDegrees: true)
            
            // println(triangle)
            
            return tri
        }
        
        
        return nil
    }
    
    

    @IBAction func solvePressed(sender: UIButton) {
        let tri = self.triangle()
        print(tri)
        
    }
    
    

}

