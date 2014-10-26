//
//  ILRotationIndicatorView.m
//  iLamp
//
//  Created by Dmitriy Dmitriev on 24.11.13.
//  Copyright (c) 2013 Dmitriy Dmitriev. All rights reserved.
//

/*********        includes        *********/

#import "ILRotationIndicatorView.h"
#import "ILRadialLinesLayer.h"
#import "ILBase.h"

/*********        forward declarations, globals and typedefs        *********/

CGFloat const ILCircleRadius = 80.;

/*********        private interface for ILRotationIndicatorView        *********/

@interface ILRotationIndicatorView (Private)

- (void)_applyHighlightedAppearence;
- (void)_applyNormalAppearence;
- (void)_applyWatingAnimation;
- (void)_stopWatingAnimation;
- (void)_applyRotationAnimation;
- (void)_stopRotationAnimation;
- (CGRect)_leftRectForDistance:(CGFloat)distance;
- (CGRect)_rightRectForDistance:(CGFloat)distance;
- (CGRect)_topRectForLeftFrame:(CGRect)leftFrame andRightFrame:(CGRect)rightFrame;

@end

/*********        implementation for ILRotationIndicatorView        *********/

@implementation ILRotationIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self != nil)
    {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;

        _backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        _backgroundView.backgroundColor = [UIColor clearColor];
        _backgroundView.clipsToBounds = YES;
        _backgroundView.layer.masksToBounds = YES;
        [self addSubview:_backgroundView];

        _topCircleOffsetLayer = [[CALayer layer] retain];
        _topCircleOffsetLayer.masksToBounds = YES;
        _topCircleOffsetLayer.backgroundColor = [ILBase lightBackgroundColor].CGColor;
        [_backgroundView.layer addSublayer:_topCircleOffsetLayer];

        _rightCircleLayer = [[CALayer layer] retain];
        _rightCircleLayer.masksToBounds = YES;
        _rightCircleLayer.backgroundColor = [UIColor clearColor].CGColor;
        _rightCircleLayer.borderColor = [ILBase lightColorForDepth2].CGColor;
        _rightCircleLayer.borderWidth = 0.5;
        [_backgroundView.layer addSublayer:_rightCircleLayer];

        _leftCircleLayer = [[CALayer layer] retain];
        _leftCircleLayer.masksToBounds = YES;
        _leftCircleLayer.backgroundColor = [UIColor clearColor].CGColor;
        _leftCircleLayer.borderColor = [ILBase lightColorForDepth2].CGColor;
        _leftCircleLayer.borderWidth = 0.5;
        [_backgroundView.layer addSublayer:_leftCircleLayer];

        _topCircleLayer = [[CALayer layer] retain];
        _topCircleLayer.masksToBounds = YES;
        _topCircleLayer.backgroundColor = [ILBase darkBackgroundColor].CGColor;
        [_backgroundView.layer addSublayer:_topCircleLayer];

        _topCircleBackgroundLayer = [[CALayer layer] retain];
        _topCircleBackgroundLayer.masksToBounds = YES;
        _topCircleBackgroundLayer.backgroundColor = [ILBase darkBackgroundColor].CGColor;
        [_backgroundView.layer addSublayer:_topCircleBackgroundLayer];

        _linesLayer = [[ILRadialLinesLayer layer] retain];
        _linesLayer.masksToBounds = YES;
        _linesLayer.backgroundColor = [ILBase darkBackgroundColor].CGColor;
        _linesLayer.angleInDegrees = 15.;
        _linesLayer.lineColor = [ILBase lightColorForDepth2];
        _linesLayer.mask = _topCircleBackgroundLayer;
        [_backgroundView.layer addSublayer:_linesLayer];

        _topCircleForegroundLayer = [[CALayer layer] retain];
        _topCircleForegroundLayer.masksToBounds = YES;
        _topCircleForegroundLayer.backgroundColor = [ILBase darkBackgroundColor].CGColor;
        [_backgroundView.layer addSublayer:_topCircleForegroundLayer];

        _degreeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _degreeLabel.font = [ILBase thinFontOfSize:22.];
        _degreeLabel.textColor = [ILBase lightBackgroundColor];
        _degreeLabel.textAlignment = NSTextAlignmentCenter;
        _degreeLabel.backgroundColor = [UIColor clearColor];
        _degreeLabel.hidden = YES;
        [self addSubview:_degreeLabel];
    }

    return self;
}

