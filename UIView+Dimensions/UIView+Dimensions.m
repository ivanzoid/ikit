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
	return self.frame.size.width;
}

- (void) setWidth:(CGFloat)width
{
	CGRect frame = self.frame;
	frame.size.width = width;
	self.frame = frame;
}

- (CGFloat) Height
{
	return self.frame.size.height;
}

- (void) setHeight:(CGFloat)height
{
	CGRect frame = self.frame;
	frame.size.height = height;
	self.frame = frame;
}

- (CGFloat) X
{
	return self.center.x - self.Width/2;
}

- (void) setX:(CGFloat)x
{
	self.center = CGPointMake(x + self.Width/2, self.center.y);
}

- (CGFloat) Y
{
	return self.center.y - self.Height/2;
}

- (void) setY:(CGFloat)y
{
	self.center = CGPointMake(self.center.x, y + self.Height/2);
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
	return self.frame.size;
}

- (void) setOrigin:(CGPoint)origin
{
	self.center = CGPointMake(origin.x + self.Width/2, origin.y + self.Height/2);
}

- (CGPoint) Origin
{
	return CGPointMake(self.center.x - self.Width/2, self.center.y - self.Height/2);
}

- (void) setTopLeft:(CGPoint)topLeft
{
	self.Origin = topLeft;
}

- (CGPoint) TopLeft
{
	return self.Origin;
}

- (void) setTopRight:(CGPoint)topRight
{
	self.Y = topRight.y;
	self.X = topRight.x - self.Width;
}

- (CGPoint) TopRight
{
	return CGPointMake(self.X + self.Width, self.Y);
}

- (void) setBottomLeft:(CGPoint)bottomLeft
{
	self.Y = bottomLeft.y - self.Height;
	self.X = bottomLeft.x;
}

- (CGPoint) BottomLeft
{
	return CGPointMake(self.X, self.Y + self.Height);
}

- (void) setBottomRight:(CGPoint)bottomRight
{
	self.X = bottomRight.x - self.Width;
	self.Y = bottomRight.y - self.Height;
}

- (CGPoint) BottomRight
{
	return CGPointMake(self.X + self.Width, self.Y + self.Height);
}

@end
