//
//  BottomShadowView.m
//  Eyeris
//
//  Created by Ivan Zezyulya on 22.11.11.
//  Copyright (c) 2011 1618Labs. All rights reserved.
//

#import "ShadowViewBottom.h"

@implementation ShadowViewBottom

- (id) initWithFrame:(CGRect)frame withOpacity:(float)opacity
{
	if ((self = [super initWithFrame:frame]))
	{
		float width = frame.size.width;
		float height = frame.size.height;

		self.clipsToBounds = YES;
		self.layer.shouldRasterize = YES;
		self.layer.rasterizationScale = [UIScreen mainScreen].scale;

		CALayer *shadowLayer = [CALayer new];
		shadowLayer.masksToBounds = NO;
		shadowLayer.frame = CGRectMake(0, -height, width, height*2);
		shadowLayer.shadowColor = [UIColor blackColor].CGColor;
		shadowLayer.shadowOpacity = opacity;
		shadowLayer.shadowOffset = CGSizeZero;
		shadowLayer.shadowRadius = height/2;
		shadowLayer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(-height, 0, width + 2*height, height) cornerRadius:0].CGPath;

		[self.layer addSublayer:shadowLayer];
	}

	return self;
}

- (id) initWithFrame:(CGRect)frame
{
	return (self = [self initWithFrame:frame withOpacity:0.7]);
}

@end
