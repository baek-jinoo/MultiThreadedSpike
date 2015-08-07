//
//  ViewController.m
//  MultiThreadedSpike
//
//  Created by Jin on 8/4/15.
//  Copyright (c) 2015 Baek. All rights reserved.
//

#import "ViewController.h"
#import "MultiThreadManager.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController
- (IBAction)cancelPressed:(id)sender {
    NSLog(@"cancel pressed");
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate stopSource];
}

- (IBAction)buttonPressed:(id)sender {
    NSLog(@"button pressed");
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate pingSource];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    MultiThreadManager *multiThreadManager =[[MultiThreadManager alloc] init];

//    [multiThreadManager createThread];
}

@end
