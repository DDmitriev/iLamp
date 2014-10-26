//
//  ILRotationViewController.h
//  iLamp
//
//  Created by Dmitry Dmitriev on 25.10.14.
//  Copyright (c) 2014 Dmitriy Dmitriev. All rights reserved.
//

/*********        includes        *********/

#import <UIKit/UIKit.h>

/*********        forward declarations, globals and typedefs        *********/

@class AVCaptureDevice;

/*********        interface for ILRotationViewController        *********/
/*!
 @class ILRotationViewController
 @discussion Rotation view controller.
 */

@interface ILRotationViewController : UIViewController
{
@private
    AVCaptureDevice* _captureDevice;
}

@end