- (void)dealloc
{
    [_backgroundView release];
    [_rightCircleLayer release];
    [_leftCircleLayer release];
    [_topCircleLayer release];
    [_topCircleBackgroundLayer release];
    [_linesLayer release];
    [_topCircleForegroundLayer release];
    [_degreeLabel release];

    [super dealloc];
}

#pragma mark -
#pragma mark *** UIView methods ***
#pragma mark -

- (void)layoutSubviews
{
    [super layoutSubviews];

    _backgroundView.frame = self.bounds;
    CGFloat centerX = CGRectGetMidX(self.bounds);
    CGFloat centerY = CGRectGetMidY(self.bounds);

    _topCircleLayer.frame = CGRectMake(centerX - ILCircleRadius, centerY - ILCircleRadius, (ILCircleRadius * 2), (ILCircleRadius * 2));
    _topCircleLayer.cornerRadius = CGRectGetHeight(_topCircleLayer.frame) / 2;

    _topCircleOffsetLayer.frame = CGRectInset(_topCircleLayer.frame, -8., -8.);
    _topCircleOffsetLayer.cornerRadius = CGRectGetHeight(_topCircleOffsetLayer.frame) / 2;

    _topCircleBackgroundLayer.frame = CGRectInset(_topCircleLayer.frame, 5., 5.);
    _topCircleBackgroundLayer.cornerRadius = CGRectGetHeight(_topCircleBackgroundLayer.frame) / 2;

    _topCircleForegroundLayer.frame = CGRectInset(_topCircleLayer.frame, 12., 12.);
    _topCircleForegroundLayer.cornerRadius = CGRectGetHeight(_topCircleForegroundLayer.frame) / 2;

    _leftCircleLayer.frame = CGRectInset(_topCircleLayer.frame, 20., 20.);
    _leftCircleLayer.cornerRadius = CGRectGetHeight(_leftCircleLayer.frame) / 2;

    _rightCircleLayer.frame = CGRectInset(_topCircleLayer.frame, 20., 20.);
    _rightCircleLayer.cornerRadius = CGRectGetHeight(_rightCircleLayer.frame) / 2;

    _linesLayer.frame = self.bounds;

    // little optimization to avoid frequent layout recalculations
    CGSize size = [@"90°" sizeWithAttributes:[NSDictionary dictionaryWithObject:_degreeLabel.font forKey:NSFontAttributeName]];

    _degreeLabel.frame = CGRectMake(0., 0., size.width, size.height);
    _degreeLabel.center = _backgroundView.center;
}

#pragma mark -
#pragma mark *** Public Interface ***
#pragma mark -

