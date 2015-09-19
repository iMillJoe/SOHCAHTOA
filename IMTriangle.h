//
///  IMTriangle.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> 



@interface IMTriangle : NSObject



@property double sideA, sideB, sideC, angleA, angleB, angleC; // The things you would expect a triangle to have
@property CGPoint pointA, pointB, pointC;

@property double angleOfRotation; // Angle side C is rotated from X (positive) axis, increasing in CCW direction.

@property BOOL shouldUseDegrees; // set to YES for degrees, (my preferred measure of angles)



//init methods, initWithIMTriangle: is the designated init
-(id) initWithTriangle: (IMTriangle*) triangle;

-(id) initFromThreeSidesWithSideA: (double)sideA sideB:(double)sideB  andSideC:(double)sideC usingDegrees: (BOOL) degrees;

-(id) initFromSideAngleSideWithAngleA: (double)angleA sideB:(double)sideB  andSideC:(double)sideC usingDegrees:(BOOL)degrees;

-(id) initFromAngleSideAngleWithAngleA: (double)angleA sideB:(double)sideB andAngleC:(double)angleC usingDegrees:(BOOL)degrees;

-(id) initFromThreePointsWithPointA: (CGPoint)pointA pointB: (CGPoint)pointB andPointC: (CGPoint)pointC usingDegrees:(BOOL)degrees;



//solve method figures out the data it can from the users input
-(void) solve;

//convenience methods for returning other triangle attributes.
-(double) area;
-(double) perimeter;
-(double) height;
-(double) base;
-(double) circumDiameter; // the diameter of it's circumcircle
-(CGPoint) circumCenter; // center of the circumcurcle

@end
