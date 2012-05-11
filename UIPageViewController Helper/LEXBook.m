//
//  LEXBook.m
//  UIPageViewController Helper
//
//  Created by Vladlex on 10.05.12.
//  Copyright (c) 2012 iTech Devs. Gordeev Alexey. All rights reserved.
//

#import "LEXBook.h"

#import "LEXReusablePageProtocol.h"

#import "LEXReusablePageManager.h"

@interface LEXBook ()
@property (nonatomic, assign) BOOL useReusablePages;

// If asc = YES then need following page. Else need previous page.
- (UIViewController*)nextPageForPage:(UIViewController*)actualPage asc:(BOOL)asc interfaceOrientation:(UIInterfaceOrientation)orientation;
- (UIViewController <LEXReusablePageProtocol> *)pageWithNumber:(NSInteger)pageNumber orientation:(UIInterfaceOrientation)orientation;

- (void)leafToPageWithPageNumber:(NSInteger)pageNumber animated:(BOOL)animated forcedAnimationDirection:(UIPageViewControllerNavigationDirection)animationDirection orientation:(UIInterfaceOrientation)orientation;

- (NSInteger)numberOfPagesInBookForOrientation:(UIInterfaceOrientation)orientation;

- (BOOL)doubleSidedForOrientation:(UIInterfaceOrientation)orientation;
@end

@implementation LEXBook
@synthesize pageViewController = pageViewController_;
@synthesize showBackOfLastPageIfPageIsDoubleSided = showBackOfLastPageIfPageIsDoubleSided_;
@synthesize dataSource = dataSource_, delegate = delegate_;
@synthesize useReusablePages = useReusablePages_;

- (void)dealloc {
    [pageViewController_ release];
    pageViewController_ = nil;
    [orientationSchemes release];
    [pageManager release];
    [super dealloc];
}

- (id)init
{
    return [self initWithUsingReusablePages:NO];
}

- (id)initWithUsingReusablePages:(BOOL)useReusablePages {
    self = [super init];
    if (self != nil) {
        // Default orientation
        orientationSchemes = [[NSMutableArray alloc] initWithObjects: 
                              [NSNumber numberWithInteger:LEXBookOrientationPageSchemeOnePageLeftSided],  // Portrait
                              [NSNumber numberWithInteger:LEXBookOrientationPageSchemeOnePageLeftSided],  // Portrait upside down
                              [NSNumber numberWithInteger:LEXBookOrientationPageSchemeTwoPagesDoubleSided],  // Lanscape left
                              [NSNumber numberWithInteger:LEXBookOrientationPageSchemeTwoPagesDoubleSided],  // Landscape right
                              nil];
        pageManager = [[LEXReusablePageManager alloc] init];
        self.showBackOfLastPageIfPageIsDoubleSided = YES;
        self.useReusablePages = useReusablePages;
    }
    return self;
}

- (void)setPageViewController:(UIPageViewController *)newPageViewController {
    if (pageViewController_ != newPageViewController) {
        if (pageViewController_) {
            if (pageViewController_.delegate == self) {
                pageViewController_.delegate = nil;
            }
            if (pageViewController_.dataSource == self) {
                pageViewController_.dataSource = nil;
            }
            [pageViewController_ release];
        }
        pageViewController_ = [newPageViewController retain];
        if (pageViewController_) {
            pageViewController_.delegate = self;
            pageViewController_.dataSource = self;
        }
    }
}

#pragma mark -
#pragma mark Public methods

- (UIViewController <LEXReusablePageProtocol> *)dequeueReusablePage 
{
    if (self.useReusablePages == NO) {
        return nil;
    }
    id page = [pageManager dequeueReusablePage];
    return page;
}

- (NSInteger)currentPageNumber 
{
    NSArray *pages = [self featuredPages];
    if (pages == nil || pages.count == 0) {
        return NSNotFound;
    }
    UIViewController <LEXReusablePageProtocol> *page = [pages objectAtIndex:0];
    return [page pageNumberForLEXBook];
}

