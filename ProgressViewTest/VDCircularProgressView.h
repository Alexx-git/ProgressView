//
//  VDCircularProgressView.h
//  ProgressViewTest
//
//  Created by VLADIMIR on 12/17/17.
//  Copyright © 2017 VLADIMIR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDCircularTicksProgressView.h"

@interface VDCircularProgressView : UIView

//@property (assign, nonatomic) CGFloat inset;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated duration:(CGFloat)duration;

@end
