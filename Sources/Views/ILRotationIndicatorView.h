//
//  ILRotationIndicatorView.h
//  iLamp
//
//  Created by Dmitriy Dmitriev on 24.11.13.
//  Copyright (c) 2013 Dmitriy Dmitriev. All rights reserved.
//

/*********        includes        *********/

#import <UIKit/UIKit.h>

/*********        forward declarations, globals and typedefs        *********/

@class ILRadialLinesLayer;

/*********        interface for ILRotationIndicatorView        *********/
/*!
 @class ILRotationIndicatorView
 @discussion Rotation indicator view.
*/

@interface ILRotationIndicatorView : UIView
{
@private
    UIView* _backgroundView;

    CALayer* _rightCircleLayer;
    CALayer* _leftCircleLayer;
    CALayer* _topCircleLayer;
    CALayer* _topCircleBackgroundLayer;
    ILRadialLinesLayer* _linesLayer;
    CALayer* _topCircleForegroundLayer;
    CALayer* _topCircleOffsetLayer;

    UILabel* _degreeLabel;
}

- (void)setDistanceBetweenCircleCenters:(CGFloat)distanceBetweenCircleCenters withTitleText:(NSString*)text;
- (void)startWaitingAnimations;

@end
