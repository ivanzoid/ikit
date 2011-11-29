//
//  NSDictionary+SafeAccess.h
//  OwlCity
//
//  Created by Ivan on 03.05.11.
//  Copyright 2011 Al Digit. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (SafeAccess)

- (id) strictObjectOfClass:(Class)class forKey:(id)key;
- (id) safeObjectOfClass:(Class)class forKey:(id)key;

- (NSString *) stringForKey:(id)key;
- (NSString *) safeStringForKey:(id)key;

- (NSNumber *) numberForKey:(id)key;
- (NSNumber *) safeNumberForKey:(id)key;

- (NSNumber *) smartNumberForKey:(id)key; // if value for key is string, it is converted automatically to number

- (NSDecimalNumber *) decimalNumberForKey:(id)key;
- (NSDecimalNumber *) safeDecimalNumberForKey:(id)key;

- (NSDictionary *) dictionaryForKey:(id)key;
- (NSDictionary *) safeDictionaryForKey:(id)key;

- (NSArray *) arrayForKey:(id)key;
- (NSArray *) safeArrayForKey:(id)key;

@end

@interface NSMutableDictionary (SafeAccess)

- (void) safeSetObject:(id)object forKey:(id)key;

@end
