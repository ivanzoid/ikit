//
//  UIView+Dimensions.h
//  OwlCity
//
//  Created by Ivan on 10.05.11.
//  Copyright 2011 Al Digit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Dimensions)

@property (nonatomic) CGFloat Width;
@property (nonatomic) CGFloat Height;
@property (nonatomic) CGFloat X;
@property (nonatomic) CGFloat Y;
@property (nonatomic) CGFloat RightX;
@property (nonatomic) CGFloat BottomY;
@property (nonatomic) CGFloat CenterX;
@property (nonatomic) CGFloat CenterY;
@property (nonatomic) CGPoint CenterInBounds;
@property (nonatomic) CGSize Size;

@end
