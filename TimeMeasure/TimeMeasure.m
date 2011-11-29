//
//  TimeMeasure.m
//  Eyeris
//
//  Created by Ivan Zezyulya on 17.10.11.
//  Copyright (c) 2011 1618Labs. All rights reserved.
//

#import "TimeMeasure.h"
#import "TimeMeasurePrivate.h"

@implementation TimeMeasure

#define MAX_STACK

static NSMutableArray *TimeObjects = nil;

+ (void) begin:(NSString *)name
{
	if (!TimeObjects) {
		TimeObjects = [NSMutableArray new];
	}
	
	TimeMeasureObject *timeMeasure = [TimeMeasureObject new];

	timeMeasure.startTime = [NSDate timeIntervalSinceReferenceDate];
	timeMeasure.name = name;

	[TimeObjects addObject:timeMeasure];
}

+ (void) begin
{
	[[self class] begin:nil];
}

+ (CGFloat) end
{
	if (!TimeObjects) {
		[NSException raise:@"TimeMeasure" format:@"TimeMeasure: use -[begin] before -[end]"];
	}

	if ([TimeObjects count] == 0) {
		[NSException raise:@"TimeMeasure" format:@"TimeMeasure: use -[begin] before -[end]"];
	}

	TimeMeasureObject *timeMeasure = [TimeObjects lastObject];
	[TimeObjects removeLastObject];

	CGFloat time = [NSDate timeIntervalSinceReferenceDate] - timeMeasure.startTime;

	if ([timeMeasure.name length]) {
		NSLog(@"%@: %.0fms", timeMeasure.name, time*1000);
	}

	return time;
}

@end
