//
//  UIColor+RandomColor.h
//  Zuma Menu
//
//  Created by iTech on 04.05.12.
//  Copyright (c) 2012 iTech Devs. Gordeev Alexey .All rights reserved.
//
//  Fast and easy random color getting

#import <UIKit/UIKit.h>

@interface UIColor (RandomColor)
+ (UIColor*)randomColor;
+ (UIColor*)randomColorWithAlpha:(float)alpha;
+ (UIColor*)randomColorWithRandomAlpha;
@end

#import "UIColor+RandomColor.h"

@implementation UIColor (RandomColor)

+ (UIColor*)randomColorWithAlpha:(float)alpha {
    CGFloat red =  (float)arc4random()/(float)RAND_MAX;
    CGFloat blue = (float)arc4random()/(float)RAND_MAX;
    CGFloat green = (float)arc4random()/(float)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor*)randomColorWithRandomAlpha {
    CGFloat alpha =  (float)arc4random()/(float)RAND_MAX;
    return [UIColor randomColorWithAlpha:alpha];
}

+ (UIColor*)randomColor {
    return [self randomColorWithAlpha:1.0];
}

@end