- (NSArray*)featuredPages 
{
    return [self.pageViewController viewControllers];
}

- (UIPageViewControllerSpineLocation)spineLocationForPageScheme:(LEXBookOrientationPageScheme)pageScheme
{
    UIPageViewControllerSpineLocation spinLocation = 0;
    switch (pageScheme) {
        case LEXBookOrientationPageSchemeOnePageLeftSided:
        case LEXBookOrientationPageSchemeTwoPagesLeftSided:
            spinLocation =  UIPageViewControllerSpineLocationMin;
            break;
        case LEXBookOrientationPageSchemeTwoPagesDoubleSided:
            spinLocation = UIPageViewControllerSpineLocationMid;
            break;
        default:
            spinLocation =  UIPageViewControllerSpineLocationMax;
            break;
    }
    return spinLocation;
}

- (void)reloadPagesAnimated:(BOOL)animated animationDirection:(UIPageViewControllerNavigationDirection)animationDirection
{
    [self leafToPageWithPageNumber:0 animated:animated forcedAnimationDirection:animationDirection];
}

- (void)leafToPageWithPageNumber:(NSInteger)pageNumber 
                        animated:(BOOL)animated
{
    NSInteger currentPageNumber = [self currentPageNumber];
    UIPageViewControllerNavigationDirection animationDirection = UIPageViewControllerNavigationDirectionReverse;
    if (animated == YES && (pageNumber < currentPageNumber)) {
        animationDirection = UIPageViewControllerNavigationDirectionForward;
    }
    [self leafToPageWithPageNumber:pageNumber animated:animated forcedAnimationDirection:animationDirection];
}

- (void)leafToPageWithPageNumber:(NSInteger)pageNumber 
                        animated:(BOOL)animated 
        forcedAnimationDirection:(UIPageViewControllerNavigationDirection)animationDirection
{
    UIInterfaceOrientation bookOrientation = self.pageViewController.interfaceOrientation;
    [self leafToPageWithPageNumber:pageNumber animated:animated forcedAnimationDirection:animationDirection orientation:bookOrientation];
}

- (void)leafToPageWithPageNumber:(NSInteger)pageNumber 
                        animated:(BOOL)animated 
        forcedAnimationDirection:(UIPageViewControllerNavigationDirection)animationDirection 
                        orientation:(UIInterfaceOrientation)orientation
{
    BOOL pageCanBeFeatured = [self pageWithNumberCanBeFeatured:pageNumber orientation:orientation];
    if (pageCanBeFeatured == NO) {
        if (pageNumber<0) {
            pageNumber = 0;
        }
        else {
            pageNumber = [self numberOfPagesInBookForOrientation:orientation]-1;
        }
    }
    
    BOOL doubleSided = [self doubleSidedForOrientation:orientation];
    
    if (doubleSided) {        
        BOOL pageNumberIsOddValue = (pageNumber % 2 == 0) ? NO : YES;
        if (pageNumberIsOddValue == YES) {
            pageNumber = pageNumber - 1;
        }
    }
    
    self.pageViewController.doubleSided = doubleSided;
    
    NSInteger numberOfNeededPages = [self numberOfFeaturedPagesForOrientation:orientation];
    NSMutableArray *newPages = [[NSMutableArray alloc] init];
    for (int newPageIndex = 0; newPageIndex < numberOfNeededPages; newPageIndex ++) {
        UIViewController <LEXReusablePageProtocol> *newPage = [self pageWithNumber:pageNumber+newPageIndex orientation:orientation];
        [newPages addObject:newPage];
    }
    
    NSArray *actualPages = self.pageViewController.viewControllers;
    
    if (self.useReusablePages == YES) {
        if (animated == NO) {
            [pageManager removePagesFromPending:newPages];
            [pageManager addPagesToQueue:actualPages];
        }
    }
    
    [self.pageViewController setViewControllers:[newPages autorelease] direction:animationDirection animated:animated completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(book:didLeafToPageWithNumber:)]) {
            [self.delegate book:self didLeafToPageWithNumber:pageNumber];
        }
        if (self.useReusablePages == YES && animated == YES) {
            // All previous controllers can be added to queue.
            [pageManager addPagesToQueue:actualPages];
            // All current controllers are not pending anymore.
            [pageManager removePagesFromPending:newPages];
        }
        // All previous controllers can be added to queue.
    }];
}

