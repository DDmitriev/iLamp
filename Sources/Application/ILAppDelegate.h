//
//  ILAppDelegate.h
//  iLamp
//
//  Created by Dmitry Dmitriev on 25.10.14.
//  Copyright (c) 2014 Dmitriy Dmitriev. All rights reserved.
//

/*********        includes        *********/

#import <UIKit/UIKit.h>

/*********        interface for ILAppDelegate        *********/
/*!
 @class ILAppDelegate
 @discussion Application delegate.
*/

@interface ILAppDelegate : UIResponder <UIApplicationDelegate>
{
@private
    UIWindow* _window;
}

@property (retain, nonatomic) UIWindow *window;

@end
