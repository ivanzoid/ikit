//
//  NSObject+Property.h
//
//  Created by Ivan Zezyulya on 20.04.12.
//  Copyright (c) 2012 Al Digit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

//
// Importang note: use only property names with first letter capitalized! (i.e. 'name' -> 'Name')
//
#define IMPLEMENT_RETAIN_PROPERTY(type, Name) \
static const char * Key##Name = #Name; \
\
- (void) set##Name:(type)value \
{\
    objc_setAssociatedObject(self, Key##Name, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC); \
}\
\
- (type) Name \
{\
	return objc_getAssociatedObject(self, Key##Name); \
}\
