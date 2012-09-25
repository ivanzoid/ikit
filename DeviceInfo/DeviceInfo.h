//
//  DeviceInfo.h
//  Eyeris
//
//  Created by Ivan Zezyulya on 24.01.12.
//  Copyright (c) 2012 Al Digit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInfo : NSObject

+ (DeviceInfo *) sharedInfo;

@property (nonatomic, strong, readonly) NSString *platform;
@property (nonatomic, strong, readonly) NSString *iosVersion;

@property (nonatomic, readonly) BOOL isIPhone;
@property (nonatomic, readonly) BOOL isIPad;
@property (nonatomic, readonly) BOOL isIPod;
@property (nonatomic, readonly) BOOL isSimulator;

@property (nonatomic, readonly) int generationMajor;
@property (nonatomic, readonly) int generationMinor;

@property (nonatomic, readonly) int iosVersionMajor;
@property (nonatomic, readonly) int iosVersionMinor;
@property (nonatomic, readonly) int iosVersionRevision;

@property (nonatomic, readonly) float keyboardHeightPortrait;

@end
