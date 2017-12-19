//
//  ViewController.m
//  ProgressViewTest
//
//  Created by VLADIMIR on 12/15/17.
//  Copyright © 2017 VLADIMIR. All rights reserved.
//

#import "ViewController.h"
#import "FSProgressView.h"
#import "VDCircularProgressView.h"

@interface ViewController ()

@property (strong, nonatomic) VDCircularProgressView * progressView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.progressView = [VDCircularProgressView new];
    [self.view addSubview:self.progressView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startProgress:(id)sender
{
    
    [self.progressView setProgress:0.8 animated:YES duration:10.0];
}


@end
