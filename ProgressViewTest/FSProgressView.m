//
//  FSProgressView.m
//  FahrschuleStudent
//
//  Created by Stanislav on 11/29/17.
//  Copyright © 2017 BrightGrove. All rights reserved.
//

#import "FSProgressView.h"
//#import "FSAppearanceManager.h"
#import <math.h>

#define LargeHintTextFont [UIFont fontWithName:@"OpenSans-Regular" size:22.0f]
#define SmallHintTextFont [UIFont fontWithName:@"OpenSans-Regular" size:15.0f]

#define DefaultHintTextColor RGB(41.0, 93.0, 117.0);

static CGRect const FSDefaultFrame = {0, 0, 78, 78};
static CGRect const FSSmallFrame = {0, 0, 50, 50};

static CGFloat const FSRoundValue = 1000;
static CGFloat const FSProgressZero = 0.0;
static CGFloat const FSDefaultRadius = 36.0;
static NSInteger const FSDefaultDotsCount = 35;
static CGFloat const FSSmallRadius = 21.0;
static NSInteger const FSSmallDotsCount = 35;

@implementation FSProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    return self;
}

+ (instancetype)progressViewForSize:(FSProgressViewSize)size {
    FSProgressView *view;
    switch (size) {
        case FSProgressViewSizeLarge:
            view = [FSProgressView defaultLargeProgressView];
            break;
        case FSProgressViewSizeSmall:
            view = [FSProgressView defaultSmallProgressView];

            break;
        default:
            break;
    }
    return view;
}

+ (instancetype)defaultLargeProgressView {
    FSProgressView *view = [[FSProgressView alloc] initWithFrame:FSDefaultFrame];
    [view setupLargeProgressView];
    
    return view;
}

+ (instancetype)defaultSmallProgressView {
    FSProgressView *view = [[FSProgressView alloc] initWithFrame:FSSmallFrame];
    [view setupSmallProgressView];
    
    return view;
}

- (void)setupLargeProgressView {
    self.progress = FSProgressZero;
    self.totalDotsCount = FSDefaultDotsCount;
    self.radius = FSDefaultRadius;
    self.size = FSProgressViewSizeLarge;
    self.backgroundImage = [UIImage imageNamed:@"progressViewBackground.png"];
    self.onDotImage = [UIImage imageNamed:@"progressFractionImage.png"];
    self.offDotImage = [UIImage imageNamed:@"progressPathFractionImage.png"];
}

- (void)setupSmallProgressView {
    self.progress = FSProgressZero;
    self.totalDotsCount = FSSmallDotsCount;
    self.radius = FSSmallRadius;
    self.size = FSProgressViewSizeSmall;
    self.backgroundImage = [UIImage imageNamed:@"progressViewBackgroundSmall.png"];
    self.onDotImage = [UIImage imageNamed:@"progressFractionImageSmall.png"];
    self.offDotImage = [UIImage imageNamed:@"progressPathFractionImageSmall.png"];
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
    UIImage * img = self.onDotImage;
    for(counter = 0; counter < dotCount; counter++)
    {
        [img drawAtPoint:point];
        CGContextRotateCTM(context, angleStep);
    }
    point = CGPointMake(- offDotSize.width * 0.5, - self.radius - offDotSize.height * 0.5);
    img = self.offDotImage;
    if (img != nil){
        for(; counter < self.totalDotsCount; counter++)
        {
            [img drawAtPoint:point];
            CGContextRotateCTM(context, angleStep);
        }
    }
    CGPoint innerCenter = CGPointMake( CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2);
    [self drawPercentLabel:innerCenter];
    
    if ([self.delegate respondsToSelector:@selector(progressView:didChangeProgress:percentString:)]) {
        [self.delegate progressView:self didChangeProgress:_progress percentString:[self stringFromProgress:_progress]];
    }
}

- (void)drawRect:(CGRect)rect {
    [self drawViewInRect:rect];
}

- (CGFloat)normalizedProgress:(CGFloat)progress {
    progress = MIN(progress, 1);
    progress = MAX(progress, 0);
    return progress;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)setTotalDotsCount:(NSInteger)totalDotsCount {
    _totalDotsCount = totalDotsCount;
    [self setNeedsDisplay];
}

- (void)setRadius:(CGFloat)radius {
    _radius = radius;
    [self setNeedsDisplay];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    [self setNeedsDisplay];
}

- (void)setOnDotImage:(UIImage *)onDotImage {
    _onDotImage = onDotImage;
    [self setNeedsDisplay];
}

- (void)setOffDotImage:(UIImage *)offDotImage {
    _offDotImage = offDotImage;
    [self setNeedsDisplay];
}

#pragma mark - Percents label 

- (void)drawPercentLabel:(CGPoint)center {
    //UIFont *percentsFont = (self.size == FSProgressViewSizeLarge) ? LargeHintTextFont : SmallHintTextFont;
    //UIFont * percentsFont = SmallHintTextFont;
    UIFont * percentsFont = [UIFont systemFontOfSize:15.0f];
    //UIColor *color = FSAppearanceManager.primaryDarkBlueColor;
    UIColor * color = [UIColor blueColor];
    NSString *progressString = [self stringFromProgress:_progress];
    
    CGSize percentTextSize = [progressString boundingRectWithSize:CGSizeZero
                                                          options:NSStringDrawingUsesFontLeading
                                                       attributes:@{NSFontAttributeName: percentsFont, NSForegroundColorAttributeName: color}
                                                          context:nil].size;
    /* NOTE: Not sure why this things are happening but the text is drawn not correctly for different string lengths.
       This workaround adjusts the center.
     p.s. I know this is not very good solution ))
     */
    
    CGFloat shift = 0.0;
    if (_progress < 0.1) {
        shift = self.size == FSProgressViewSizeLarge ? percentTextSize.width/4 : percentTextSize.width/6;
    } else if (_progress > 0.1 && _progress < 1.0) {
        shift = 0;
    } else if (_progress >= 1.0) {
        shift = self.size == FSProgressViewSizeLarge ? -percentTextSize.width/8 : -percentTextSize.width/6;
    }

    CGPoint textCenterPoint = CGPointMake(-center.x/2 + shift, -center.y/2 + 2.0);
    [progressString drawAtPoint:textCenterPoint
                 withAttributes:@{NSFontAttributeName: percentsFont, NSForegroundColorAttributeName: color}];
}

- (NSString*)stringFromProgress:(CGFloat)progress {
    CGFloat normalized = [self normalizedProgress:progress] * 100;

    return [NSString stringWithFormat:@"%.0f%%", normalized];
    
}
#pragma mark - Animate progress

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
