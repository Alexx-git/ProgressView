//
//  VDCircularTicksProgressView.h
//  ProgressViewTest
//
//  Created by VLADIMIR on 12/17/17.
//  Copyright © 2017 VLADIMIR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VDCircularTicksProgressView : UIView

@property (assign, nonatomic) CGFloat progress;
@property (assign, nonatomic) CGFloat radius;
@property (assign, nonatomic) NSInteger totalDotsCount;
@property (strong, nonatomic) UIImage * backgroundImage;
@property (strong, nonatomic) UIImage * onDotImage;
@property (strong, nonatomic) UIImage * offDotImage;
@property (strong, nonatomic) UIFont *hintTextFont;
@property (strong, nonatomic) UIColor *hintTextColor;

+(id)CircularTicksProgressView;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated duration:(CGFloat)duration;

@end
