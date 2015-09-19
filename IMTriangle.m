//
///  IMTriangle.m
//
//  Created by iMill Industries on 8/2/13.
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
 *///

#import "IMTriangle.h"



//private declarations
@interface IMTriangle()
@property BOOL solved; //Is this triangle solved completely?
@property NSString *error; //Error message
@end

@implementation IMTriangle

@synthesize sideA                       =_sideA;
@synthesize sideB                       =_sideB;
@synthesize sideC                       =_sideC;
@synthesize angleA                      =_angleA;
@synthesize angleB                      =_angleB;
@synthesize angleC                      =_angleC;
@synthesize pointA                      =_pointA;
@synthesize pointB                      =_pointB;
@synthesize pointC                      =_pointC;
@synthesize shouldUseDegrees            =_shouldUseDegrees;
@synthesize angleOfRotation             =_angleOfRotation;
@synthesize solved                      =_solved;
@synthesize error                       =_error;


//Find a way to make sure that any part of the triangle, I don't currently know, but wish too, is calculated, when AND ONLY WHEN, it is needed at runtime

//****** TO DO ***** 
//Warn user if an side/angle that is being set, does not jive with other data entered.

#pragma mark init methods

-(id) initWithTriangle:(IMTriangle *)triangle
{
    if (self = [super init])
    {
        if (triangle.solved == YES)
        {
          self = triangle;
        }
        else
        {
            [triangle solve];
            if (triangle.solved == YES)
            {
                self = triangle;
            }
            else return nil;
        }
        return self;
    }
    NSLog(@"initWithTriangle: failed");
    return nil;
    
}

-(id) initFromThreeSidesWithSideA: (double)sideA sideB:(double)sideB  andSideC:(double)sideC usingDegrees: (BOOL)degrees;
{
    if (degrees) _shouldUseDegrees = YES;
    if (!(_sideA && _sideB && _sideC))
    {
        self.sideA = sideA , self.sideB = sideB , self.sideC = sideC;
        [self solve];
    }
    else NSLog(@"IMTriangle initFromThreeSides... Triangle already exisits!");
    if (self.solved)
    {
        return [self initWithTriangle:self];
    }
    else
    {
        NSLog(@"IMTriangle initFromThreeSides: failed");
        return nil;
    }
}

-(id) initFromSideAngleSideWithAngleA: (double)angleA sideB:(double)sideB  andSideC:(double) sideC usingDegrees:(BOOL)degrees;
{
    if (degrees) _shouldUseDegrees = YES;
    if (!(self.sideA && self.sideB && self.sideC))
    {
        self.angleA = angleA , self.sideB = sideB , self.sideC = sideC;
        [self solve];
    }
    else NSLog(@"initFromSideAngleSide: failed, triangle already exisits");
    if (self.solved) {
        return [self initWithTriangle: self];
    }
    else
    {
        NSLog(@"initFromSideAngleSide: failed");
        return nil;
    }
}

-(id) initFromAngleSideAngleWithAngleA: (double)angleA sideB:(double)sideB andAngleC:(double)angleC usingDegrees:(BOOL)degrees;
{
    if (degrees) _shouldUseDegrees = YES;
    if (!(self.angleA && _sideB && self.angleC))
    {
        self.angleA = angleA , self.sideB = sideB , self.angleC = angleC;
        [self solve];
    }
    else NSLog(@"initFromAngleSideAngle: failed, triangle already exists");
    if (self.solved) {
        return [self initWithTriangle: self];
    }
    else
    {
        NSLog(@"initFromAngleSideAngle: failed");
        return nil;
    }
}


