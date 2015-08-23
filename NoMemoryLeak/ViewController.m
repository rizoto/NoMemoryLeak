//
//  ViewController.m
//  NoMemoryLeak
//
//  Created by Lubor Kolacny on 7/08/2015.
//  Copyright (c) 2015 Lubor Kolacny. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+NoMemoryLeak.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake)
    {
        NSLog(@"NSObject counter: %ld", (long)[NSObject getCounter]);
        [NSObject printWithClasses:@[@"TestClass" ,@"NSObject" ,@"ModalViewController" ,@"ImagePickerPopoverController" ,@"UIActionSheet", @"UIAlertController"]];
    }
}

@end
