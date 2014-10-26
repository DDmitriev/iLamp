//
//  ILRadialLinesLayer.h
//  iLamp
//
//  Created by Dmitriy Dmitriev on 28.11.13.
//  Copyright (c) 2013 Dmitriy Dmitriev. All rights reserved.
//

/*********        includes        *********/

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

/*********        interface for ILRadialLinesLayer        *********/
/*!
 @class ILRadialLinesLayer
 @discussion Layer with a bunch of radial lines.
*/

@interface ILRadialLinesLayer : CALayer
{
@private
    float _angleInDegrees;
    UIColor* _lineColor;
}

@property (assign, nonatomic) float angleInDegrees;
@property (retain, nonatomic) UIColor* lineColor;

@end
