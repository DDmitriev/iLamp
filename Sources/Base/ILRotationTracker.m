//
//  ILRotationTracker.h
//  iLamp
//
//  Created by Dmitriy Dmitriev on 29.10.13.
//  Copyright (c) 2013 Dmitriy Dmitriev. All rights reserved.
//

/*********        includes        *********/

#import "ILRotationTracker.h"
#import <CoreMotion/CoreMotion.h>

/*********        forward declarations, globals and typedefs        *********/

#define DEGREES_TO_RADIANS(degree)((degree) * M_PI/180.)

NSString* const ILDeviceBackBecameObservableNotificationName = @"ILDeviceBackObservableNotification";
NSString* const ILDeviceFrontBecameObservableNotificationName = @"ILDeviceFrontObservableNotification";
NSString* const ILAttitudeRollObservableAndChangedNotificationName = @"ILAttitudeRollObservableAndChanged";
NSString* const ILRotationDetectionDidStopNotificationName = @"ILRotationDetectionDidStop";

NSTimeInterval const ILMotionUpdateInterval =  0.1;

/*********        private interface for ILRotationTracker        *********/

@interface ILRotationTracker (Private)

- (void)_simulateRotation;
- (void)_handleRotationForRoll:(double)roll;

@end

/*********        implementation for ILRotationTracker        *********/

@implementation ILRotationTracker

- (id)init
{
    self = [super init];

    if (self != nil)
    {
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.deviceMotionUpdateInterval = ILMotionUpdateInterval;
    }

    return self;
}

- (void)dealloc
{
    [_motionManager release];
    [_refAttitude release];

    [super dealloc];
}

#pragma mark -
#pragma mark *** Public Interface ***
#pragma mark -

+ (ILRotationTracker*)sharedInstance
{
    static ILRotationTracker* sharedInstance= nil;
    static dispatch_once_t once_token = 0;
    dispatch_once(&once_token, ^{
        sharedInstance =  [[ILRotationTracker alloc] init];
    });
    return sharedInstance;
}

- (void)startTrackingFlip
{
#if TARGET_IPHONE_SIMULATOR
    _simulatedRoll = 0.;
    [self performSelector:@selector(_simulateRotation) withObject:nil afterDelay:2];
#else
    if ([_motionManager isDeviceMotionAvailable])
    {
        _started = YES;
        __block __typeof(&*self) weakSelf = self;
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion* motion, NSError* error) {
            if (error)
                return;

            if (weakSelf->_refAttitude == nil)
                weakSelf->_refAttitude = [motion.attitude copy];

            [motion.attitude multiplyByInverseOfAttitude:weakSelf->_refAttitude];

            [weakSelf _handleRotationForRoll:motion.attitude.roll];
        }];
    }
#endif
}

- (void)stopTrackingFlip
{
#if TARGET_IPHONE_SIMULATOR
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_simulateRotation) object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:ILRotationDetectionDidStopNotificationName object:nil];
#else
    if ([_motionManager isDeviceMotionAvailable])
    {
        _started = NO;
        [_motionManager stopDeviceMotionUpdates];

        [_refAttitude release];
        _refAttitude = nil;

        [[NSNotificationCenter defaultCenter] postNotificationName:ILRotationDetectionDidStopNotificationName object:nil];
    }
#endif
}

- (void)restartTrackingFlip
{
    [self stopTrackingFlip];
    [self startTrackingFlip];
}

- (BOOL)isStarted
{
    return _started;
}

#pragma mark -
#pragma mark *** Private Interface ***
#pragma mark -

- (void)_simulateRotation
{
    if (_simulatedRoll <= M_PI)
        _simulatedRoll += DEGREES_TO_RADIANS(0.5);
    else
        _simulatedRoll = - M_PI;

    [self _handleRotationForRoll:_simulatedRoll];

    [self performSelector:@selector(_simulateRotation) withObject:nil afterDelay:0.1];
}

- (void)_handleRotationForRoll:(double)roll
{
    double oneDegree = DEGREES_TO_RADIANS(1);

    BOOL deviceBackObservable = !(roll > -M_PI_2  && roll < M_PI_2);
    BOOL shouldStopSending = !(roll > - (M_PI_2 + oneDegree) && roll < (M_PI_2 + oneDegree));

    if (!shouldStopSending)
        [[NSNotificationCenter defaultCenter] postNotificationName:ILAttitudeRollObservableAndChangedNotificationName object:[NSNumber numberWithDouble:roll]];

    if (_currentlyBackObservable != deviceBackObservable)
    {
        if (deviceBackObservable)
            [[NSNotificationCenter defaultCenter] postNotificationName:ILDeviceBackBecameObservableNotificationName object:nil];
        else
            [[NSNotificationCenter defaultCenter] postNotificationName:ILDeviceFrontBecameObservableNotificationName object:nil];

        _currentlyBackObservable = deviceBackObservable;
    }
}

@end
