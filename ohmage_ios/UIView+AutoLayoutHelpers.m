//
//  UIView+AutoLayoutHelpers.m
//  CPT2
//
//  Created by Charles Forkish on 4/10/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "UIView+AutoLayoutHelpers.h"


CGFloat const kUIViewVerticalMargin = 15.0;
CGFloat const kUIViewHorizontalMargin = 15.0;
CGFloat const kUIViewSmallTextMargin = 4.0;

@implementation UIView (AutoLayoutHelpers)

- (UIView *)newVerticalSpacer
{
    UIView *spacer = [[UIView alloc] init];
    spacer.hidden = YES;
    spacer.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:spacer];
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|[spacer]|" options:0 metrics:nil
                          views:NSDictionaryOfVariableBindings(spacer)]];
    return spacer;
}

- (void)constrainEqualVerticalSpacingBetweenElements:(NSArray *)layoutElements
{
    if ([layoutElements count] < 2) return;
    
    id currentElement = layoutElements[0];
    id nextElement = layoutElements[1];
    UIView *topSpacer = [self newVerticalSpacer];
    
    [self addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:[currentElement][topSpacer(>=0)][nextElement]" options:0 metrics:nil
                               views:NSDictionaryOfVariableBindings(currentElement, topSpacer, nextElement)]];
    
    for (int i = 2; i < [layoutElements count]; i++) {
        currentElement = nextElement;
        nextElement = layoutElements[i];
        UIView *spacer = [self newVerticalSpacer];
        
        [self addConstraints:[NSLayoutConstraint
                              constraintsWithVisualFormat:@"V:[currentElement][spacer(==topSpacer)][nextElement]" options:0 metrics:nil
                              views:NSDictionaryOfVariableBindings(currentElement, spacer, nextElement, topSpacer)]];
    }
    
}

- (void)constrainEqualHorizontalSpacingBetweenChildren:(NSArray *)childViews
{
    
}


- (void)constrainChildrenToEqualWidths:(NSArray *)childViews
{
    
    UIView *firstView = [childViews firstObject];
    firstView.translatesAutoresizingMaskIntoConstraints = NO;
    
    for (int i = 1; i < [childViews count]; i++) {
        UIView *view = childViews[i];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraint: [NSLayoutConstraint constraintWithItem:firstView
                                                          attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
                                                             toItem:view attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0f constant:0.0f]];
    }
}

- (void)constrainChildrenToEqualHights:(NSArray *)childViews
{
    
    UIView *firstView = [childViews firstObject];
    firstView.translatesAutoresizingMaskIntoConstraints = NO;
    
    for (int i = 1; i < [childViews count]; i++) {
        UIView *view = childViews[i];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraint: [NSLayoutConstraint constraintWithItem:firstView
                                                          attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
                                                             toItem:view attribute:NSLayoutAttributeHeight
                                                         multiplier:1.0f constant:0.0f]];
    }
}

- (void)constrainChildrenToEqualSizes:(NSArray *)childViews
{
    [self constrainChildrenToEqualWidths:childViews];
    [self constrainChildrenToEqualHeights:childViews];
}


- (void)constrainChildToDefaultInsets:(UIView *)childView
{
    childView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|-[childView]-|" options:0 metrics:nil
                          views:NSDictionaryOfVariableBindings(childView)]];
    
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|-[childView]-|" options:0 metrics:nil
                          views:NSDictionaryOfVariableBindings(childView)]];
}

- (void)constrainChild:(UIView *)childView toHorizontalInsets:(UIEdgeInsets)insets
{
  childView.translatesAutoresizingMaskIntoConstraints = NO;
  
  [self addConstraints:[NSLayoutConstraint
                        constraintsWithVisualFormat:@"H:|-left-[childView]-right-|"
                        options:0
                        metrics:@{@"left" : @(insets.left), @"right" : @(insets.right)}
                        views:NSDictionaryOfVariableBindings(childView)]];
}

- (void)constrainChildToDefaultHorizontalInsets:(UIView *)childView
{
    childView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|-[childView]-|"
                          options:0
                          metrics:nil
                          views:NSDictionaryOfVariableBindings(childView)]];
}



- (void)constrainChild:(UIView *)childView toVerticalInsets:(UIEdgeInsets)insets
{
    childView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|-top-[childView]-bottom-|"
                          options:0
                          metrics:@{@"top" : @(insets.top), @"bottom" : @(insets.bottom)}
                          views:NSDictionaryOfVariableBindings(childView)]];
}

- (void)constrainChildToDefaultVerticalInsets:(UIView *)childView
{
    childView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|-[childView]-|" options:0 metrics:nil
                          views:NSDictionaryOfVariableBindings(childView)]];
}

- (void)constrainChildToEqualSize:(UIView *)childView
{
    childView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|[childView]|" options:0 metrics:nil
                          views:NSDictionaryOfVariableBindings(childView)]];
    
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|[childView]|" options:0 metrics:nil
                          views:NSDictionaryOfVariableBindings(childView)]];
}

- (void)constrainChild:(UIView *)childView toMargins:(UIEdgeInsets)margins
{
  childView.translatesAutoresizingMaskIntoConstraints = NO;
  
  [self addConstraints:[NSLayoutConstraint
                        constraintsWithVisualFormat:@"H:|-left-[childView]-right-|"
                        options:0
                        metrics:@{@"left" : @(margins.left), @"right" : @(margins.right)}
                        views:NSDictionaryOfVariableBindings(childView)]];
  
  [self addConstraints:[NSLayoutConstraint
                        constraintsWithVisualFormat:@"V:|-top-[childView]-bottom-|"
                        options:0
                        metrics:@{@"top" : @(margins.top), @"bottom" : @(margins.bottom)}
                        views:NSDictionaryOfVariableBindings(childView)]];
}

