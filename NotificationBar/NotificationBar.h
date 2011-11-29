//
//  NotificationBar.h
//  NotificationViewTest
//
//  Created by Ivan Zezyulya on 15.11.11.
//  Copyright (c) 2011 Al Digit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationBar : UIView

@property (nonatomic, strong) UIColor *tintColor; // alpha component is not used. Use .opacity property of the bar
@property (nonatomic) float opacity; // default is 0.7
@property (nonatomic, strong) NSString *text;
@property (nonatomic, readonly) BOOL shown;

- (void) show; // slides down
- (void) showWithText:(NSString *)text;
- (void) hide; // slides up
- (void) autoHideIn:(float)autoHideTime;
- (void) dontAutoHide; // if auto-hiding was scheduled, cancels it
- (void) setText:(NSString *)text andAutoHideIn:(float)autoHideTime;
- (void) setText:(NSString *)text animated:(BOOL)animated;

- (void) setTintColor:(UIColor *)tintColor animated:(BOOL)animated;
- (void) setOpacity:(float)opacity animated:(BOOL)animated;

@end
