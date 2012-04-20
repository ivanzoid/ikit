//
//  NSObject+Property.h
//
//  Created by Ivan Zezyulya on 20.04.12.
//  Copyright (c) 2012 Al Digit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

/*
 * Macro below will allow you to add any property to any class in your program.
 * Important note: property name shall start with capitalized letter (i.e. 'MyPropertyName' and not 'myPropertyName')
 *
 * =========================================
 *
 * Typical usage:
 *
 * // .h file
 *
 * @interface SomeClass (MyCategory)
 *
 * @property (nonatomic, retain) NSString *MyNewProperty;
 *
 * @end
 *
 * // .m file
 *
 * @implementation SomeClass (MyCategory)
 *
 * IMPLEMENT_RETAIN_PROPERTY(NSString *, MyNewProperty)
 *
 * - (void) someFunction
 * {
 *     ...
 *
 *     self.MyNewProperty = @"lalala";
 * }
 *
 * - (void) anotherFunction
 * {
 *     ...
 *
 *     // Use stored MyNewProperty
 *
 *     foo = self.MyNewProperty;
 *
 *     ...
 * }
 *
 */

//
// Important note: property name shall start with capitalized letter (i.e. 'MyPropertyName' and not 'myPropertyName')
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
