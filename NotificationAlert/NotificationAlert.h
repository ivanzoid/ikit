//
//  NotificationView.h
//  AVCam
//
//  Created by Ivan on 26.08.11.
//  Copyright 2011 1618Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationAlert : UIView

- (void) show;
- (void) hide;
- (void) hideAndRemoveFromSuperview;

- (id) initWithTitle:(NSString *)title withText:(NSString *)text showSpinner:(BOOL)showSpinner inView:(UIView *)view;
- (id) initWithTitle:(NSString *)title withText:(NSString *)text withImage:(UIImage *)image inView:(UIView *)view;

@end
