//
//  ILRadialLinesLayer.m
//  iLamp
//
//  Created by Dmitriy Dmitriev on 28.11.13.
//  Copyright (c) 2013 Dmitriy Dmitriev. All rights reserved.
//

/*********        includes        *********/

#import "ILRadialLinesLayer.h"

/*********        forward declarations, globals and typedefs        *********/

#define DEGREES_TO_RADIANS(x) (M_PI * x / 180.0)

/*********        implementation for ILRadialLinesLayer        *********/

@implementation ILRadialLinesLayer

@synthesize angleInDegrees = _angleInDegrees;
@synthesize lineColor = _lineColor;

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        self.contentsScale = [UIScreen mainScreen].scale;
        self.rasterizationScale = [UIScreen mainScreen].scale;
        self.shouldRasterize = YES;
    }

    return self;
}

- (void)dealloc
{
    [_lineColor release];

    [super dealloc];
}

#pragma mark -
#pragma mark *** CALayer methods ***
#pragma mark -

-(void)drawInContext:(CGContextRef)context
{
    CGContextSetFillColorWithColor(context, self.backgroundColor);
    CGContextFillRect(context, self.bounds);

    CGFloat lineWidth = 0.5;
    CGContextSetLineWidth(context, lineWidth);

    CGMutablePathRef path = CGPathCreateMutable();
    CGContextBeginPath(context);
    CGPathMoveToPoint(path, NULL, CGRectGetMidX(self.bounds), CGRectGetMinY(self.bounds));
    CGPathAddLineToPoint(path, NULL, CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));
    CGPathCloseSubpath(path);

    CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);

    for (NSInteger index = 0, count = ((360 / _angleInDegrees) / 2); index < count; index++)
    {
        CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformTranslate(transform, center.x, center.y);
        transform = CGAffineTransformRotate(transform, DEGREES_TO_RADIANS(_angleInDegrees * index));
        transform = CGAffineTransformTranslate(transform, -center.x, -center.y);

        CGPathRef rotatedPath = CGPathCreateCopyByTransformingPath(path, &transform);

        CGContextAddPath(context, rotatedPath);
        CGContextStrokePath(context);
        CGPathRelease(rotatedPath);
    }

    CGPathRelease(path);
}

@end
