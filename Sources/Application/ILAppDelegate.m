//
//  ILAppDelegate.h
//  iLamp
//
//  Created by Dmitry Dmitriev on 25.10.14.
//  Copyright (c) 2014 Dmitriy Dmitriev. All rights reserved.
//

/*********        includes        *********/

#import "ILAppDelegate.h"
#import "ILMainViewController.h"
#import "ILRotationTracker.h"

/*********        implementation for ILAppDelegate        *********/

@implementation ILAppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [_window release];

    [super dealloc];
}

#pragma mark -
#pragma mark *** UIApplicationDelegate interface ***
#pragma mark -

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    application.applicationSupportsShakeToEdit = YES;

    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];

    ILMainViewController* mainController = [[[ILMainViewController alloc] init] autorelease];
    mainController.view.frame = _window.bounds;
    _window.rootViewController = mainController;

    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication*)application
{
    [[ILRotationTracker sharedInstance] restartTrackingFlip];
}

@end
