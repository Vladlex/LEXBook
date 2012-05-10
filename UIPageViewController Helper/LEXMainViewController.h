//
//  LEXViewController.h
//  UIPageViewController Helper
//
//  Created by Vladlex on 09.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LEXBookDelegateAndDataSource.h"

@class LEXBook;

@interface LEXMainViewController : UIViewController <LEXBookDataSource, LEXBookDelegate> {
//    UIPageViewController *pageViewController;
    LEXBook *sampleBook;
}


@end