-(id) initFromThreePointsWithPointA: (CGPoint)pointA pointB: (CGPoint)pointB andPointC: (CGPoint)pointC usingDegrees:(BOOL)degrees
{
    
    /*
      YOU WILL FIND THIS WEBSITE HELPFULL
     http://www.endmemo.com/geometry/triangle.php
     */
    
    // Store args to instance vars.
    self.pointA = pointA, self.pointB = pointB, self.pointC = pointC;
    
    // Find lenth of sideA
    // NSLog(@"selfA.x: %f selfA.y: %f", self.pointA.x, self.pointA.y);
    // NSLog(@"selfB.x: %f selfB.y: %f", self.pointB.x, self.pointB.y);
    // NSLog(@"selfB.C: %f selfC.y: %f", self.pointC.x, self.pointC.y);
    double sideADeltaX = fabs(pointB.x - pointC.x);
    double sideADeltaY = fabs(pointC.y - pointB.y);
    
    NSLog(@"sideADeltaX: %f sideADeltaY %f", sideADeltaX, sideADeltaY);
    
    if (sideADeltaX == 0)
    {
        if (sideADeltaY == 0)
        {
            NSLog(@"IMTriangle: Don't use the same points");
        }
        
        else
        {
            self.sideA = sideADeltaY;
            
        }
    }
    else
    {
        
        self.sideA = ( sqrt( (sideADeltaX * sideADeltaX) + (sideADeltaY * sideADeltaY)) );
    }
    
    //NSLog(@"sideADeltaX: %f sideADeltaY: %f sideA %f",sideADeltaX, sideADeltaY, self.sideA);
    
    
    // ..sideB
    double sideBDeltaX = ( fabs(pointA.x - pointC.x) );
    double sideBDeltaY = ( fabs(pointC.y - pointA.y) );
    
    if (sideBDeltaX == 0) {
        if (!sideBDeltaY == 0)
        {
            self.sideB = sideBDeltaY;
        }
        else
        {
            NSLog(@"IMTriangle: don't use the same points");
        }
    }
    else if (sideBDeltaY == 0)
    {
        self.sideB = sideBDeltaX;
    }
    else
    {
        self.sideB = (sqrt( (sideBDeltaX * sideBDeltaX) + (sideBDeltaY * sideBDeltaY)) );
    }
    
    //NSLog(@"sideBDeltaX: %f sideBDeltaY: %f sideB %f", sideBDeltaX, sideBDeltaY, self.sideB);
    
    // .. sideC
    double sideCDeltaX = ( fabs(pointB.x - pointA.x) );
    double sideCDeltaY = ( fabs(pointA.y - pointB.y) );
    
    if (sideCDeltaX == 0)
    {
        if (! sideCDeltaY == 0)
        {
            self.sideC = sideCDeltaY;
        }
        else
        {
            NSLog(@"don't use the same points");
        }
    }
    else
    {
        self.sideC = (sqrt( (sideCDeltaX * sideCDeltaX) + (sideCDeltaY * sideCDeltaY)) );
    }
    
    //NSLog(@"sideCDeltaX: %f sideCDeltaY: %f sideC %f",sideCDeltaX, sideCDeltaY, self.sideC);
    
    [self solve];
    if (degrees) self.shouldUseDegrees = YES;
    
    //NSLog(@"%@", self);
    
    return self;
}

#pragma mark solve

-(void) solve
{
    bool shouldOutputDegrees = NO;
    if (self.shouldUseDegrees)
    {
        self.shouldUseDegrees = NO;
        shouldOutputDegrees = YES;
    }

    if (self.sideA && self.sideB && self.sideC)
    {
        //If any one leg is longer than the sum of of the other two, it's not a traingle.
        if ( (self.sideA > self.sideB + self.sideC) || (self.sideB > self.sideC + self.sideA) || (self.sideC > self.sideB + self.sideA) )
        {
            self.error = @"not a triangle";
        }
        
        //If the triangle has Three sides, find it's angles,
        self.angleA = acos(  ((self.sideB*self.sideB)+(self.sideC*self.sideC) - (self.sideA*self.sideA))/(2*self.sideB*self.sideC)  );
        self.angleB = acos(  ((self.sideC*self.sideC)+(self.sideA*self.sideA) - (self.sideB*self.sideB))/(2*self.sideC*self.sideA)  );
        self.angleC = M_PI - self.angleA - self.angleB;
    }
    
    else if (self.angleA && self.sideB && self.angleC)
    {
        //Solve with AsA for AbC
        self.angleB = M_PI - self.angleA - self.angleC;
        self.sideC = (self.sideB * sin(self.angleC))/ sin(self.angleB);
        self.sideA = (self.sideB * sin(self.angleA))/ sin(self.angleB);
    }
    
    else if (self.angleB && self.sideC && self.angleA)
    {
        //solve with ASA for BcA
        self.angleC = M_PI - self.angleB - self.angleA;
        self.sideA = (self.sideC * sin(self.angleA))/ sin(self.angleC);
        self.sideB = (self.sideC * sin(self.angleB))/ sin(self.angleC);
        
    }
    
    else if (self.angleC && self.sideA && self.angleB)
    {
        //solve with ASA for CaB
        self.angleA = M_PI - self.angleC - self.angleB;
        self.sideB = (self.sideA * sin(self.angleB))/ sin(self.angleA);
        self.sideC = (self.sideA * sin(self.angleC))/ sin(self.angleA);
        
    }
    
    else if (self.angleA && self.sideB && self.sideC)
    { 
        //solve by SAS for Abc 
        //law of cos for c
        //a² = b² + c² - 2bc cosA
        self.sideC = sqrt(  (self.sideB*self.sideB)+(self.sideC*self.sideC) - ((2*self.sideB*self.sideC) * ( cos(self.angleA) ))  );
        
        //law of sin for B
        self.angleB = (  asin( ( self.sideB * (sin(self.angleA)) )/ self.sideA)  );
        self.angleC = M_PI - self.angleB - self.angleA;
    }
    
    else if (self.angleC && self.sideA && self.sideB)
    {
        //solve by SAS for Cab
         self.sideC = sqrt(  (self.sideA*self.sideA)+(self.sideB*self.sideB) - (2 *self.sideA*self.sideB) * ( cos(self.angleC) )  );
        self.angleA = (  asin( ( self.sideA * (sin(self.angleC)) )/ self.sideC)  );
        self.angleB = M_PI - self.angleC - self.angleA;
        
    }
    
    else if (self.angleB && self.sideA && self.sideC)
    {
        //solve with SAS for Bac
        self.sideB = sqrt(  (self.sideA*self.sideA)+(self.sideC*self.sideC) - (2 *self.sideA*self.sideC) * ( cos(self.angleB) )  );
        self.angleC = (  asin( ( self.sideA * (sin(self.angleB)) )/ self.sideB)  );
        self.angleA = M_PI - self.angleC - self.angleB;
    }

    else if ( (self.angleA && self.angleB) || (self.angleB && self.angleC) || (self.angleC && self.angleA) )
    {
        //solve for AAA, Note that this cannot solve for sides area or perimeter.
        if (self.angleA && self.angleB)
        {
            self.angleC = M_PI - self.angleA - self.angleB;
        }
        
        else if (self.angleB && self.angleC)
        {
            self.angleA = M_PI - self.angleB - self.angleC;
        }
        
        else if (self.angleB && self.angleC)
        {
            self.angleA = M_PI - self.angleB - self.angleC;
        }
        
        else NSLog(@"failed to solve AAA");
    }
    
    else
    {
        self.error = @"Could not parse IMTriangle";
        NSLog(@"%@",self.error);
    }
    
    
    self.shouldUseDegrees = shouldOutputDegrees;

    if (self.sideA && self.sideB && self.sideC && self.angleA && self.angleB && self.angleC && !self.error)
    {
        self.solved = YES;
    }
}

