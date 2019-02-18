//
//  ATViewController.m
//  Ant
//
//  Created by huluobo on 02/13/2019.
//  Copyright (c) 2019 huluobo. All rights reserved.
//

#import "ATViewController.h"
#import <Ant/Ant.h>
#import "PublicServices.h"

@interface ATViewController () {
    dispatch_queue_t _ioQueue;
}

@end

@implementation ATViewController



- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClicked:(id)sender {
    id <TestService> obj = [Ant serviceImplFromProtocol:@protocol(TestService)];
    [obj service1];
}

@end
