//
//  TimeMeasure.h
//  Eyeris
//
//  Created by Ivan Zezyulya on 17.10.11.
//  Copyright (c) 2011 1618Labs. All rights reserved.
//

@interface TimeMeasure : NSObject

+ (void) begin;
+ (void) begin:(NSString *)name;
+ (CGFloat) end;

#define TIME_MEASURE(code) \
[TimeMeasure begin:[NSString stringWithCString:#code encoding:NSUTF8StringEncoding]]; \
code; \
[TimeMeasure end];

#ifdef DEBUG
#	define DTIME_MEASURE(code) TIME_MEASURE(code)
#else
#	define DTIME_MEASURE(code) code
#endif

@end
