//
//  RobotRunLoopContext.m
//  MultiThreadedSpike
//
//  Created by Jin on 8/6/15.
//  Copyright (c) 2015 Baek. All rights reserved.
//

#import "RobotRunLoopContext.h"

@implementation RobotRunLoopContext

@synthesize runLoop = runLoop;
@synthesize source = source;

- (id)initWithSource:(RobotRunLoopSource *)src andLoop:(CFRunLoopRef)loop;
{
    self = [super init];
    if (self) {
        source = src;
        runLoop = loop;
    }
    return self;
}

@end