#pragma mark Page orientation settings methods

- (void)setPageScheme:(LEXBookOrientationPageScheme)orientationScheme forOrientation:(UIInterfaceOrientation)orientation
{
    NSInteger orientationIndex = orientation - 1;
    [orientationSchemes replaceObjectAtIndex:orientationIndex withObject:[NSNumber numberWithInteger:orientationScheme]];
}

- (void)setPageSchemeForLanscapeOrientation:(LEXBookOrientationPageScheme)orientationScheme
{
    [self setPageScheme:orientationScheme forOrientation:UIInterfaceOrientationLandscapeLeft];
    [self setPageScheme:orientationScheme forOrientation:UIInterfaceOrientationLandscapeRight];
}

- (void)setPageSchemeForPortraitOrientation:(LEXBookOrientationPageScheme)orientationScheme
{
    [self setPageScheme:orientationScheme forOrientation:UIInterfaceOrientationPortrait];
    [self setPageScheme:orientationScheme forOrientation:UIInterfaceOrientationPortraitUpsideDown];
}

- (LEXBookOrientationPageScheme)pageSchemeForOrientation:(UIInterfaceOrientation)orientation
{
    NSInteger orientationIndex = orientation - 1;
    return [[orientationSchemes objectAtIndex:orientationIndex] integerValue];
}

- (NSInteger)numberOfFeaturedPagesForOrientation:(UIInterfaceOrientation)orientation {
    LEXBookOrientationPageScheme pageScheme = [self pageSchemeForOrientation:orientation];
    if (pageScheme == LEXBookOrientationPageSchemeTwoPagesDoubleSided) { //||
//        pageScheme == LEXBookOrientationPageSchemeTwoPagesLeftSided ||
  //      pageScheme == LEXBookOrientationPageSchemeTwoPagesRightSided) {
        return 2;
    }
    return 1;
}

#pragma mark -
#pragma mark UIPageViewController Data source

- (UIViewController*)pageViewController:(UIPageViewController *)pageViewController 
      viewControllerAfterViewController:(UIViewController *)viewController 
{
    NSAssert1(pageViewController == self.pageViewController, @"Book recieve method from object, that have not owned by this book: %@", NSStringFromSelector(_cmd));
    return [self nextPageForPage:viewController asc:YES interfaceOrientation:pageViewController.interfaceOrientation];
}

- (UIViewController*)pageViewController:(UIPageViewController *)pageViewController 
     viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSAssert1(pageViewController == self.pageViewController, @"Book recieve method from object, that have not owned by this book: %@", NSStringFromSelector(_cmd));
    return [self nextPageForPage:viewController asc:NO interfaceOrientation:pageViewController.interfaceOrientation];
}

