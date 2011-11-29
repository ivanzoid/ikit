//
//  CameraView.m
//  Eyeris
//
//  Created by Ivan Zezyulya on 12.10.11.
//  Copyright 2011 1618Labs. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "CameraView.h"
#import "NSObject+Notifications.h"
#import "UIImageExtras.h"

@interface AVCaptureStillImageOutput (Extend)

- (AVCaptureConnection *) connectionWithMediaType:(NSString *)mediaType;

@end

@implementation AVCaptureStillImageOutput (Extend)

- (AVCaptureConnection *) connectionWithMediaType:(NSString *)mediaType
{
	for (AVCaptureConnection *connection in self.connections)
	{
		for (AVCaptureInputPort *port in [connection inputPorts])
		{
			if ([[port mediaType] isEqual:mediaType])
			{
				return connection;
			}
		}
	}

	return nil;
}

@end


@interface CameraView () <AVCaptureVideoDataOutputSampleBufferDelegate>
@end


@implementation CameraView {
	AVCaptureVideoPreviewLayer *mLayer;
	AVCaptureDeviceInput *mCaptureInput;
	AVCaptureSession *mCaptureSession;
	AVCaptureStillImageOutput *mStillImageOutput;
	AVCaptureVideoDataOutput *mRealTimeOutput;
	UIImageView *mImageView;
}

@synthesize delegate, lastScreenshot;
@dynamic applyBlur;

static CameraView *SCameraView = nil;

NSString *CameraViewNotificationDidMakeScreenshot = @"CameraViewDidMakeScreenshot";

- (id) initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		mCaptureSession = [AVCaptureSession new];
		mCaptureSession.sessionPreset = AVCaptureSessionPresetMedium;

		mCaptureInput = [AVCaptureDeviceInput deviceInputWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] 
											  error:nil];

		if ([mCaptureSession canAddInput:mCaptureInput])
		{
			[mCaptureSession addInput:mCaptureInput];
		}

		mStillImageOutput = [AVCaptureStillImageOutput new];
		mStillImageOutput.outputSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA]
																	   forKey:(NSString *)kCVPixelBufferPixelFormatTypeKey];

		if ([mCaptureSession canAddOutput:mStillImageOutput])
		{
			[mCaptureSession addOutput:mStillImageOutput];
		}

//		mRealTimeOutput = [AVCaptureVideoDataOutput new];
//		mRealTimeOutput.alwaysDiscardsLateVideoFrames = YES; 
//		dispatch_queue_t queue = dispatch_queue_create("CameraViewQueue", NULL);
//		[mRealTimeOutput setSampleBufferDelegate:self queue:queue];
//		dispatch_release(queue);
//		mRealTimeOutput.videoSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA]
//																	   forKey:(NSString *)kCVPixelBufferPixelFormatTypeKey];
//		[mCaptureSession addOutput:mRealTimeOutput];
//
//		mImageView = [[UIImageView alloc] initWithFrame:self.bounds];
//		mImageView.contentMode = UIViewContentModeScaleAspectFill;
//		[self addSubview:mImageView];

		mLayer = [AVCaptureVideoPreviewLayer layerWithSession:mCaptureSession];
		mLayer.frame = self.bounds;
		mLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
		[self.layer addSublayer:mLayer];

		SCameraView = self;
	}

    return self;
}

+ (CameraView *) sharedCameraView
{
	return SCameraView;
}

- (void) dealloc
{
	SCameraView = nil;
	[self stopCapture];
}

- (void) startCapture
{
	[mCaptureSession startRunning];
}

- (void) stopCapture
{
	[mCaptureSession stopRunning];
}

UIImage * ImageFromSampleBuffer(CMSampleBufferRef sampleBuffer)
{
	CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
	/*Lock the image buffer*/
	CVPixelBufferLockBaseAddress(imageBuffer, 0);
	/*Get information about the image*/
	uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
	size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
	size_t width = CVPixelBufferGetWidth(imageBuffer);
	size_t height = CVPixelBufferGetHeight(imageBuffer);

	/*Create a CGImageRef from the CVImageBufferRef*/
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
	CGImageRef newImage = CGBitmapContextCreateImage(newContext);

	/*We release some components*/
	CGContextRelease(newContext);
	CGColorSpaceRelease(colorSpace);

	/* We need to change the orientation of the image so that the video is displayed correctly */
	UIImage *image = [UIImage imageWithCGImage:newImage scale:1 orientation:UIImageOrientationRight];

	/*We relase the CGImageRef*/
	CGImageRelease(newImage);

	/*We unlock the  image buffer*/
	CVPixelBufferUnlockBaseAddress(imageBuffer, 0);

	return image;
}

- (void) captureOutput:(AVCaptureOutput *)captureOutput 
 didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer 
		fromConnection:(AVCaptureConnection *)connection 
{
	@autoreleasepool {
		UIImage *image = ImageFromSampleBuffer(sampleBuffer);
//		UIImage *scaledImage = [image imageScaledToSize:CGSizeMake(image.size.width * 0.3, image.size.height * 0.3)];
		[mImageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
	}
}

- (void) makeScreenshot
{
	lastScreenshot = nil;

	AVCaptureConnection *stillImageConnection = [mStillImageOutput connectionWithMediaType:AVMediaTypeVideo];

	[mStillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef sampleBuffer, NSError *error)
		{
			lastScreenshot = ImageFromSampleBuffer(sampleBuffer);
			
			[self postNotification:CameraViewNotificationDidMakeScreenshot];

			if ([delegate respondsToSelector:@selector(cameraViewDidMakeScreenshot:)])
			{
				[delegate performSelectorOnMainThread:@selector(cameraViewDidMakeScreenshot:) withObject:lastScreenshot waitUntilDone:NO];
			}
		}];
}

- (void) setApplyBlur:(BOOL)applyBlur
{
	if (applyBlur) {
		mLayer.shouldRasterize = YES;
		mLayer.rasterizationScale = 0.125;
	} else {
		mLayer.shouldRasterize = NO;
		mLayer.rasterizationScale = [UIScreen mainScreen].scale;
	}
}

@end