- (void)constrainSize:(CGSize)aSize
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSMutableArray *array = [NSMutableArray array];
    
    // Fix the width
    [array addObjectsFromArray:[NSLayoutConstraint
                                constraintsWithVisualFormat:@"H:[self(theWidth@750)]"
                                options:0 metrics:@{@"theWidth":@(aSize.width)}
                                views:NSDictionaryOfVariableBindings(self)]];
    
    // Fix the height
    [array addObjectsFromArray:[NSLayoutConstraint
                                constraintsWithVisualFormat:@"V:[self(theHeight@750)]"
                                options:0 metrics:@{@"theHeight":@(aSize.height)}
                                views:NSDictionaryOfVariableBindings(self)]];
    
    [self addConstraints:array];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, aSize.width, aSize.height);
}

- (void)constrainPosition:(CGPoint)aPoint
{
    if (!self.superview) return;
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    NSMutableArray *array = [NSMutableArray array];
    
    // X position
    [array addObject:[NSLayoutConstraint constraintWithItem:self
                                                  attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual
                                                     toItem:self.superview attribute:NSLayoutAttributeLeft
                                                 multiplier:1.0f constant:aPoint.x]];
    
    // Y position
    [array addObject:[NSLayoutConstraint constraintWithItem:self
                                                  attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
                                                     toItem:self.superview attribute:NSLayoutAttributeTop
                                                 multiplier:1.0f constant:aPoint.y]];
    
    [self.superview addConstraints:array];
    
    self.frame = CGRectMake(aPoint.x, aPoint.y, self.frame.size.width, self.frame.size.height);
}

- (void)constrainEqualWidthAndHeight
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:self
                                                      attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
                                                         toItem:self attribute:NSLayoutAttributeHeight
                                                     multiplier:1.0f constant:0.0f]];
}

- (void)centerHorizontallyInView:(UIView *)aView
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [aView addConstraint:[NSLayoutConstraint
                                   constraintWithItem:self attribute:NSLayoutAttributeCenterX
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:aView attribute:NSLayoutAttributeCenterX
                                   multiplier:1.0f constant:0.0f]];
    self.center = CGPointMake(aView.center.x, self.center.y);
}

- (void)centerVerticallyInView:(UIView *)aView
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [aView addConstraint:[NSLayoutConstraint
                         constraintWithItem:self attribute:NSLayoutAttributeCenterY
                         relatedBy:NSLayoutRelationEqual
                         toItem:aView attribute:NSLayoutAttributeCenterY
                         multiplier:1.0f constant:0.0f]];
    
    self.center = CGPointMake(self.center.x, aView.center.y);
}

- (void)centerInView:(UIView *)aView
{
    [self centerHorizontallyInView:aView];
    [self centerVerticallyInView:aView];
}

- (void)constrainToTopInParentWithMargin:(CGFloat)margin
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
  
    [self.superview addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|-margin-[self]" options:0
                          metrics:@{@"margin":@(margin)}
                          views:NSDictionaryOfVariableBindings(self)]];
}
- (void)constrainToBottomInParentWithMargin:(CGFloat)margin
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.superview addConstraints:[NSLayoutConstraint
                                    constraintsWithVisualFormat:@"V:[self]-margin-|" options:0
                                    metrics:@{@"margin":@(margin)}
                                    views:NSDictionaryOfVariableBindings(self)]];
}

- (void)positionBelowElement:(id)layoutElement margin:(CGFloat)margin
{
  self.translatesAutoresizingMaskIntoConstraints = NO;
  
  [self.superview addConstraints:[NSLayoutConstraint
                                  constraintsWithVisualFormat:@"V:[layoutElement]-margin-[self]" options:0
                                  metrics:@{@"margin":@(margin)}
                                  views:NSDictionaryOfVariableBindings(layoutElement, self)]];
}

- (void)positionBelowElementWithDefaultMargin:(id)layoutElement
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.superview addConstraints:[NSLayoutConstraint
                                    constraintsWithVisualFormat:@"V:[layoutElement]-[self]" options:0
                                    metrics:nil
                                    views:NSDictionaryOfVariableBindings(layoutElement, self)]];
}

- (void)positionAboveElementWithDefaultMargin:(id)layoutElement
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.superview addConstraints:[NSLayoutConstraint
                                    constraintsWithVisualFormat:@"V:[self]-[layoutElement]" options:0
                                    metrics:nil
                                    views:NSDictionaryOfVariableBindings(self, layoutElement)]];
}

/**
 *  moveOriginToPoint
 */
- (void)moveOriginToPoint:(CGPoint)point {
  CGRect frame = self.frame;
  frame.origin = point;
  
  self.frame = frame;
}

/**
 *  positionBelowView:margin
 */
- (void)positionFrameBelowView:(UIView *)reference margin:(CGFloat)margin {
  CGRect frame = self.frame;
  frame.origin.y = reference.frame.origin.y + reference.frame.size.height + margin;
  self.frame = frame;
}

/**
 *  centerHorizontallyInView
 */
- (void)centerFrameHorizontallyInView:(UIView *)reference {
  [self moveOriginToPoint:CGPointMake(ceil((reference.frame.size.width - self.frame.size.width) / 2), self.frame.origin.y)];
}

/**
 *  centerVerticallyInView
 */
- (void)centerFrameVerticallyInView:(UIView *)reference {
  [self moveOriginToPoint:CGPointMake(self.frame.origin.x, ceil((reference.frame.size.height - self.frame.size.height) / 2))];
}



+ (CGFloat)heightForString:(NSAttributedString *)aString withWidth:(CGFloat)width
{
    CGRect r = [aString boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                     context:nil];
    return r.size.height;
}

@end
