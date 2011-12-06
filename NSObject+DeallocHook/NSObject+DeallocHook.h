//
//  NSObject+DeallocHook.h
//  DeallocHook
//
//  Created by Ivan Zezyulya on 06.12.11.
//  Copyright (c) 2011 Al Digit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DeallocHook)

- (void) addDeallocHook:(id)target withAction:(SEL)action;
- (void) clearDeallocHooksWithTarget:(id)target;
- (void) clearDeallocHooks;

@end
