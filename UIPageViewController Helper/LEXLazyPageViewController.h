//
//  LEXLazyPageViewController.h
//  UIPageViewController Helper
//
//  Created by iTech on 10.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LEXReusablePageProtocol.h"

@interface LEXLazyPageViewController : UIViewController <LEXReusablePageProtocol> {
    NSInteger pageNumber_;
    
    UIColor *pageColor_;
    
    UILabel *pageNumberLabel;
}
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, retain) UIColor *pageColor;

+ (id)pageWithRandomColor;

@end
