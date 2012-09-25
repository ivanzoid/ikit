//
//  DeviceInfo.m
//  Eyeris
//
//  Created by Ivan Zezyulya on 24.01.12.
//  Copyright (c) 2012 Al Digit. All rights reserved.
//

#import "DeviceInfo.h"
#include <sys/types.h>
#include <sys/sysctl.h>

//
// Reference:
//    iPhone1,1 = iPhone 1G
//    iPhone1,2 = iPhone 3G
//    iPhone2,1 = iPhone 3GS
//    iPhone3,1 = iPhone 4
//    iPhone3,3 = Verizon iPhone 4
//    iPhone4,1 = iPhone 4S
//    iPod1,1 = iPod Touch 1G
//    iPod2,1 = iPod Touch 2G
//    iPod3,1 = iPod Touch 3G
//    iPod4,1 = iPod Touch 4G
//    iPad1,1 = iPad
//    iPad2,1 = iPad 2 (WiFi)
//    iPad2,2 = iPad 2 (GSM)
//    iPad2,3 = iPad 2 (CDMA)
//    iPad3,1 = iPad 3 Wi-Fi model
//    iPad3,2 = iPad 3 CDMA-configured model
//    iPad3,3 = iPad 3 Global model
//    i386 = Simulator
//    x86_64 = Simulator
//

@interface DeviceInfo ()
- (void) getAllInfo;
@end

@implementation DeviceInfo

@synthesize platform, iosVersion, isIPhone, isIPad, isIPod, isSimulator, generationMajor, generationMinor, iosVersionMajor, iosVersionMinor, iosVersionRevision, keyboardHeightPortrait;

static DeviceInfo *SDeviceInfo = nil;

+ (DeviceInfo *) sharedInfo
{
    if (!SDeviceInfo) {
        SDeviceInfo = [DeviceInfo new];
    }

    return SDeviceInfo;
}

- (id) init
{
    if ((self = [super init])) {
        [self getAllInfo];
    }

    return self;
}

- (void) getAllInfo
{
    //
    // Parse iOS version
    //

    iosVersion = [[UIDevice currentDevice] systemVersion];

    NSArray    *comps = [iosVersion componentsSeparatedByString:@"."];

    if ([comps count] >= 1) {
        iosVersionMajor = [[comps objectAtIndex:0] intValue];
    }
    if ([comps count] >= 2) {
        iosVersionMinor = [[comps objectAtIndex:1] intValue];
    }
    if ([comps count] >= 3) {
        iosVersionRevision = [[comps objectAtIndex:2] intValue];
    }

    //NSLog(@"model: %@", [[UIDevice currentDevice] model]);

    //
    // Parse machine info
    //

    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);

    char *machine = (char *) malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);

    platform = [NSString stringWithUTF8String:machine];

    free(machine);

    NSString *iPhonePrefix = @"iPhone";
    NSString *iPadPrefix = @"iPad";
    NSString *iPodPrefix = @"iPod";
    NSString *simulator32Prefix = @"i386";
    NSString *simulator64Prefix = @"x86_64";

    NSArray *prefixes = [NSArray arrayWithObjects:iPhonePrefix, iPadPrefix, iPodPrefix, simulator32Prefix, simulator64Prefix, nil];
    NSString *prefix = nil;

    for (NSString *aprefix in prefixes) {
        if ([platform hasPrefix:aprefix]) {
            prefix = aprefix;
        }
    }

    if (!prefix)
        return;

    if (prefix == iPhonePrefix) {
        isIPhone = YES;
    } else if (prefix == iPadPrefix) {
        isIPad = YES;
    } else if (prefix == iPodPrefix) {
        isIPod = YES;
    } else if (prefix == simulator32Prefix || prefix == simulator64Prefix) {
        isSimulator = YES;
    }

    NSString *model = [[UIDevice currentDevice] model];

    if ([model isEqualToString:@"iPad Simulator"]) {
        isIPad = YES;
    }
    else if ([model isEqualToString:@"iPhone Simulator"]) {
        isIPhone = YES;
    }

    NSString *version = [platform substringFromIndex:[prefix length]];

    NSArray *generationComps = [version componentsSeparatedByString:@","];

    if ([generationComps count] >= 1) {
        generationMajor = [[generationComps objectAtIndex:0] intValue];
    }
    if ([generationComps count] >= 2) {
        generationMinor = [[generationComps objectAtIndex:1] intValue];
    }

    keyboardHeightPortrait = isIPad ? 264 : 216;
}

@end
