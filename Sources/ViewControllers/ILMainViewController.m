//
//  ILMainViewController.h
//  iLamp
//
//  Created by Dmitry Dmitriev on 25.10.14.
//  Copyright (c) 2014 Dmitriy Dmitriev. All rights reserved.
//

/*********        includes        *********/

#import "ILMainViewController.h"
#import "ILFullscreenScrollView.h"
#import "ILRotationViewController.h"

/*********        implementation for ILMainViewController        *********/

@implementation ILMainViewController

- (void)dealloc
{
    [_viewControllers release];

    [super dealloc];
}

- (void)loadView
{
    ILFullscreenScrollView* view = [[ILFullscreenScrollView alloc] initWithFrame:CGRectZero];
    self.view = view;
    [view release];
}

#pragma mark -
#pragma mark *** UIViewController methods ***
#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];

    ILFullscreenScrollView* view = (ILFullscreenScrollView*)self.view;

    _viewControllers = [NSArray arrayWithObject:[[[ILRotationViewController alloc] init] autorelease]];
    view.swipeItems = [_viewControllers valueForKey:@"view"];
}

@end
