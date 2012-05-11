//
//  LEXBook.h
//  UIPageViewController Helper
//
//  Created by Vladlex on 10.05.12.
//  Copyright (c) 2012 iTech Devs. Gordeev Alexey. All rights reserved.
//
//  Book is a UIPageViewController helper that make work with UIPageViewController data source and delegate methods easier.
//
//  By the Page we mean any UIViewController that conform LEXReusablePageProtocol protocol.

#import <Foundation/Foundation.h>

#import "LEXBookDelegateAndDataSource.h"

@class LEXReusablePageManager;

typedef enum NSInteger {
    LEXBookOrientationPageSchemeOnePageLeftSided,
    LEXBookOrientationPageSchemeOnePageRightSided,
    LEXBookOrientationPageSchemeTwoPagesLeftSided,
    LEXBookOrientationPageSchemeTwoPagesRightSided,
    LEXBookOrientationPageSchemeTwoPagesDoubleSided
} LEXBookOrientationPageScheme;


@interface LEXBook : NSObject <UIPageViewControllerDataSource, UIPageViewControllerDelegate> {
    
    id <LEXBookDelegate> delegate_;
    id <LEXBookDataSource> dataSource_;

    
    @private
    NSMutableArray *orientationSchemes;
    LEXReusablePageManager *pageManager;
}
@property (nonatomic, assign) UIPageViewController *pageViewController;

@property (nonatomic, assign) id <LEXBookDataSource> dataSource;
@property (nonatomic, assign) id <LEXBookDelegate> delegate;

@property (nonatomic, readonly) BOOL useReusablePages;

@property (nonatomic, assign, getter = isShowBackOfLastPageIfPageIsDoubleSided) BOOL showBackOfLastPageIfPageIsDoubleSided;

- (id)initWithUsingReusablePages:(BOOL)useReusablePages;

// You can pass 'nil' as identifier. In this case identifier will be automatically changed to @Page".
- (UIViewController <LEXReusablePageProtocol> *)dequeueReusablePage;

- (NSArray*)featuredPages;

// If double sided then return first page number. If no pages shown return NSNotFound
- (NSInteger)currentPageNumber;

- (void)reloadPagesAnimated:(BOOL)animated animationDirection:(UIPageViewControllerNavigationDirection)animationDirection;
- (void)leafToPageWithPageNumber:(NSInteger)pageNumber animated:(BOOL)animated;
- (void)leafToPageWithPageNumber:(NSInteger)pageNumber animated:(BOOL)animated forcedAnimationDirection:(UIPageViewControllerNavigationDirection)animationDirection;

- (BOOL)pageWithNumberCanBeFeatured:(NSInteger)pageNumber orientation:(UIInterfaceOrientation)orientation;
- (UIPageViewControllerSpineLocation)spineLocationForPageScheme:(LEXBookOrientationPageScheme)pageScheme;
- (NSInteger)numberOfFeaturedPagesForOrientation:(UIInterfaceOrientation)orientation;


// Page orientation settings methods
- (void)setPageScheme:(LEXBookOrientationPageScheme)orientationScheme forOrientation:(UIInterfaceOrientation)orientation;
- (LEXBookOrientationPageScheme)pageSchemeForOrientation:(UIInterfaceOrientation)orientation;
- (void)setPageSchemeForLanscapeOrientation:(LEXBookOrientationPageScheme)orientationScheme;
- (void)setPageSchemeForPortraitOrientation:(LEXBookOrientationPageScheme)orientationScheme;

@end
