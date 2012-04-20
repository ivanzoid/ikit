//
//	NSObject+NSCoding.m
//	OpenStack
//
//	Created by Michael Mayo on 3/4/11.
//	The OpenStack project is provided under the Apache 2.0 license.
//

#import "NSObject+NSCoding.h"
#import <objc/runtime.h>


@implementation NSObject (NSCoding)

- (NSMutableDictionary *) propertiesForClass:(Class)klass
{
	NSMutableDictionary *results = [NSMutableDictionary dictionary];

	unsigned int outCount;
	objc_property_t *properties = class_copyPropertyList(klass, &outCount);

	for (unsigned i = 0; i < outCount; i++)
	{
		objc_property_t property = properties[i];

		NSString *pname = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
		NSString *pattrs = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];

		pattrs = [[pattrs componentsSeparatedByString:@","] objectAtIndex:0];
		pattrs = [pattrs substringFromIndex:1];

		[results setObject:pattrs forKey:pname];
	}

	free(properties);

	if ([klass superclass] != [NSObject class])
	{
		[results addEntriesFromDictionary:[self propertiesForClass:[klass superclass]]];
	}

	return results;
}

- (NSDictionary *) properties
{
	return [self propertiesForClass:[self class]];
}

- (void) autoEncodeWithCoder:(NSCoder *)coder
{
	NSDictionary *properties = [self properties];

	NSArray *ignoredProperties = nil;
	if ([[self class] respondsToSelector:@selector(autoCodingIgnoredProperties)]) {
		ignoredProperties = [[self class] performSelector:@selector(autoCodingIgnoredProperties)];
	}

	for (NSString *key in properties)
	{
		if ([ignoredProperties containsObject:key]) {
			continue;
		}

		NSString *type = [properties objectForKey:key];
		NSString *className;

		NSMethodSignature *signature = [self methodSignatureForSelector:NSSelectorFromString(key)];
		NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
		[invocation setSelector:NSSelectorFromString(key)];
		[invocation setTarget:self];

		switch ([type characterAtIndex:0]) {
			case '@': {	// object
				id value;
				if ([[type componentsSeparatedByString:@"\""] count] > 1)
				{
					className = [[type componentsSeparatedByString:@"\""] objectAtIndex:1];
					Class class = NSClassFromString(className);
					value = [self performSelector:NSSelectorFromString(key)];

					// only decode if the property conforms to NSCoding
					if([class conformsToProtocol:@protocol(NSCoding)]){
						[coder encodeObject:value forKey:key];
					}
				}
				break;
			}
			case 'c': {	// bool
				BOOL boolValue;
				[invocation invoke];
				[invocation getReturnValue:&boolValue];
				[coder encodeObject:[NSNumber numberWithBool:boolValue] forKey:key];
				break;
			}
			case 'f': {	// float
				float floatValue;
				[invocation invoke];
				[invocation getReturnValue:&floatValue];
				[coder encodeObject:[NSNumber numberWithFloat:floatValue] forKey:key];
				break;
			}
			case 'd': {	// double
				double doubleValue;
				[invocation invoke];
				[invocation getReturnValue:&doubleValue];
				[coder encodeObject:[NSNumber numberWithDouble:doubleValue] forKey:key];
				break;
			}
			case 'i': {	// int
				NSInteger intValue;
				[invocation invoke];
				[invocation getReturnValue:&intValue];
				[coder encodeObject:[NSNumber numberWithInt:intValue] forKey:key];
				break;
			}
			case 'L': {	// unsigned long
				unsigned long ulValue;
				[invocation invoke];
				[invocation getReturnValue:&ulValue];
				[coder encodeObject:[NSNumber numberWithUnsignedLong:ulValue] forKey:key];
				break;
			}
			case 'Q': {	// unsigned long long
				unsigned long long ullValue;
				[invocation invoke];
				[invocation getReturnValue:&ullValue];
				[coder encodeObject:[NSNumber numberWithUnsignedLongLong:ullValue] forKey:key];
				break;
			}
			case 'l': {	// long
				long longValue;
				[invocation invoke];
				[invocation getReturnValue:&longValue];
				[coder encodeObject:[NSNumber numberWithLong:longValue] forKey:key];
				break;
			}
			case 's': {	// short
				short shortValue;
				[invocation invoke];
				[invocation getReturnValue:&shortValue];
				[coder encodeObject:[NSNumber numberWithShort:shortValue] forKey:key];
				break;
			}
			case 'I': {	// unsigned
				unsigned unsignedValue;
				[invocation invoke];
				[invocation getReturnValue:&unsignedValue];
				[coder encodeObject:[NSNumber numberWithUnsignedInt:unsignedValue] forKey:key];
				break;
			}
			default:
				break;
		}		 
	}
}

