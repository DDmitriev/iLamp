//
//  ILRotationView.m
//  iLamp
//
//  Created by Dmitry Dmitriev on 26.10.14.
//  Copyright (c) 2014 Dmitriy Dmitriev. All rights reserved.
//

/*********        includes        *********/

#import "ILRotationView.h"
#import "ILRotationIndicatorView.h"
#import "ILBase.h"

/*********        forward declarations, globals and typedefs        *********/

CGFloat const ILMaxXDistanceBetweenCircles = 120.;
CGFloat const ILIndicatorHeight = 206.;

CGFloat const ILBottomYInset = 25.;
CGFloat const ILSideXInset = 28.;

/*********        implementation for ILRotationView        *********/

@implementation ILRotationView

@synthesize rotationIndicator = _rotationIndicator;
@synthesize topTextLabel = _topTextLabel;
@synthesize topDescritptionLabel = _topDescritptionLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self != nil)
    {
        self.backgroundColor = [UIColor clearColor];

        _topTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _topTextLabel.backgroundColor = [UIColor clearColor];
        _topTextLabel.textColor = [ILBase darkTextColor];
        _topTextLabel.font = [ILBase thinFontOfSize:17.];
        _topTextLabel.numberOfLines = 1;
        _topTextLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_topTextLabel];

        _topDescritptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _topDescritptionLabel.backgroundColor = [UIColor clearColor];
        _topDescritptionLabel.textColor = [ILBase darkDescriptionTextColor];
        _topDescritptionLabel.font = [ILBase thinFontOfSize:17.];
        _topDescritptionLabel.numberOfLines = 1;
        _topDescritptionLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_topDescritptionLabel];

        _rotationIndicator = [[ILRotationIndicatorView alloc] initWithFrame:CGRectZero];
        [self addSubview:_rotationIndicator];

        _bottomTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _bottomTextLabel.backgroundColor = [UIColor clearColor];
        _bottomTextLabel.textColor = [ILBase darkDescriptionTextColor];
        _bottomTextLabel.font = [ILBase thinFontOfSize:17.];
        _bottomTextLabel.numberOfLines = 0;
        _bottomTextLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_bottomTextLabel];
    }

    return self;
}

- (void)dealloc
{
    [_topTextLabel release];
    [_topDescritptionLabel release];
    [_rotationIndicator release];
    [_bottomTextLabel release];

    [super dealloc];
}

#pragma mark -
#pragma mark *** Public Interface ***
#pragma mark -

- (void)showEverything
{
    _topTextLabel.hidden = NO;
    _topDescritptionLabel.hidden = NO;
    _rotationIndicator.hidden = NO;
    _bottomTextLabel.hidden = NO;
}

- (void)hideEverythingExceptIndicatorAnimated:(BOOL)animated
{
    NSTimeInterval duration = animated ? 0.25 : 0;

    [UIView animateWithDuration:duration animations:^{
        _topTextLabel.hidden = YES;
        _topDescritptionLabel.hidden = YES;
        _bottomTextLabel.hidden = YES;
    }];
}

- (void)setDescriptionHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    NSTimeInterval duration = animated ? 0.25 : 0;

    if (highlighted)
    {
        if (_topDescritptionLabel.textColor == [ILBase darkDescriptionTextColor])
        {
            [UIView transitionWithView:_topDescritptionLabel duration:duration options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                _topDescritptionLabel.textColor = [ILBase warningTextColor];
            } completion:nil];
        }
        else
            _topDescritptionLabel.textColor = [ILBase warningTextColor];
    }
    else
    {
        if (_topDescritptionLabel.textColor == [ILBase warningTextColor])
        {
            [UIView transitionWithView:_topDescritptionLabel duration:duration options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                _topDescritptionLabel.textColor = [ILBase darkDescriptionTextColor];
            } completion:nil];
        }
        else
            _topDescritptionLabel.textColor = [ILBase darkDescriptionTextColor];
    }
}

#pragma mark -
#pragma mark *** UIView methods ***
#pragma mark -

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat verticalOffset = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
    _rotationIndicator.frame = CGRectMake(0., (rintf(CGRectGetHeight(self.bounds) / 2) - rintf(ILIndicatorHeight / 2) - verticalOffset), CGRectGetWidth(self.bounds), ILIndicatorHeight);

    CGSize maxTextSize = CGSizeMake((CGRectGetWidth(self.bounds) - (ILSideXInset * 2)), CGFLOAT_MAX);
    CGSize textSize = CGSizeZero;

    textSize = [_topTextLabel sizeThatFits:maxTextSize];
    _topTextLabel.frame = CGRectMake(ILSideXInset, ((rintf((CGRectGetMinY(self.bounds) + CGRectGetMinY(_rotationIndicator.frame)) / 2) - textSize.height) + verticalOffset), maxTextSize.width, textSize.height);

    textSize = [_topDescritptionLabel sizeThatFits:maxTextSize];
    _topDescritptionLabel.frame = CGRectMake(ILSideXInset, (CGRectGetMaxY(_topTextLabel.frame)), maxTextSize.width, textSize.height);

    textSize = [_bottomTextLabel sizeThatFits:maxTextSize];
    _bottomTextLabel.frame = CGRectMake(ILSideXInset, CGRectGetMaxY(self.bounds) - textSize.height - ILBottomYInset, maxTextSize.width, textSize.height);
}

@end