- (void)setDistanceBetweenCircleCenters:(CGFloat)distanceBetweenCircleCenters withTitleText:(NSString*)text;
{
    if ([_topCircleLayer.animationKeys containsObject:@"pulsation"])
    {
        [self _stopWatingAnimation];
    }

    if (![_topCircleLayer.animationKeys containsObject:@"pulsation"] && !([_linesLayer.animationKeys containsObject:@"rotationFadeIn"] || [_linesLayer.animationKeys containsObject:@"rotation"]) )
    {
        [self _applyRotationAnimation];
    }

    _degreeLabel.text = text;

    if (distanceBetweenCircleCenters == 0.)
    {
        _degreeLabel.hidden = YES;
        [self _applyHighlightedAppearence];
    }
    else
    {
        _degreeLabel.hidden = NO;
        [self _applyNormalAppearence];
    }

    _leftCircleLayer.frame = [self _leftRectForDistance:distanceBetweenCircleCenters];
    _leftCircleLayer.cornerRadius = CGRectGetHeight(_leftCircleLayer.frame) / 2;

    _rightCircleLayer.frame = [self _rightRectForDistance:distanceBetweenCircleCenters];
    _rightCircleLayer.cornerRadius = CGRectGetHeight(_leftCircleLayer.frame) / 2;

    _topCircleLayer.frame = [self _topRectForLeftFrame:_leftCircleLayer.frame andRightFrame:_rightCircleLayer.frame];
    _topCircleLayer.cornerRadius = CGRectGetHeight(_topCircleLayer.frame) / 2;

    _topCircleOffsetLayer.frame = CGRectInset(_topCircleLayer.frame, -8., -8.);
    _topCircleOffsetLayer.cornerRadius = CGRectGetHeight(_topCircleOffsetLayer.frame) / 2;

    _topCircleBackgroundLayer.frame = CGRectInset(_topCircleLayer.frame, 5., 5.);
    _topCircleBackgroundLayer.cornerRadius = CGRectGetHeight(_topCircleBackgroundLayer.frame) / 2;

    _topCircleForegroundLayer.frame = CGRectInset(_topCircleLayer.frame, 12., 12.);
    _topCircleForegroundLayer.cornerRadius = CGRectGetHeight(_topCircleForegroundLayer.frame) / 2;
}

- (void)startWaitingAnimations
{
    if (![_topCircleLayer.animationKeys containsObject:@"pulsation"])
    {
        _degreeLabel.hidden = YES;

        [self _applyNormalAppearence];
        [self _stopRotationAnimation];
        [self _applyWatingAnimation];

        [self setNeedsLayout];
    }
}

#pragma mark -
#pragma mark *** Private Interface ***
#pragma mark -

- (void)_applyHighlightedAppearence
{
    _topCircleLayer.backgroundColor = [ILBase warningTextColor].CGColor;
    _topCircleBackgroundLayer.backgroundColor = [ILBase warningTextColor].CGColor;
    _topCircleForegroundLayer.backgroundColor = [ILBase warningTextColor].CGColor;
    _linesLayer.backgroundColor = [ILBase warningTextColor].CGColor;
    _linesLayer.lineColor = [ILBase lightBackgroundColor];
    [_linesLayer setNeedsDisplay];
}

- (void)_applyNormalAppearence
{
    _topCircleLayer.backgroundColor = [ILBase darkBackgroundColor].CGColor;
    _topCircleBackgroundLayer.backgroundColor = [ILBase darkBackgroundColor].CGColor;
    _topCircleForegroundLayer.backgroundColor = [ILBase darkBackgroundColor].CGColor;
    _linesLayer.backgroundColor = [ILBase darkBackgroundColor].CGColor;
    _linesLayer.lineColor = [ILBase lightColorForDepth2];
    [_linesLayer setNeedsDisplay];
}

- (void)_applyWatingAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)];
    animation.duration= 0.4;
    animation.repeatCount = HUGE_VALF;
    animation.autoreverses = YES;
    animation.fillMode = kCAFillModeForwards;
    [_topCircleForegroundLayer addAnimation:animation forKey:@"pulsation"];
    [_topCircleLayer addAnimation:animation forKey:@"pulsation"];
    [_topCircleBackgroundLayer addAnimation:animation forKey:@"pulsation"];
}

- (void)_stopWatingAnimation
{
    [_topCircleForegroundLayer removeAnimationForKey:@"pulsation"];
    [_topCircleLayer removeAnimationForKey:@"pulsation"];
    [_topCircleBackgroundLayer removeAnimationForKey:@"pulsation"];
}

- (void)_applyRotationAnimation
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0.];
    rotationAnimation.toValue = [NSNumber numberWithFloat:((45. * M_PI) / 180.)];
    rotationAnimation.duration = 0.75;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotationAnimation.delegate = self;
    [_linesLayer addAnimation:rotationAnimation forKey:@"rotationFadeIn"];
}

- (void)_stopRotationAnimation
{
    [_linesLayer removeAnimationForKey:@"rotationFadeIn"];
    [_linesLayer removeAnimationForKey:@"rotation"];
}

