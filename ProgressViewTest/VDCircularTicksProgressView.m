//
//  TestProgressView.m
//  ProgressViewTest
//
//  Created by VLADIMIR on 12/17/17.
//  Copyright © 2017 VLADIMIR. All rights reserved.
//

#import "VDCircularTicksProgressView.h"
#import <math.h>

#define LargeHintTextFont [UIFont fontWithName:@"OpenSans-Regular" size:22.0f]
#define SmallHintTextFont [UIFont fontWithName:@"OpenSans-Regular" size:15.0f]

#define DefaultHintTextColor RGB(41.0, 93.0, 117.0);

static CGRect const FSDefaultFrame = {0, 0, 78, 78};

static CGFloat const FSRoundValue = 1000;
static CGFloat const FSProgressZero = 0.0;
static CGFloat const FSDefaultRadius = 36.0;
static NSInteger const FSDefaultDotsCount = 40;

@implementation VDCircularTicksProgressView

+(id)CircularTicksProgressView
{
    VDCircularTicksProgressView * view = [[VDCircularTicksProgressView alloc] initWithFrame:FSDefaultFrame];
    [view setup];
    return view;
}

-(void)setup
{
    self.progress = FSProgressZero;
    self.totalDotsCount = FSDefaultDotsCount;
    self.radius = FSDefaultRadius;
    self.backgroundImage = [UIImage imageNamed:@"progressViewBackground.png"];
    self.onDotImage = [UIImage imageNamed:@"progressFractionImage.png"];
    self.offDotImage = [UIImage imageNamed:@"progressPathFractionImage.png"];
}


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}


- (void)drawViewInRect:(CGRect)rect {
    CGSize onDotSize = self.onDotImage.size;
    CGSize offDotSize = self.offDotImage.size;

    NSInteger counter;
    CGSize size = self.bounds.size;
    NSInteger dotCount = floor(self.totalDotsCount * self.progress);
    CGPoint point;
    CGSize imgSize = self.backgroundImage.size;
    CGPoint imgOrigin = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    imgOrigin.x -= imgSize.width / 2.0;
    imgOrigin.y -= imgSize.height / 2.0;
    [self.backgroundImage drawAtPoint:imgOrigin];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM( context, 0.5f * size.width, 0.5f * size.height );
    float angleStep = 2.0 * M_PI / self.totalDotsCount;
    point = CGPointMake(- onDotSize.width * 0.5, - self.radius - onDotSize.height * 0.5);
    for(counter = 0; counter < dotCount; counter++)
    {
        [self drawOnDotAtPoint:point];
        CGContextRotateCTM(context, angleStep);
    }
    point = CGPointMake(- offDotSize.width * 0.5, - self.radius - offDotSize.height * 0.5);
    if (self.offDotImage != nil)
    {
        for(; counter < self.totalDotsCount; counter++)
        {
            [self drawOffDotAtPoint:point];
            CGContextRotateCTM(context, angleStep);
        }
    }
}

-(void)drawOnDotAtPoint:(CGPoint)point
{
    [self.onDotImage drawAtPoint:point];
}

-(void)drawOffDotAtPoint:(CGPoint)point
{
    [self.offDotImage drawAtPoint:point];
}

- (void)drawRect:(CGRect)rect {
    [self drawViewInRect:rect];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated duration:(CGFloat)duration {
    if (animated) {
        CGFloat dif = fabs(progress - self.progress);
        dif = floor(dif * FSRoundValue) / FSRoundValue;
        CGFloat pace = 1.0 / self.totalDotsCount;
        pace = floor(pace * FSRoundValue) / FSRoundValue;
        
        NSInteger iterationsCount = self.totalDotsCount * dif;
        CGFloat iterationduration = duration / iterationsCount;
        iterationduration = floor(iterationduration * FSRoundValue) / FSRoundValue;
        [self updateProgressFrom:self.progress to:progress duration:iterationduration pace:pace];
        
    } else {
        _progress = progress;
        [self.layer setNeedsDisplay];
    }
}

- (void)updateProgressFrom:(CGFloat)fromProgress
                        to:(CGFloat)toProgress
                  duration:(CGFloat)duration
                      pace:(CGFloat)pace {
    if (fromProgress > toProgress) {
        if (_progress - pace/2 < toProgress) {
            return;
        }
        _progress = fromProgress - pace;
        
    } else {
        if (_progress + pace/2 > toProgress) {
            return;
        }
        _progress = fromProgress + pace;
    }
    
    [self.layer setNeedsDisplay];
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [weakSelf updateProgressFrom:self->_progress to:toProgress duration:duration pace:pace];
    });
}


@end
