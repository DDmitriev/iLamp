//
//  ILRotationView.h
//  iLamp
//
//  Created by Dmitry Dmitriev on 26.10.14.
//  Copyright (c) 2014 Dmitriy Dmitriev. All rights reserved.
//

/*********        includes        *********/

#import <UIKit/UIKit.h>
#import "ILRotationIndicatorView.h"

/*********        forward declarations, globals and typedefs        *********/

extern CGFloat const ILMaxXDistanceBetweenCircles;

/*********        interface for ILRotationView        *********/
/*!
 @class ILRotationView
 @discussion Rotation view.
*/

@interface ILRotationView : UIView
{
    ILRotationIndicatorView* _rotationIndicator;
    UILabel* _topTextLabel;
    UILabel* _topDescritptionLabel;
    UILabel* _bottomTextLabel;
}

@property (readonly, nonatomic) UILabel* topTextLabel;
@property (readonly, nonatomic) UILabel* topDescritptionLabel;
@property (readonly, nonatomic) ILRotationIndicatorView* rotationIndicator;
@property (readonly, nonatomic) UILabel* bottomTextLabel;

- (void)showEverything;
- (void)hideEverythingExceptIndicatorAnimated:(BOOL)animated;
- (void)setDescriptionHighlighted:(BOOL)highlighted animated:(BOOL)animated;

@end