#pragma mark UIPageViewController Delegate

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController 
                   spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    NSAssert1(pageViewController == self.pageViewController, @"Book recieve method from object, that have not owned by this book: %@", NSStringFromSelector(_cmd));
    if ([self.delegate respondsToSelector:@selector(book:willRotateToOrientation:)]) {
        [self.delegate book:self willRotateToOrientation:orientation];
    }
    NSInteger currentFeaturedPageNumber = [self currentPageNumber];
    
    BOOL handlyLeafing = NO;
    BOOL needReloading = NO;

    if ([self.dataSource respondsToSelector:@selector(book:shouldAutomaticallyFindNeededPageWhenRotateTo:fromPageWithNumber:)]) {
        if (![self.dataSource book:self shouldAutomaticallyFindNeededPageWhenRotateTo:orientation fromPageWithNumber:currentFeaturedPageNumber]) {
            handlyLeafing = YES;
        }
    }
    if (handlyLeafing) {
        needReloading = YES;
        currentFeaturedPageNumber = [self.dataSource book:self shouldLeafToPageWithNumberWhenRotateToOrientation:orientation fromPageWithNumber:currentFeaturedPageNumber];
    }
    else {
        NSInteger currentNumberOfFeaturedPages = [self numberOfFeaturedPagesForOrientation:pageViewController.interfaceOrientation];
        NSInteger futureNumberOfFeaturedPages = [self numberOfFeaturedPagesForOrientation:orientation];
        if (futureNumberOfFeaturedPages == currentNumberOfFeaturedPages) {
            
            NSInteger numberOfPagesNow = [self numberOfPagesInBookForOrientation:pageViewController.interfaceOrientation];
            NSInteger futureNumberOfPages = [self numberOfPagesInBookForOrientation:orientation];
            if (pageViewController.doubleSided != [self doubleSidedForOrientation:orientation] ||
                numberOfPagesNow != futureNumberOfPages) {
                needReloading = YES;
            }
            else {
                if ([self.dataSource respondsToSelector:@selector(book:shouldReloadPagesWhenChangeOrientationFrom:to:)]) {
                    needReloading = [self.dataSource book:self shouldReloadPagesWhenChangeOrientationFrom:pageViewController.interfaceOrientation to:orientation];
                }
            }
            // No additional calculation needed. Just return existing pages.
        }
        else {
            needReloading = YES;
        }
    }
    if (needReloading) { 
        BOOL shouldAnimate = NO;
        if ([self.delegate respondsToSelector:@selector(book:shouldAnimatePagesReloadingWhenChangeOrientationFrom:to:)]) {
            shouldAnimate = [self.delegate book:self shouldAnimatePagesReloadingWhenChangeOrientationFrom:pageViewController.interfaceOrientation to:orientation];
        }
        [self leafToPageWithPageNumber:currentFeaturedPageNumber 
                              animated:shouldAnimate 
              forcedAnimationDirection:UIPageViewControllerNavigationDirectionReverse 
                           orientation:orientation];
    }
    else {
        pageViewController.doubleSided = [self doubleSidedForOrientation:orientation];
    }
    LEXBookOrientationPageScheme futurePageScheme = [self pageSchemeForOrientation:orientation];
    UIPageViewControllerSpineLocation futureSpinLocation = [self spineLocationForPageScheme:futurePageScheme];
    return futureSpinLocation;
}

- (void)pageViewController:(UIPageViewController *)pageViewController 
        didFinishAnimating:(BOOL)finished 
   previousViewControllers:(NSArray *)previousViewControllers 
       transitionCompleted:(BOOL)completed {
    
    if (finished == YES && completed == YES) {
        if (self.useReusablePages == YES) {
            // Previous pages have been closed
            NSArray *closedPages = previousViewControllers;
            [pageManager addPagesToQueue:closedPages];
            
            // Pending pages becomes an actual.
            NSArray *actualPages = pageViewController.viewControllers;
            [pageManager removePagesFromPending:actualPages];

            // There are some pages can exist, if user very fast thumbs through pages.
            // We must move this pages from pending to queue or remove them
            NSArray *quicklyTurnedPages = pageManager.pendingPages;
            [pageManager movePagesFromPendingToQueue:quicklyTurnedPages];
        }
            }
    if (finished == YES && completed == NO) {
        if (self.useReusablePages == YES) {
            // Actual pages are left actuals
            NSArray *actualPages = previousViewControllers;
            // Pending pages must be added to queue. We can find pending pages
            NSMutableArray *pendingPages = [[pageManager pendingPages] mutableCopy];
            [pendingPages removeObjectsInArray:actualPages];
            [pageManager movePagesFromPendingToQueue:pendingPages];
            [pendingPages release];
        }
    }
}

#pragma mark Private methods

