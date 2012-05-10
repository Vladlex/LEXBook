//
//  LEXPageProtocol.h
//  UIPageViewController Helper
//
//  Created by iTech on 10.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LEXReusablePageProtocol <NSObject>

// You should return value that you have been recieve in 'setPageNumberForLEXBook:' method
- (NSInteger)pageNumberForLEXBook;

// Save the value into an ivar and return this value in 'pageNumberForLEXBook'.
// You also can use this method to show actual page number.
- (void)setPageNumberForLEXBook:(NSInteger)pageNumber;

@end