//
//  CameraView.h
//  Eyeris
//
//  Created by Ivan Zezyulya on 12.10.11.
//  Copyright 2011 1618Labs. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CameraViewDelegate <NSObject>

- (void) cameraViewDidMakeScreenshot:(UIImage *)image;

@end


@class AVCaptureSession, AVCaptureStillImageOutput;

extern NSString *CameraViewNotificationDidMakeScreenshot;

@interface CameraView : UIView

- (void) startCapture;
- (void) stopCapture;
- (void) makeScreenshot;

+ (CameraView *) sharedCameraView;

@property (nonatomic, unsafe_unretained) NSObject <CameraViewDelegate> *delegate;
@property (nonatomic, strong) UIImage *lastScreenshot;

@property (nonatomic) BOOL applyBlur;

@end