- (UIViewController*)nextPageForPage:(UIViewController *)actualPage asc:(BOOL)asc interfaceOrientation:(UIInterfaceOrientation)orientation
{

    NSAssert1([actualPage conformsToProtocol:@protocol(LEXReusablePageProtocol)] == YES, @"Page (UIViewController) does not conforms LEXReusablePageProtocol: %@", actualPage);
    NSInteger actualPageNumber = [(UIViewController <LEXReusablePageProtocol> *)actualPage pageNumberForLEXBook];
    NSInteger nextPageNumber = (asc == YES) ? actualPageNumber + 1 : actualPageNumber -1;
    BOOL pageCanBeFeatured = [self pageWithNumberCanBeFeatured:nextPageNumber orientation:orientation];
    if (pageCanBeFeatured == NO) {
        return nil;
    }
    // At this moment we can surely say that page at least must exist and be featured (even empty)
    UIViewController *page = [self pageWithNumber:nextPageNumber orientation:orientation];
    return page;
}

- (UIViewController <LEXReusablePageProtocol> *)pageWithNumber:(NSInteger)pageNumber orientation:(UIInterfaceOrientation)orientation
{
    UIViewController <LEXReusablePageProtocol> *page = (UIViewController <LEXReusablePageProtocol> *)[self.dataSource pageInBook:self forPageNumber:pageNumber forOrientation:orientation];
    NSAssert1(page != nil, @"Must recieve configured non-nil page in %@", NSStringFromSelector(_cmd));
    [page setPageNumberForLEXBook:pageNumber];
    if (self.useReusablePages) {
        [pageManager addPageToPending:page];
    }
    return page;
}

-(NSInteger)numberOfPagesInBookForOrientation:(UIInterfaceOrientation)orientation {
    NSInteger numberOfPages = [self.dataSource numberOfPagesInBook:self forOrientation:orientation];
    NSAssert1(numberOfPages > 0, @"Number of pages in book must be more than 0, but it's", numberOfPages);
    return numberOfPages;
}

- (BOOL)pageWithNumberCanBeFeatured:(NSInteger)pageNumber orientation:(UIInterfaceOrientation)orientation {
    if (pageNumber <0) {
        return NO;
    }
    
    NSInteger numberOfPagesInBook = [self numberOfPagesInBookForOrientation:orientation];
    if (pageNumber > numberOfPagesInBook) {
        return NO;
    }
    
    LEXBookOrientationPageScheme pageScheme = [self pageSchemeForOrientation:orientation];
    if ( (pageScheme == LEXBookOrientationPageSchemeOnePageLeftSided ||
          pageScheme == LEXBookOrientationPageSchemeOnePageRightSided ) &&
        pageNumber == numberOfPagesInBook) {
        return NO;
    }
    
    BOOL oneDoubleSidedFeaturedPage = NO;
    if (pageScheme == LEXBookOrientationPageSchemeTwoPagesLeftSided ||
        pageScheme == LEXBookOrientationPageSchemeTwoPagesRightSided) {
        oneDoubleSidedFeaturedPage = YES;
    }
    
    // One doublesided last page case
    if (pageNumber == numberOfPagesInBook - 1 &&
        pageNumber%2 == 0 &&
        oneDoubleSidedFeaturedPage == YES &&
        self.isShowBackOfLastPageIfPageIsDoubleSided == NO
        ) {
        return NO;
    }
    
    if (pageNumber == numberOfPagesInBook) {
        BOOL numberOfAllPagesIsOdd = (numberOfPagesInBook % 2 == 0) ? NO : YES;
        if (pageScheme == LEXBookOrientationPageSchemeTwoPagesDoubleSided &&
            numberOfAllPagesIsOdd == NO) {
            return NO;
        }
        if (oneDoubleSidedFeaturedPage == YES &&
            numberOfAllPagesIsOdd == YES) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)doubleSidedForOrientation:(UIInterfaceOrientation)orientation
{
    LEXBookOrientationPageScheme pageScheme = [self pageSchemeForOrientation:orientation];
    if (pageScheme == LEXBookOrientationPageSchemeTwoPagesDoubleSided ||
        pageScheme == LEXBookOrientationPageSchemeTwoPagesLeftSided ||
        pageScheme == LEXBookOrientationPageSchemeTwoPagesRightSided) {
        return YES;
    }
    return NO;
}

@end
