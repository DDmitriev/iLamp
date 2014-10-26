//
//  ILRotationViewController.m
//  iLamp
//
//  Created by Dmitry Dmitriev on 25.10.14.
//  Copyright (c) 2014 Dmitriy Dmitriev. All rights reserved.
//

/*********        includes        *********/

#import "ILRotationViewController.h"
#import "ILRotationView.h"
#import <AVFoundation/AVFoundation.h>
#import "ILRotationTracker.h"
#import "ILBase.h"

/*********        forward declarations, globals and typedefs        *********/

float const ILLightLevel = 0.6;
NSInteger const ILMaxDegreeBeforeHighlight = 20;

/*********        private interface for ILRotationViewController        *********/

@interface ILRotationViewController (Private)

- (void)_setLightOn:(BOOL)on;

- (void)_didChangeRoll:(NSNotification*)notification;
- (void)_didStopRotationDetection:(NSNotification*)notification;
- (void)_didFlipToFront:(NSNotification*)notification;
- (void)_didFlipToBack:(NSNotification*)notification;

@end

/*********        implementation for ILRotationViewController        *********/

@implementation ILRotationViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [_captureDevice release];

    [super dealloc];
}

#pragma mark -
#pragma mark *** UIViewController methods ***
#pragma mark -

- (void)loadView
{
    ILRotationView* view = [[ILRotationView alloc] initWithFrame:CGRectZero];
    self.view = view;
    [view release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _captureDevice = [[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] retain];

    NSString* deviceName = [[[[UIDevice currentDevice] name] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] firstObject];

    ILRotationView* view = (ILRotationView*)self.view;
    view.topTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"RotationIndicatorTitle", @""), deviceName];
    view.topDescritptionLabel.text = NSLocalizedString(@"RotationIndicatorDescription", @"");
    view.bottomTextLabel.text = NSLocalizedString(@"RotationIndicatorHint", @"");

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_didChangeRoll:) name:ILAttitudeRollObservableAndChangedNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_didStopRotationDetection:) name:ILRotationDetectionDidStopNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_didFlipToFront:) name:ILDeviceFrontBecameObservableNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_didFlipToBack:) name:ILDeviceBackBecameObservableNotificationName object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    ILRotationView* view = (ILRotationView*)self.view;
    [view hideEverythingExceptIndicatorAnimated:YES];
    [view.rotationIndicator startWaitingAnimations];

    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self becomeFirstResponder];
}

#pragma mark -
#pragma mark *** UIResponder methods ***
#pragma mark -

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent*)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        [[ILRotationTracker sharedInstance] restartTrackingFlip];

        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

#pragma mark -
#pragma mark *** Private Interface ***
#pragma mark -

- (void)_setLightOn:(BOOL)on
{
    NSError* error = nil;
    [_captureDevice lockForConfiguration:&error];

    if (error == nil)
    {
        if (on)
            [_captureDevice setTorchModeOnWithLevel:ILLightLevel error:NULL];
        else
            [_captureDevice setTorchMode:AVCaptureTorchModeOff];

        [_captureDevice unlockForConfiguration];
    }
}

#pragma mark -
#pragma mark *** Notifications ***
#pragma mark -

- (void)_didChangeRoll:(NSNotification*)notification
{
    ILRotationView* view = (ILRotationView*)self.view;

    NSNumber* roll = [notification object];
    double rollValue = fabsf([roll doubleValue]);

    CGFloat distance = ILMaxXDistanceBetweenCircles - (rollValue / M_PI_2 * ILMaxXDistanceBetweenCircles);
    NSInteger degree = (rollValue) * (180. / M_PI);

    if (distance < 0.)
        distance = 0.;
    else
        [view showEverything];

    [view setDescriptionHighlighted:(degree > ILMaxDegreeBeforeHighlight) animated:YES];
    [view.rotationIndicator setDistanceBetweenCircleCenters:distance withTitleText:[NSString stringWithFormat:@"%ld\u00B0", (long)degree]];
}

- (void)_didStopRotationDetection:(NSNotification*)notification
{
    ILRotationView* view = (ILRotationView*)self.view;

    view.topDescritptionLabel.textColor = [ILBase darkDescriptionTextColor];
    [view hideEverythingExceptIndicatorAnimated:YES];
    [view.rotationIndicator startWaitingAnimations];

    [self _setLightOn:NO];
}

- (void)_didFlipToFront:(NSNotification*)notification
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];

    [self _setLightOn:NO];
}

- (void)_didFlipToBack:(NSNotification*)notification
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];

    ILRotationView* view = (ILRotationView*)self.view;
    [view hideEverythingExceptIndicatorAnimated:YES];

    [self _setLightOn:YES];
}

@end
