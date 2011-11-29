//
//  TimeMeasurePrivate.h
//  Eyeris
//
//  Created by Ivan Zezyulya on 07.11.11.
//  Copyright (c) 2011 1618Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeMeasureObject : NSObject

@property (nonatomic) NSTimeInterval startTime;
@property (nonatomic, strong) NSString *name;

@end
