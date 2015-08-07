//
//  AppDelegate.h
//  MultiThreadedSpike
//
//  Created by Jin on 8/4/15.
//  Copyright (c) 2015 Baek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RobotRunLoopSource.h"
#import "RobotRunLoopContext.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)registerSource:(RobotRunLoopContext *)robotRunLoopContext;
- (void)removeSource:(RobotRunLoopContext *)robotRunLoopContext;

- (void)pingSource;
- (void)stopSource;
@end

