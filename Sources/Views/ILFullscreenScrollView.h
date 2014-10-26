//
//  ILFullscreenScrollView.h
//  iLamp
//
//  Created by Dmitry Dmitriev on 25.10.14.
//  Copyright (c) 2014 Dmitriy Dmitriev. All rights reserved.
//

/*********        includes        *********/

#import <UIKit/UIKit.h>

/*********        interface for ILFullscreenScrollView        *********/
/*!
 @class ILFullscreenScrollView
 @discussion Fullscreen scroll view.
*/

@interface ILFullscreenScrollView : UIView
{
@private
    NSArray* _swipeItems;
    UIScrollView* _scrollView;
}

@property (retain, nonatomic) NSArray* swipeItems;
@property (readonly, nonatomic) UIScrollView* scrollView;

@end
