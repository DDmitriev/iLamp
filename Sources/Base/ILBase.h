//
//  ILBase.h
//  iLamp
//
//  Created by Dmitry Dmitriev on 26.10.14.
//  Copyright (c) 2014 Dmitriy Dmitriev. All rights reserved.
//

/*********        includes        *********/

#import <UIKit/UIKit.h>

/*********        interface for ILBase        *********/
/*!
 @class ILBase
 @discussion Base utilities class for the application.
*/

@interface ILBase : NSObject

+ (UIFont*)thinFontOfSize:(CGFloat)size;

+ (UIColor*)warningTextColor;
+ (UIColor*)darkTextColor;
+ (UIColor*)darkDescriptionTextColor;
+ (UIColor*)lightBackgroundColor;
+ (UIColor*)darkBackgroundColor;
+ (UIColor*)lightColorForDepth1;
+ (UIColor*)lightColorForDepth2;
+ (UIColor*)lightColorForDepth3;

@end
