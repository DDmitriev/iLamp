//
//  ILBase.m
//  iLamp
//
//  Created by Dmitry Dmitriev on 26.10.14.
//  Copyright (c) 2014 Dmitriy Dmitriev. All rights reserved.
//


/*********        includes        *********/

#import "ILBase.h"

/*********        private interface for ILBase        *********/

@interface ILBase (Private)

+ (UIColor*)_colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

@end

/*********        implementation for ILBase        *********/

@implementation ILBase

#pragma mark -
#pragma mark *** Public Interface ***
#pragma mark -

+ (UIFont*)thinFontOfSize:(CGFloat)size
{
    UIFont* thinFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:size];
    if (thinFont == nil)
        thinFont = [UIFont systemFontOfSize:size];

    return thinFont;
}

+ (UIColor*)warningTextColor
{
    return [[self class] _colorWithRed:235. green:50. blue:50.];
}

+ (UIColor*)darkTextColor
{
    return [[self class] _colorWithRed:5. green:5. blue:6. ];
}

+ (UIColor*)darkDescriptionTextColor
{
    return [[self class] _colorWithRed:127. green:127. blue:127. ];
}

+ (UIColor*)darkBackgroundColor
{
    return [UIColor blackColor];
}

+ (UIColor*)lightBackgroundColor
{
    return [UIColor whiteColor];
}

+ (UIColor*)lightColorForDepth1
{
    return [UIColor whiteColor];
}

+ (UIColor*)lightColorForDepth2
{
    return [[self class] _colorWithRed:152. green:152. blue:152.];
}

+ (UIColor*)lightColorForDepth3
{
    return [[self class] _colorWithRed:51. green:51. blue:51.];
}

#pragma mark -
#pragma mark *** Private Interface ***
#pragma mark -

+ (UIColor*)_colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    return [UIColor colorWithRed:(red / 255.) green:(green / 255.) blue:(blue / 255.) alpha:1.];
}

@end
