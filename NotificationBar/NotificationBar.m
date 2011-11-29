//
//  NotificationBar.m
//  NotificationViewTest
//
//  Created by Ivan Zezyulya on 15.11.11.
//  Copyright (c) 2011 Al Digit. All rights reserved.
//

#import "NotificationBar.h"
#import "ShadowViewBottom.h"
#import "UIColor-Expanded.h"

@implementation NotificationBar {
	UIView *view; // container view, need it for sliding animation
	UIImageView *gradientView;
	UIView *overlayView;
	ShadowViewBottom *shadowView;
	UILabel *label1;
	UILabel *label2;
	NSTimer *timer;
}

#define kBarHeight 22
#define kShadowHeight 10
#define kFullHeight (kBarHeight + kShadowHeight)
#define kGap 10

@dynamic text, shown;
@synthesize opacity;
@synthesize tintColor;

- (id) initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, kFullHeight)]))
	{
		self.clipsToBounds = YES;
		self.userInteractionEnabled = NO;
		
		shadowView = [[ShadowViewBottom alloc] initWithFrame:CGRectMake(0, 0, self.Width, kShadowHeight)];
		[self addSubview:shadowView];

		view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, kBarHeight)];
		view.clipsToBounds = YES;
		view.BottomY = 0;

		UIImage *baseImage = [UIImage imageNamed:@"nobar-gradient"];
		UIImage *stretchImage = [baseImage stretchableImageWithLeftCapWidth:1 topCapHeight:kBarHeight];
		gradientView = [[UIImageView alloc] initWithImage:stretchImage];
		gradientView.frame = CGRectMake(0, 0, self.Width, kBarHeight);
		[view addSubview:gradientView];

		overlayView = [[UIView alloc] initWithFrame:view.bounds];
		overlayView.backgroundColor = [UIColor clearColor];
		[view addSubview:overlayView];
	
		// 2 labels for sliding text change animation

		label1 = [[UILabel alloc] initWithFrame:CGRectMake(kGap, 0, self.Width - 2*kGap, kBarHeight)];
		label1.font = [UIFont boldSystemFontOfSize:12];
		label1.textColor = [UIColor whiteColor];
		label1.shadowColor = [UIColor blackColor];
		label1.shadowOffset = CGSizeMake(0, 1);
		label1.backgroundColor = [UIColor clearColor];
		label1.lineBreakMode = UILineBreakModeTailTruncation;
		label1.textAlignment = UITextAlignmentCenter;
		label1.adjustsFontSizeToFitWidth = YES;
		[view addSubview:label1];

		label2 = [[UILabel alloc] initWithFrame:CGRectMake(kGap, 0, self.Width - 2*kGap, kBarHeight)];
		label2.font = [UIFont boldSystemFontOfSize:12];
		label2.textColor = [UIColor whiteColor];
		label2.shadowColor = [UIColor blackColor];
		label2.shadowOffset = CGSizeMake(0, 1);
		label2.backgroundColor = [UIColor clearColor];
		label2.lineBreakMode = UILineBreakModeTailTruncation;
		label2.textAlignment = UITextAlignmentCenter;
		label2.BottomY = 0;
		label2.adjustsFontSizeToFitWidth = YES;
		[view addSubview:label2];

		self.opacity = 0.7;

		[self addSubview:view];
	}
	
	return self;
}

- (void) doShow
{
	view.Y = 0;
}

- (void) doHide
{
	view.BottomY = 0;
	shadowView.Y = 0;
}

- (void) scheduleHideTimerWithInterval:(float)interval
{
	timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(hideTick) userInfo:nil repeats:NO];
}

- (void) clearHideTimer
{
	[timer invalidate];
	timer = nil;
}

- (void) hideTick
{
	[self hide];
	[self clearHideTimer];
}


#pragma mark - Public

- (BOOL) shown
{
	return (view.Y == 0.0f);
}

- (void) setTintColor:(UIColor *)itintColor animated:(BOOL)animated
{
	if (animated && ![self shown]) {
		[UIView animateWithDuration:0.3 animations:^{
			[self setTintColor:itintColor];
		}];
	} else {
		[self setTintColor:itintColor];
	}
}

- (void) setTintColor:(UIColor *)itintColor
{
	tintColor = itintColor;
	overlayView.layer.backgroundColor = [[UIColor colorWithRed:tintColor.red green:tintColor.green blue:tintColor.blue alpha:opacity] CGColor];
}

- (void) setOpacity:(float)iopacity animated:(BOOL)animated
{
	if (animated && ![self shown]) {
		[UIView animateWithDuration:0.3 animations:^{
			[self setOpacity:iopacity];
		}];
	} else {
		[self setOpacity:iopacity];
	}
}

- (void) setOpacity:(float)iopacity
{
	opacity = iopacity;
	overlayView.layer.backgroundColor = [[UIColor colorWithRed:tintColor.red green:tintColor.green blue:tintColor.blue alpha:opacity] CGColor];
}

- (UIColor *) tintColor
{
	return [UIColor colorWithCGColor:overlayView.layer.backgroundColor];
}

- (void) setText:(NSString *)text
{
	label1.text = text;
}

- (NSString *) text
{
	return label1.text;
}

- (void) setText:(NSString *)text animated:(BOOL)animated
{
	if (animated) {
		label2.text = text;
		label2.BottomY = 0;
		[UIView animateWithDuration:0.3 animations:^{
			label1.Y = kBarHeight;
			label2.Y = 0;
		} completion:^(BOOL finished) {
			UILabel *tmp = label2;
			label2 = label1;
			label1 = tmp;
		}];
	} else {
		[self setText:text];
	}
}

- (void) setText:(NSString *)text andAutoHideIn:(float)autoHideTime
{
	[self setText:text animated:YES];
	[self autoHideIn:autoHideTime];
}

- (void) hide
{
	if (![self shown])
		return;
	
	[UIView animateWithDuration:0.3 animations:^{
		[self doHide];
	}];
}

- (void) show
{
	if ([self shown])
		return;
	
	[UIView animateWithDuration:0.3 animations:^{
		view.Y = 0;
		shadowView.Y = kBarHeight;
	}];
}

- (void) showWithText:(NSString *)text
{
	[self clearHideTimer];
	if ([self shown]) {
		[self setText:text animated:YES];
	} else {
		self.text = text;
		[self show];
	}
}

- (void) autoHideIn:(float)autoHideTime
{
	[self clearHideTimer];
	[self scheduleHideTimerWithInterval:autoHideTime];
}

- (void) dontAutoHide
{
	[self clearHideTimer];
}

@end
