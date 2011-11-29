//
//  MemView.m
//  Eyeris
//
//  Created by Ivan Zezyulya on 01.11.11.
//  Copyright (c) 2011 1618Labs. All rights reserved.
//

#import "MemView.h"
#import <mach/mach.h>

@implementation MemView {
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
		label.textColor = [UIColor greenColor];
		label.textAlignment = UITextAlignmentRight;
		label.backgroundColor = [UIColor clearColor];
		label.userInteractionEnabled = NO;
		[self addSubview:label];

		timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
	}
    return self;
}

- (void) tick
{
	mach_port_t host_port = mach_host_self();
	mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
	vm_size_t pagesize;
	vm_statistics_data_t vm_stat;

	host_page_size(host_port, &pagesize);

	if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
		NSLog(@"MemView: failed to fetch vm statistics");
	}

//	natural_t mem_used = (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count) * pagesize;
	natural_t mem_free = vm_stat.free_count * pagesize;
//	natural_t mem_total = mem_used + mem_free;

	struct task_basic_info info;
	mach_msg_type_number_t size = sizeof(info);
	if (task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size) != KERN_SUCCESS) {
		NSLog(@"MemView: failed to get task info");
	}

	label.text = [NSString stringWithFormat:@"used:%.1fM free:%.1fM", info.resident_size/(1024.0*1024.0), mem_free/(1024.0*1024.0)];
}

@end