- (void) autoDecode:(NSCoder *)coder
{
	NSDictionary *properties = [self properties];

	NSArray *ignoredProperties = nil;
	if ([[self class] respondsToSelector:@selector(autoCodingIgnoredProperties)]) {
		ignoredProperties = [[self class] performSelector:@selector(autoCodingIgnoredProperties)];
	}

	for (NSString *key in properties)
	{
		if ([ignoredProperties containsObject:key]) {
			continue;
		}

		NSString *type = [properties objectForKey:key];

		switch ([type characterAtIndex:0])
		{
			case '@': {	// object
				if ([[type componentsSeparatedByString:@"\""] count] > 1) {
					NSString *className = [[type componentsSeparatedByString:@"\""] objectAtIndex:1];					   
					Class class = NSClassFromString(className);
					// only decode if the property conforms to NSCoding
					if ([class conformsToProtocol:@protocol(NSCoding )]){
						id value = [[coder decodeObjectForKey:key] retain];
						unsigned int addr = (NSInteger)&value;
						object_setInstanceVariable(self, [key UTF8String], *(id**)addr);
					}
				}
				break;
			}
			case 'c': {	// bool
				NSNumber *number = [coder decodeObjectForKey:key];				
				BOOL b = [number boolValue];
				unsigned int addr = (NSInteger)&b;
				object_setInstanceVariable(self, [key UTF8String], *(NSInteger**)addr);
				break;
			}
			case 'f': {	// float
				NSNumber *number = [coder decodeObjectForKey:key];				
				CGFloat f = [number floatValue];
				unsigned int addr = (NSInteger)&f;
				object_setInstanceVariable(self, [key UTF8String], *(NSInteger**)addr);
				break;
			}
			case 'd': {	// double				 
				NSNumber *number = [coder decodeObjectForKey:key];
				double d = [number doubleValue];
				Ivar ivar;
				if ((ivar = class_getInstanceVariable([self class], [key UTF8String]))) {
					double *varIndex = (double *)(void **)((char *)self + ivar_getOffset(ivar));
					*varIndex = d;
				}
				break;
			}
			case 'i': {	// int
				NSNumber *number = [coder decodeObjectForKey:key];
				NSInteger i = [number intValue];
				unsigned int addr = (NSInteger)&i;
				object_setInstanceVariable(self, [key UTF8String], *(NSInteger**)addr);
				break;
			}
			case 'L': {	// unsigned long
				NSNumber *number = [coder decodeObjectForKey:key];
				unsigned long ul = [number unsignedLongValue];
				unsigned int addr = (NSInteger)&ul;
				object_setInstanceVariable(self, [key UTF8String], *(NSInteger**)addr);
				break;
			}
			case 'Q': {	// unsigned long long
				NSNumber *number = [coder decodeObjectForKey:key];
				unsigned long long ull = [number unsignedLongLongValue];
				unsigned int addr = (NSInteger)&ull;
				object_setInstanceVariable(self, [key UTF8String], *(NSInteger**)addr);
				break;
			}
			case 'l': {	// long
				NSNumber *number = [coder decodeObjectForKey:key];
				long longValue = [number longValue];
				unsigned int addr = (NSInteger)&longValue;
				object_setInstanceVariable(self, [key UTF8String], *(NSInteger**)addr);
				break;
			}
			case 'I': {	// unsigned
				NSNumber *number = [coder decodeObjectForKey:key];
				unsigned unsignedValue = [number unsignedIntValue];
				unsigned int addr = (NSInteger)&unsignedValue;
				object_setInstanceVariable(self, [key UTF8String], *(NSInteger**)addr);
				break;
			}
			case 's': {	// short
				NSNumber *number = [coder decodeObjectForKey:key];
				short shortValue = [number shortValue];
				unsigned int addr = (NSInteger)&shortValue;
				object_setInstanceVariable(self, [key UTF8String], *(NSInteger**)addr);
				break;
			}

			default:
				break;
		}
	}
}

@end