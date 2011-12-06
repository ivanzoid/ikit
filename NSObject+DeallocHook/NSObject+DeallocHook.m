//
//  NSObject+DeallocHook.m
//  DeallocHook
//
//  Created by Ivan Zezyulya on 06.12.11.
//  Copyright (c) 2011 Al Digit. All rights reserved.
//

#import "NSObject+DeallocHook.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface DeallocHook : NSObject

@property (nonatomic, unsafe_unretained) id delegate;
@property (nonatomic) SEL selector;
@property (nonatomic, unsafe_unretained) id object;
@property (nonatomic, unsafe_unretained) id selfObject;

@end


@implementation DeallocHook

@synthesize delegate, selector, object, selfObject;

- (void) dealloc
{
	//NSLog(@"DeallocHook dealloc");
	if (delegate) {
		if ([delegate respondsToSelector:selector])
		{
			//NSLog(@"sending %@ to %@", NSStringFromSelector(selector), NSStringFromClass([delegate class]));

			//[delegate performSelector:selector withObject:object];

			// We use objec_msgSend because performSelector gives us a warning and it this moment we can't disable it.
			objc_msgSend(delegate, selector, object);
		}

		if (selfObject) {
			//NSLog(@"sending clearDeallocHooksWithTarget to %@ with arument = %@", NSStringFromClass([delegate class]), NSStringFromClass([selfObject class]));
			[delegate performSelector:@selector(clearDeallocHooksWithTarget:) withObject:selfObject];
		}
	}
}

@end


// ====================================================================================


@interface NSObject (DeallocHookPrivate)

- (void) doAddDeallocHook:(id)target withAction:(SEL)action withObject:(id)object withSelfObject:(id)selfObject;

@end


@implementation NSObject (DeallocHook)

static char DeallocHookKey = 0;

- (void) doAddDeallocHook:(id)target withAction:(SEL)action withObject:(id)object withSelfObject:(id)selfObject
{
	NSMutableSet *hooks = objc_getAssociatedObject(self, &DeallocHookKey);

	if (!hooks) {
		hooks = [NSMutableSet new];
		objc_setAssociatedObject(self, &DeallocHookKey, hooks, OBJC_ASSOCIATION_RETAIN);
	}

	DeallocHook *hook = [DeallocHook new];
	hook.delegate = target;
	hook.selector = action;
	hook.object = object;
	hook.selfObject = selfObject;

	[hooks addObject:hook];
}

- (void) addDeallocHook:(id)target withAction:(SEL)action
{
	[self doAddDeallocHook:target withAction:action withObject:self withSelfObject:self];
	[target doAddDeallocHook:self withAction:nil withObject:nil withSelfObject:target];
}

- (void) clearDeallocHooks
{
	NSMutableSet *hooks = objc_getAssociatedObject(self, &DeallocHookKey);

	if (!hooks)
		return;

	for (DeallocHook *hook in hooks) {
		hook.delegate = nil;
	}

	[hooks removeAllObjects];

	objc_setAssociatedObject(self, &DeallocHookKey, nil, OBJC_ASSOCIATION_RETAIN);
}

- (void) clearDeallocHooksWithTarget:(id)target
{
	NSMutableSet *hooks = objc_getAssociatedObject(self, &DeallocHookKey);
	if (!hooks)
		return;

	NSMutableSet *hooksToRemove = [NSMutableSet new];
	
	for (DeallocHook *hook in hooks) {
		if (hook.delegate == target) {
			hook.delegate = nil;
			[hooksToRemove addObject:hook];
		}
	}

	[hooks minusSet:hooksToRemove];

	if ([hooks count] == 0) {
		objc_setAssociatedObject(self, &DeallocHookKey, nil, OBJC_ASSOCIATION_RETAIN);
	}
}

@end
