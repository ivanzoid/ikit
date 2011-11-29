//
//  CPUView.m
//  Eyeris
//
//  Created by Ivan Zezyulya on 08.11.11.
//  Copyright (c) 2011 1618Labs. All rights reserved.
//

#import "CPUView.h"
#import <mach/mach.h>
#include <unistd.h>

@implementation CPUView{
	UILabel *label;
	NSTimer *timer;
}

- (id) initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		self.userInteractionEnabled = NO;
		
		label = [[UILabel alloc] initWithFrame:self.bounds];
		label.font = [UIFont systemFontOfSize:10];
		label.textColor = [UIColor blueColor];
		label.textAlignment = UITextAlignmentRight;
		label.backgroundColor = [UIColor clearColor];
		label.userInteractionEnabled = NO;
		[self addSubview:label];
		
		timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
	}
    return self;
}

float cpu_usage()
{
	kern_return_t kr;
	task_info_data_t tinfo;
	mach_msg_type_number_t task_info_count;

	task_info_count = TASK_INFO_MAX;
	kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
	if (kr != KERN_SUCCESS) {
		NSLog(@"1");
		return -1;
	}

	task_basic_info_t      basic_info;
	thread_array_t         thread_list;
	mach_msg_type_number_t thread_count;

	thread_info_data_t     thinfo;
	mach_msg_type_number_t thread_info_count;

	thread_basic_info_t basic_info_th;
	uint32_t stat_thread = 0; // Mach threads

	basic_info = (task_basic_info_t)tinfo;

	// get threads in the task
	kr = task_threads(mach_task_self(), &thread_list, &thread_count);
	if (kr != KERN_SUCCESS) {
		NSLog(@"2");
		return -1;
	}
	if (thread_count > 0)
		stat_thread += thread_count;

	long tot_sec = 0;
	long tot_usec = 0;
	float tot_cpu = 0;
	int j;

	for (j = 0; j < thread_count; j++)
	{
		thread_info_count = THREAD_INFO_MAX;
		kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
						 (thread_info_t)thinfo, &thread_info_count);
		if (kr != KERN_SUCCESS) {
			NSLog(@"3");
			return -1;
		}

		basic_info_th = (thread_basic_info_t)thinfo;

		if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
			tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
			tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
			tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
		}

	} // for each thread

	return tot_cpu;
}

- (void) tick
{
	float cpu = cpu_usage();

	if (cpu < 0) {
		label.text = [NSString stringWithFormat:@"CPU:???%%", cpu];
	} else {
		label.text = [NSString stringWithFormat:@"CPU:%.1f%%", cpu];
	}
}

@end
