//
//  ITCHBookDelegate.h
//  UIPageViewController Helper
//
//  Created by Vladlex on 10.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
// This protocols are used instead standart UIPageViewControllerDelegate and UIPageViewControllerDataSource protocols.
// 

#import "LEXReusablePageProtocol.h"

@class LEXBook;

@protocol LEXBookDataSource <NSObject>

// Data source
- (NSInteger)numberOfPagesInBook:(LEXBook*)book forOrientation:(UIInterfaceOrientation)orientation;
- (UIViewController <LEXReusablePageProtocol> *)pageInBook:(LEXBook*)book forPageNumber:(NSInteger)pageNumber forOrientation:(UIInterfaceOrientation)orientation;

@optional
// This method called only if number of featured pages for source and target orientation is equal.
// In other case 'pageInBook:forPageNumber' called.
- (BOOL)book:(LEXBook *)book shouldReloadPagesWhenChangeOrientationFrom:(UIInterfaceOrientation)fromOrientation to:(UIInterfaceOrientation)toOrientation;

@optional
- (BOOL)book:(LEXBook *)book shouldAutomaticallyFindNeededPageWhenRotateTo:(UIInterfaceOrientation)orientation fromPageWithNumber:(NSInteger)pageNumber;
- (NSInteger)book:(LEXBook *)book shouldLeafToPageWithNumberWhenRotateToOrientation:(UIInterfaceOrientation)orientation fromPageWithNumber:(NSInteger)pageNumber;
@end

@protocol LEXBookDelegate <NSObject>
@optional
- (void)book:(LEXBook *)book didLeafToPageWithNumber:(NSInteger)pageNumber;
- (void)book:(LEXBook *)book cancelLeafToPageWithNumber:(NSInteger)canceledPageNumber returnToPageWithNumber:(NSInteger)actualPageNumber;
- (BOOL)book:(LEXBook *)book shouldAnimatePagesReloadingWhenChangeOrientationFrom:(UIInterfaceOrientation)fromOrientation to:(UIInterfaceOrientation)toOrientation;

- (void)book:(LEXBook *)book willRotateToOrientation:(UIInterfaceOrientation)orientation;
@end



