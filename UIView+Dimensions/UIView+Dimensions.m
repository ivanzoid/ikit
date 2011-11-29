//
//  UIView+Dimensions.m
//  OwlCity
//
//  Created by Ivan on 10.05.11.
//  Copyright 2011 Al Digit. All rights reserved.
//

#import "UIView+Dimensions.h"

@implementation UIView (Dimensions)

- (CGFloat) Width
{
	return self.bounds.size.width;
}

- (void) setWidth:(CGFloat)width
{
	CGRect frame = self.frame;
	frame.size.width = width;
	self.frame = frame;
}

- (CGFloat) Height
{
	return self.bounds.size.height;
}

- (void) setHeight:(CGFloat)height
{
	CGRect frame = self.frame;
	frame.size.height = height;
	self.frame = frame;
}

- (CGFloat) X
{
	return self.frame.origin.x;
}

- (void) setX:(CGFloat)x
{
	CGRect frame = self.frame;
	frame.origin.x = x;
	self.frame = frame;
}

- (CGFloat) Y
{
	return self.frame.origin.y;
}

- (void) setY:(CGFloat)y
{
	CGRect frame = self.frame;
	frame.origin.y = y;
	self.frame = frame;
}

- (CGFloat) RightX
{
	return self.X + self.Width;
}

- (void) setRightX:(CGFloat)rightX
{
	self.X = rightX - self.Width;
}

- (CGFloat) BottomY
{
	return self.Y + self.Height;
}

- (void) setBottomY:(CGFloat)bottomY
{
	self.Y = bottomY - self.Height;
}

- (CGFloat) CenterX
{
	return self.center.x;
}

- (void) setCenterX:(CGFloat)centerX
{
	CGPoint center = self.center;
	center.x = centerX;
	self.center = center;
}

- (CGFloat) CenterY
{
	return self.center.y;
}

- (void) setCenterY:(CGFloat)centerY
{
	CGPoint center = self.center;
	center.y = centerY;
	self.center = center;
}

- (CGPoint) CenterInBounds
{
	return CGPointMake(self.Width / 2, self.Height / 2);
}

- (void) setCenterInBounds:(CGPoint)centerInBounds
{
	self.center = CGPointMake(self.frame.origin.x + centerInBounds.x, self.frame.origin.y + centerInBounds.y);
}

- (void) setSize:(CGSize)size
{
	CGRect frame = self.frame;
	frame.size = size;
	self.frame = frame;
}

- (CGSize) Size
{
	return self.bounds.size;
}

@end
