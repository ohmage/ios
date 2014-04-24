//
//  UIView+AutoLayoutHelpers.h
//  CPT2
//
//  Created by Charles Forkish on 4/10/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const kUIViewVerticalMargin;
extern CGFloat const kUIViewHorizontalMargin;

@interface UIView (AutoLayoutHelpers)

+ (CGFloat)heightForString:(NSAttributedString *)aString withWidth:(CGFloat)width;

- (void)constrainEqualVerticalSpacingBetweenElements:(NSArray *)layoutElements;
- (void)constrainEqualHorizontalSpacingBetweenChildren:(NSArray *)childViews;

- (void)constrainChildToDefaultInsets:(UIView *)childView;
- (void)constrainChildToDefaultHorizontalInsets:(UIView *)childView;
- (void)constrainChild:(UIView *)childView toHorizontalInsets:(UIEdgeInsets)insets;
- (void)constrainChildToDefaultVerticalInsets:(UIView *)childView;
- (void)constrainChild:(UIView *)childView toVerticalInsets:(UIEdgeInsets)insets;
- (void)constrainChildToEqualSize:(UIView *)childView;
- (void)constrainChild:(UIView *)childView toMargins:(UIEdgeInsets)margins;

- (void)constrainSize:(CGSize)aSize;
- (void)constrainPosition:(CGPoint)aPoint;
- (void)constrainEqualWidthAndHeight;

- (void)centerHorizontallyInView:(UIView *)view;
- (void)centerVerticallyInView:(UIView *)view;
- (void)constrainToTopInParentWithMargin:(CGFloat)margin;
- (void)constrainToBottomInParentWithMargin:(CGFloat)margin;
- (void)positionBelowView:(UIView *)view margin:(CGFloat)margin;

- (void)moveOriginToPoint:(CGPoint)point;
- (void)positionFrameBelowView:(UIView *)reference margin:(CGFloat)margin;
- (void)centerFrameHorizontallyInView:(UIView *)reference;
- (void)centerFrameVerticallyInView:(UIView *)reference;

@end
