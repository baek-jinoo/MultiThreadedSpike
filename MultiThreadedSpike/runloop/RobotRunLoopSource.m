//
//  RobotRunLoopSource.m
//  MultiThreadedSpike
//
//  Created by Jin on 8/6/15.
//  Copyright (c) 2015 Baek. All rights reserved.
//

#import "RobotRunLoopSource.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "RobotRunLoopContext.h"

void RunLoopSourcePerformRoutine (void *info)
{
    RobotRunLoopSource*  obj = (__bridge RobotRunLoopSource*)info;
    [obj sourceFired];
}

void RunLoopSourceScheduleRoutine (void *info, CFRunLoopRef rl, CFStringRef mode)
{
    RobotRunLoopSource *obj = (__bridge RobotRunLoopSource *)info; //TODONOW check the retain count of info when it comes in, to ensure that __bridge_transfer is applicable
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    RobotRunLoopContext* theContext = [[RobotRunLoopContext alloc] initWithSource:obj andLoop:rl];

    [del performSelectorOnMainThread:@selector(registerSource:)
                          withObject:theContext waitUntilDone:NO];
}

void RunLoopSourceCancelRoutine (void *info, CFRunLoopRef rl, CFStringRef mode)
{
    RobotRunLoopSource *obj = (__bridge RobotRunLoopSource*)info;
    AppDelegate *del =  (AppDelegate *)[UIApplication sharedApplication].delegate;
    RobotRunLoopContext *theContext = [[RobotRunLoopContext alloc] initWithSource:obj andLoop:rl];

    [del performSelectorOnMainThread:@selector(removeSource:)
                          withObject:theContext waitUntilDone:YES];
}

@interface RobotRunLoopSource ()

@property (strong) NSLock *commandsLock;

@end


@implementation RobotRunLoopSource

- (id)init;
{
    self = [super init];
    if (self) {
        CFRunLoopSourceContext    context = {0, (__bridge void *)(self), NULL, NULL, NULL, NULL, NULL,
            &RunLoopSourceScheduleRoutine,
            RunLoopSourceCancelRoutine,
            RunLoopSourcePerformRoutine};

        runLoopSource = CFRunLoopSourceCreate(NULL, 0, &context);
        commands = [[NSMutableArray alloc] init];
        _commandsLock = [[NSLock alloc] init];
    }
    return self;
}

- (void)addToCurrentRunLoop;
{
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopAddSource(runLoop, runLoopSource, kCFRunLoopDefaultMode);
}

- (void)invalidate;
{
    CFRunLoopSourceInvalidate(runLoopSource);
}

// Handler method
- (void)sourceFired;
{
    NSLog(@"source fired");
    [self.commandsLock lock];

    // do fun stuff with the data
    NSString *command = (NSString *)commands.lastObject;
    NSLog(@"the command content: [%@]", command);
    
    [self.commandsLock unlock];
}

// Client interface for registering commands to process
- (void)addCommand:(NSInteger)command withData:(id)data;
{
    [self.commandsLock lock];

    [commands addObject:data];

    [self.commandsLock unlock];
}

- (void)fireAllCommandsOnRunLoop:(CFRunLoopRef)runloop;
{
    CFRunLoopSourceSignal(runLoopSource);
    CFRunLoopWakeUp(runloop);
}

@end

