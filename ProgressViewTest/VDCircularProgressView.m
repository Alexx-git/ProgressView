//
//  VDCircularProgressView.m
//  ProgressViewTest
//
//  Created by VLADIMIR on 12/17/17.
//  Copyright © 2017 VLADIMIR. All rights reserved.
//

#import "VDCircularProgressView.h"

@interface VDCircularProgressView()

@property (assign, nonatomic) CGFloat relativeRadius;
//@property (assign, nonatomic) CGFloat inset;
@property (strong, nonatomic) VDCircularTicksProgressView * ticksView;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated duration:(CGFloat)duration;

@end

@implementation VDCircularProgressView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupTicksView];
    }
    return self;
}

-(void)setupTicksView
{
        self.ticksView = [VDCircularTicksProgressView CircularTicksProgressView];
        [self addSubview:self.ticksView];
        self.ticksView.frame = self.bounds;
        self.ticksView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        self.ticksView.radius = self.bounds.height * 0.5 - self.inset;
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated duration:(CGFloat)duration
{
    [self.ticksView setProgress:progress animated:animated duration:duration];
}

@end
