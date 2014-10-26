//
//  ILFullscreenScrollView.m
//  iLamp
//
//  Created by Dmitry Dmitriev on 25.10.14.
//  Copyright (c) 2014 Dmitriy Dmitriev. All rights reserved.
//

/*********        includes        *********/

#import "ILFullscreenScrollView.h"

/*********        implementation for ILFullscreenScrollView        *********/

@implementation ILFullscreenScrollView

@synthesize swipeItems = _swipeItems;
@synthesize scrollView = _scrollView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self != nil)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.pagingEnabled = YES;
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.scrollsToTop = NO;
        [self addSubview:_scrollView];
    }

    return self;
}

- (void)dealloc
{
    [_swipeItems release];
    [_scrollView release];

    [super dealloc];
}

#pragma mark -
#pragma mark *** UIView methods ***
#pragma mark -

- (void)layoutSubviews
{
    [super layoutSubviews];

    _scrollView.frame = self.bounds;
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame), (CGRectGetHeight(_scrollView.frame) * [_swipeItems count]));

    if (_swipeItems != nil)
    {
        for (NSInteger index = 0, count = [_swipeItems count]; index < count; index++)
        {
            CGRect pageFrame = _scrollView.frame;
            pageFrame.origin.y = index * CGRectGetHeight(_scrollView.frame);

            UIView* myView = [_swipeItems objectAtIndex:index];
            myView.frame = pageFrame;
        }
    }
}

#pragma mark -
#pragma mark *** Public Interface ***
#pragma mark -

- (void)setSwipeItems:(NSArray*)swipeItems
{
    for (UIView* view in _swipeItems)
    {
        [view removeFromSuperview];
    }

    [_swipeItems release];
    _swipeItems = [swipeItems retain];

    for (UIView* view in _swipeItems)
    {
        [_scrollView addSubview:view];
    }

    [self setNeedsLayout];
}

@end
