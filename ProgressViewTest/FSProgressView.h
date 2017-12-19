//
//  FSProgressView.h
//  FahrschuleStudent
//
//  Created by Stanislav on 11/29/17.
//  Copyright © 2017 BrightGrove. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FSProgressView;

@protocol FSProgressViewDelegate <NSObject>
@optional
- (void)progressView:(FSProgressView *)progressView
   didChangeProgress:(CGFloat)progress
       percentString:(NSString *)persentString;
@end

typedef NS_ENUM(NSUInteger, FSProgressViewSize) {
    FSProgressViewSizeSmall,
    FSProgressViewSizeLarge,
};

@interface FSProgressView : UIView

@property (weak, nonatomic) id <FSProgressViewDelegate> delegate;

@property (assign, nonatomic) CGFloat progress;
@property (assign, nonatomic) CGFloat radius;
@property (assign, nonatomic) NSInteger totalDotsCount;
@property (strong, nonatomic) UIImage * backgroundImage;
@property (strong, nonatomic) UIImage * onDotImage;
@property (strong, nonatomic) UIImage * offDotImage;
@property (strong, nonatomic) UIFont *hintTextFont;
@property (strong, nonatomic) UIColor *hintTextColor;
@property (assign, nonatomic) FSProgressViewSize size;

+ (instancetype)progressViewForSize:(FSProgressViewSize)size;

+ (instancetype)defaultLargeProgressView;
+ (instancetype)defaultSmallProgressView;

- (void)setupLargeProgressView; // Default
- (void)setupSmallProgressView;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated duration:(CGFloat)duration;

@end