- (CGRect)_leftRectForDistance:(CGFloat)distance
{
    CGFloat centerX = CGRectGetMidX(self.bounds);
    CGFloat centerY = CGRectGetMidY(self.bounds);

    CGRect rect = CGRectMake(((centerX - ILCircleRadius) - (distance / 2)), (centerY - ILCircleRadius), (ILCircleRadius * 2), (ILCircleRadius * 2));
    return rect;
}

- (CGRect)_rightRectForDistance:(CGFloat)distance
{
    CGFloat centerX = CGRectGetMidX(self.bounds);
    CGFloat centerY = CGRectGetMidY(self.bounds);

    CGRect rect = CGRectMake(((centerX - ILCircleRadius) + (distance / 2)), (centerY - ILCircleRadius), (ILCircleRadius * 2), (ILCircleRadius * 2));

    return rect;
}

- (CGRect)_topRectForLeftFrame:(CGRect)leftFrame andRightFrame:(CGRect)rightFrame
{
    CGFloat centerX = CGRectGetMidX(self.bounds);
    CGFloat centerY = CGRectGetMidY(self.bounds);

    CGPoint c1Center = CGPointMake(CGRectGetMidX(leftFrame), CGRectGetMidY(leftFrame));
    CGPoint c2Center = CGPointMake(CGRectGetMidX(rightFrame), CGRectGetMidY(rightFrame));

    CGFloat d = hypotf(c1Center.x - c2Center.x, c1Center.y - c2Center.y);
    CGFloat c1r = CGRectGetHeight(leftFrame) / 2;
    CGFloat c2r = CGRectGetHeight(rightFrame) / 2;

    BOOL fullOverlay = NO;

    // Can't find the original author of this circle intersection algorythm

    CGFloat n = c1r - c2r;

    if (n < 0)
        n = n * -1;

    //Circle are contained within each other
    if (d < n)
        fullOverlay = YES;

    //Circles are the same
    if ((d == 0) && (c1r == c2r))
        fullOverlay = YES;

    //Solve for a
    CGFloat a = ((c1r * c1r) - (c2r * c2r) + (d * d)) / (2 * d);

    //Solve for h
    CGFloat h = sqrt((c1r * c1r) - (a * a));

    //Calculate point p, where the line through the circle intersection points crosses the line between the circle centers.
    CGPoint p = CGPointZero;

    p.x = c1Center.x + ((a / d) * (c2Center.x - c1Center.x));
    p.y = c2Center.y + ((a / d) * (c2Center.y - c1Center.y));

    CGRect overlayEllipseRect = CGRectZero;

    if (fullOverlay)
        overlayEllipseRect = CGRectMake((centerX - ILCircleRadius), (centerY - ILCircleRadius), (ILCircleRadius * 2), (ILCircleRadius * 2));
    else
    {
        CGPoint sol1 = CGPointZero;
        CGPoint sol2 = CGPointZero;

        sol1.x = roundf(p.x + (h / d) * (c2Center.y - c1Center.y));
        sol1.y = roundf(p.y - (h / d) * (c2Center.x - c1Center.x));

        sol2.x = roundf(p.x - (h / d) * (c2Center.y - c1Center.y));
        sol2.y = roundf(p.y + (h / d) * (c2Center.x - c1Center.x));

        CGFloat dSol = roundf(hypotf(sol1.x - sol2.x, sol1.y - sol2.y));
        CGFloat dSolHalf = roundf(dSol / 2);

        overlayEllipseRect = CGRectMake((centerX - dSolHalf), sol1.y, dSol, dSol);
    }

    return overlayEllipseRect;
}

#pragma mark -
#pragma mark *** CAAnimationDelegate interface ***
#pragma mark -

- (void)animationDidStop:(CAAnimation*)stoppedAnimation finished:(BOOL)flag
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0.];
    rotationAnimation.toValue = [NSNumber numberWithFloat:((360. * M_PI) / 180.)];
    rotationAnimation.duration = 6.;
    rotationAnimation.repeatCount = HUGE_VALF;
    [_linesLayer addAnimation:rotationAnimation forKey:@"rotation"];
}

@end
