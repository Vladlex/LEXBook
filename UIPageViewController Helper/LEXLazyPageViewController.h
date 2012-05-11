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
    UIColor *pageColor_;
    
    UILabel *pageNumberLabel;
    
    
    
}
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, retain) UIColor *pageColor;
@property (nonatomic, retain) UILabel *centerLabel;

@property (nonatomic, readonly) NSInteger uniqueNum;

+ (id)pageWithRandomColor;

@end