#pragma mark setters and getters

-(void) setAngleA:(double)angleA
{
    if (!self.shouldUseDegrees)
    {
        _angleA = angleA;
    }
    
    else _angleA = angleA * M_PI/180;
    
    //should I set the error?
    if  (angleA > M_PI && !self.shouldUseDegrees)
    {
        self.error = @"Not a triangle, angleA is greater than Pi";
    }
    
    if (angleA > 180 && self.shouldUseDegrees)
    {
        self.error = @"Not a triangle, angleA is greater than 180 deg";
    }
}

-(double) angleA
{
    if (!self.shouldUseDegrees)
    {
        return _angleA;
    }
    return  _angleA * 180/M_PI;
}

-(void) setAngleB:(double)angleB
{
    if (!self.shouldUseDegrees)
    {
        _angleB = angleB;
    }
    else _angleB = angleB * M_PI/180;
    
    if  (angleB > M_PI && !self.shouldUseDegrees)
    {
        self.error = @"Not a triangle, angleB is greater than Pi";
    }
    else if (angleB > 180 && _shouldUseDegrees)
    {
        self.error = @"Not a triangle, angleB is greater than 180 deg";
    }
}

-(double) angleB
{
    if (!self.shouldUseDegrees)
    {
        return _angleB;
    }
    return  _angleB * 180/M_PI;
}

-(void) setAngleC:(double)angleC
{
    if (!self.shouldUseDegrees)
    {
        _angleC = angleC;
    }
    else _angleC = angleC * M_PI/180;
    
    if  (angleC > M_PI && !self.shouldUseDegrees)
    {
        self.error = @"Not a triangle, angleC is greater than Pi";
    }
    if (angleC > 180 && self.shouldUseDegrees)
    {
        self.error = @"Not a triangle, angleC is greater than 180 deg";
    }
}

-(double) angleC
{
    if (!self.shouldUseDegrees)
    {
        return _angleC;
    }
    return _angleC * 180/M_PI;
}

-(void) setAngleOfRotation:(double)angleOfRotation
{
    if (!self.shouldUseDegrees){
        _angleOfRotation = angleOfRotation;

    }
    else _angleOfRotation =angleOfRotation * M_PI/180;
    
    if  (angleOfRotation > M_PI*2 && !self.shouldUseDegrees)
    {
        self.error = @"angleOfRotation is greater than 2Pi";
    }
    if (angleOfRotation > 180 && self.shouldUseDegrees)
    {
        self.error = @"angleOfRotation is greater than 360 deg";
    }
}

