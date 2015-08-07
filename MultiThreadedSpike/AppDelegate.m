//
//  AppDelegate.m
//  MultiThreadedSpike
//
//  Created by Jin on 8/4/15.
//  Copyright (c) 2015 Baek. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (strong) NSMutableArray *sourcesToPing;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.sourcesToPing = [NSMutableArray array];
    _sourcesToPing = [NSMutableArray array];

    NSThread *worker = [[NSThread alloc] initWithTarget:self
                                      selector:@selector(workerThread:)
                                        object:self];
    [worker start];
    return YES;
}

//------------------------------------------------------------------------------
- (void)pingSource;
{
    if (_sourcesToPing.count) {
        RobotRunLoopContext* sourceCtx = _sourcesToPing[0];

        [sourceCtx.source addCommand:0 withData:@"bla"];

        [sourceCtx.source fireAllCommandsOnRunLoop:sourceCtx.runLoop];
    }
}

- (void)stopSource;
{
    if (_sourcesToPing.count) {
        RobotRunLoopContext* sourceCtx = _sourcesToPing[0];
        [sourceCtx.source invalidate];
    }
}

- (void)registerSource:(RobotRunLoopContext *)robotRunLoopContext;
{
    [self.sourcesToPing addObject:robotRunLoopContext];
}

- (void)removeSource:(RobotRunLoopContext *)robotRunLoopContext;
{
    id    objToRemove = nil;

    for (RobotRunLoopContext* context in self.sourcesToPing)
    {
        if ([context isEqual:robotRunLoopContext])
        {
            objToRemove = context;
            break;
        }
    }

    if (objToRemove) {
        [self.sourcesToPing removeObject:objToRemove];
    }
}


- (void) workerThread: (id) data
{
    NSLog(@"Enter worker thread");
    // Set up an autorelease pool here if not using garbage collection.
    BOOL done = NO;

    // Add your sources or timers to the run loop and do any other setup.
    RobotRunLoopSource* customRunLoopSource = [[RobotRunLoopSource alloc] init];
    [customRunLoopSource addToCurrentRunLoop];

    do
    {
        // Start the run loop but return after each source is handled.
        SInt32 result = CFRunLoopRunInMode(kCFRunLoopDefaultMode, 5, YES);

        // If a source explicitly stopped the run loop, or if there are no
        // sources or timers, or our runloopSource is invalid ->
        // go ahead and exit.
        if ((result == kCFRunLoopRunStopped) || (result == kCFRunLoopRunFinished)) {
            done = YES;
        }
    }
    while (!done);

    // Clean up code here. Be sure to release any allocated autorelease pools.
    NSLog(@"Exit worker thread");
}
@end
