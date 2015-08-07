//
//  RobotRunLoopContext.h
//  MultiThreadedSpike
//
//  Created by Jin on 8/6/15.
//  Copyright (c) 2015 Baek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RobotRunLoopSource.h"

@interface RobotRunLoopContext : NSObject
{
    CFRunLoopRef runLoop;
    RobotRunLoopSource *source;
}

@property (readonly) CFRunLoopRef runLoop;
@property (readonly) RobotRunLoopSource *source;

- (id)initWithSource:(RobotRunLoopSource *)src andLoop:(CFRunLoopRef)loop;

@end