-(double) angleOfRotation
{
    if (!self.shouldUseDegrees) {
        return self.angleOfRotation;
    }
    return  _angleOfRotation * 180/M_PI;
}

#pragma mark convenience methods

//**********************************************
-(double) circumDiameter
{
    //
    
    if (self.solved) {
        return 2 * ( (self.sideA * self.sideB * self.sideC) /
               ( sqrt( (self.sideA + self.sideB + self.sideC) *
                       (self.sideB + self.sideC - self.sideA) *
                       (self.sideC + self.sideA - self.sideB) *
                       (self.sideA + self.sideB - self.sideC) ) ));
    }
    
    return 0;
}

-(CGPoint) circumCenter
{
    CGPoint point;

    
    // The Cartesian coordinates of the circumcenter are
    
    double D;
    double A_x = self.pointA.x;
    double A_y = self.pointA.y;
    double B_x = self.pointB.x;
    double B_y = self.pointB.y;
    double C_x = self.pointC.x;
    double C_y = self.pointC.y;
    
    
    // D = 2( A_x(B_y - C_y) + B_x(C_y - A_y) + C_x(A_y - B_y)).
    D = 2 * ( A_x * (B_y - C_y) + B_x * (C_y - A_y) + C_x * (A_y - B_y));
    
    
    // U_x = ((A_x^2 + A_y^2)(B_y - C_y) + (B_x^2 + B_y^2)(C_y - A_y) + (C_x^2 + C_y^2)(A_y - B_y)) / D,
    point.x = ( ((A_x*A_x) + (A_y*A_y)) * (B_y - C_y) + ((B_x*B_x) + (B_y*B_y)) * (C_y - A_y) + ((C_x*C_x) + (C_y*C_y)) * (A_y - B_y)) / D;
    
    
    //U_y = ((A_x^2 + A_y^2)(C_x - B_x) + (B_x^2 + B_y^2)(A_x - C_x) + (C_x^2 + C_y^2)(B_x - A_x)) / D
    point.y = ((A_x*A_x + A_y*A_y) * (C_x - B_x) + (B_x*B_x + B_y*B_y) * (A_x - C_x) + (C_x*C_x + C_y*C_y) * (B_x - A_x)) / D;
    
    
    
    
    NSLog(@"circumPointX: %f circumPointY: %f", point.x, point.y);
    
    return point;
    
}
//**********************************************

-(double) height
{
    if (self.sideA && self.sideB && self.sideC)
    {
        return self.sideB*( sin(self.angleA) );
    }
	else return 0; 
}

-(double) perimeter
{
    if (self.sideA && self.sideB && self.sideC)
    {
        return self.sideA + self.sideB + self.sideC;
    }
    else return 0;
}

-(double) area
{
    if (self.sideA && self.sideB && self.sideC)
    {
        double x = self.perimeter/2; //x is half the sum of the sides
        return self.sideA * (2/self.sideA) * sqrt(x*(x-self.sideA)*(x-self.sideB)*(x-self.sideC)) / 2;//Heron's formula for area
    }
    else return 0;
}

-(double) base
{
    return self.sideC;
}

-(CGPoint) center
{
    //does not work yet. 
    
    return CGPointMake(0, 0);
    
}

-(NSString *) description;
{
    if (self.error)
    {
        return [NSString stringWithFormat:@"IMTriangle ERROR %@ a=%.4f b=%.4f c=%.4f A=%.4f B=%.4f C=%.4f perimeter=%.4f area=%.4f height=%.4f circumDia= %.4f shouldUseDegrees = %i", self.error, self.sideA , self.sideB , self.sideC , self.angleA , self.angleB , self.angleC ,self.perimeter , self.area ,  self.height, [self circumDiameter], self.shouldUseDegrees];
        
    }
    else return [NSString stringWithFormat:@"\n\nIMTriangle\na: %.4f b: %.4f c: %.4f \nA: %.4f B: %.4f C: %.4f \nperimeter: %.4f area: %.4f height: %.4f \ncircumDia: %.4f circumCenter: (%f, %f) shouldUseDegrees: %i\npointA: (%f, %f) pointB: (%f, %f) pointC: (%f, %f)\n\n", self.sideA , self.sideB , self.sideC , self.angleA , self.angleB , self.angleC , self.perimeter , self.area ,  self.height , self.circumDiameter, self.circumCenter.x, self.circumCenter.y ,self.shouldUseDegrees, self.pointA.x, self.pointA.y, self.pointB.x, self.pointB.y, self.pointC.x, self.pointC.y ];
    
    
}

@end