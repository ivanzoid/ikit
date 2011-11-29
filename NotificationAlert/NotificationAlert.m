//
//  NotificationView.m
//  AVCam
//
//  Created by Ivan on 26.08.11.
//  Copyright 2011 1618Labs. All rights reserved.
//

#import "NotificationAlert.h"
#import "UIView+Dimensions.h"

@implementation NotificationAlert {
	UILabel *titleLabel;
	UILabel *textLabel;
	UIActivityIndicatorView *activity;
	UIImageView *imageView;
}

#define kHGap 10
#define kVGap 5

- (void) baseInitWithTitle:(NSString *)title withText:(NSString *)text withBottomView:(UIView *)bottomView inView:(UIView *)view
{
	self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
	self.layer.cornerRadius = 10;

	self.alpha = 0;

	const float maxWidth = 160;

	if (title) {
		titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, maxWidth, 1)];
		titleLabel.textColor = [UIColor whiteColor];
		titleLabel.font = [UIFont boldSystemFontOfSize:13];
		titleLabel.shadowColor = [UIColor blackColor];
		titleLabel.shadowOffset = CGSizeMake(0, 1);
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.numberOfLines = 0;
		titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		titleLabel.textAlignment = UITextAlignmentCenter;
		[self addSubview:titleLabel];

		CGSize messageSize = [title sizeWithFont:titleLabel.font constrainedToSize:CGSizeMake(maxWidth, 9999.0f) lineBreakMode:UILineBreakModeWordWrap];
		titleLabel.Width = messageSize.width;
		titleLabel.Height = messageSize.height;
		titleLabel.text = title;
	}

	if (text) {
		textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, titleLabel.BottomY + kVGap + 2, maxWidth, 1)];
		textLabel.textColor = [UIColor whiteColor];
		textLabel.font = [UIFont systemFontOfSize:12];
		textLabel.shadowColor = [UIColor blackColor];
		textLabel.shadowOffset = CGSizeMake(0, 1);
		textLabel.backgroundColor = [UIColor clearColor];
		textLabel.numberOfLines = 0;
		textLabel.lineBreakMode = UILineBreakModeWordWrap;
		textLabel.textAlignment = UITextAlignmentCenter;
		[self addSubview:textLabel];

		CGSize messageSize = [text sizeWithFont:textLabel.font constrainedToSize:CGSizeMake(maxWidth, 9999.0f) lineBreakMode:UILineBreakModeWordWrap];
		textLabel.Width = messageSize.width;
		textLabel.Height = messageSize.height;
		textLabel.text = text;
	}

	float width = fmaxf(titleLabel.Width, textLabel.Width);

	if (bottomView) {
		[self addSubview:bottomView];
		bottomView.Y = (textLabel ? textLabel.BottomY : titleLabel.BottomY) + 8;
		bottomView.CenterX = width/2 + kHGap;
	}

	titleLabel.CenterX = width/2 + kHGap;
	textLabel.CenterX = width/2 + kHGap;

	self.Width = width + kHGap*2;
	self.Height = (bottomView ? bottomView.BottomY : textLabel.BottomY) + kVGap*2;

	self.CenterX = view.Width/2;
	self.CenterY = view.Height/2;
}

- (id) initWithTitle:(NSString *)title withText:(NSString *)text withImage:(UIImage *)image inView:(UIView *)view
{
	if ((self = [super init])) {
		if (image) {
			imageView = [[UIImageView alloc] initWithImage:image];
		}

		[self baseInitWithTitle:title withText:text withBottomView:imageView inView:view];
	}

	return self;
}


- (id) initWithTitle:(NSString *)title withText:(NSString *)text showSpinner:(BOOL)showSpinner inView:(UIView *)view
{
	if ((self = [super init]))
	{
		if (showSpinner) {
			activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		}

		[self baseInitWithTitle:title withText:text withBottomView:activity inView:view];
	}

	return self;
}

- (void) show
{
	if (self.alpha != 0)
		return;

	[self.superview bringSubviewToFront:self];

	self.transform = CGAffineTransformMakeScale(0.001, 0.001);

	[UIView animateWithDuration:0.3 animations:^{
		if (activity) {
			[activity startAnimating];
		}
		self.transform = CGAffineTransformIdentity;
		self.alpha = 1.0;
	}];
}

- (void) hide
{
	[UIView animateWithDuration:0.3 animations:^{
		self.transform = CGAffineTransformMakeScale(0.001, 0.001);
		self.alpha = 0.0;
	} completion:^(BOOL completed){
		[activity stopAnimating];
	}];
}

- (void) hideAndRemoveFromSuperview
{
	[UIView animateWithDuration:0.3 animations:^{
		self.transform = CGAffineTransformMakeScale(0.001, 0.001);
		self.alpha = 0.0;
	} completion:^(BOOL completed){
		[activity stopAnimating];
		[self removeFromSuperview];
	}];
}

@end
