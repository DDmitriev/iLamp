//
//  ILRotationTracker.h
//  iLamp
//
//  Created by Dmitriy Dmitriev on 29.10.13.
//  Copyright (c) 2013 Dmitriy Dmitriev. All rights reserved.
//

/*********        includes        *********/

#import <Foundation/Foundation.h>

/*********        forward declarations, globals and typedefs        *********/

@class CMMotionManager;
@class CMAttitude;

extern NSString* const ILDeviceBackBecameObservableNotificationName;
extern NSString* const ILDeviceFrontBecameObservableNotificationName;
extern NSString* const ILAttitudeRollObservableAndChangedNotificationName;
extern NSString* const ILRotationDetectionDidStopNotificationName;

/*********        interface for ILRotationTracker        *********/
/*!
 @class ILRotationTracker
 @discussion Rotation view controller.
*/

@interface ILRotationTracker : NSObject
{
@private
    CMMotionManager* _motionManager;
    CMAttitude* _refAttitude;
    BOOL _currentlyBackObservable;
    BOOL _started;

    double _simulatedRoll;
}

+ (ILRotationTracker*)sharedInstance;

- (void)startTrackingFlip;
- (void)stopTrackingFlip;
- (void)restartTrackingFlip;
- (BOOL)isStarted;

@end
