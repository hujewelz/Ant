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

@interface ATViewController ()

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
    id <TestService> s = [Ant serviceImplFromeService:@protocol(TestService)];
    [s test];
}

@end
