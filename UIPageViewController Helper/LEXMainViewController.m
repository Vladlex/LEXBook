//
//  LEXViewController.m
//  UIPageViewController Helper
//
//  Created by Vladlex on 09.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LEXMainViewController.h"

#import "LEXBook.h"
#import "LEXLazyPageViewController.h"

@interface LEXMainViewController ()

@end

@implementation LEXMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil 
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        sampleBook = [[LEXBook alloc] initWithUsingReusablePages:YES];
        sampleBook.delegate = self;
        sampleBook.dataSource = self;
        numberOfItems = 10;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    
    // This is standart UIPageViewController initialization and configuring block
    UIPageViewController *pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                                               navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                                             options:nil];
    pageViewController.view.frame = CGRectInset(self.view.bounds, 20.0, 20.0);
    pageViewController.view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:pageViewController.view];
    // Do not forget add UIPageViewController object as a child view controller for root controller.
    [self addChildViewController:pageViewController];
    // Do not forget notify UIPageViewController object that he have been added to parent view controller
    [pageViewController didMoveToParentViewController:self];
    
    
    // This is abnormal part. Prepare to big piece of code.
    // Set the book as provider for page view controller.
    [sampleBook setPageViewController:pageViewController];
    // Leaf book to first (zero-indexed) page
    [sampleBook leafToPageWithPageNumber:0 animated:YES];
    // Ooomph, this is over. Now you can relax.   
    
    [pageViewController release];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (NSInteger)itemsPerPageForOrientation:(UIInterfaceOrientation)orientation {
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        return 2;
    }
    return 4;
}

- (NSInteger)numberOfAllItems {
    return numberOfItems;
}

#pragma mark Book data source

- (NSInteger)numberOfPagesInBook:(LEXBook *)book 
                  forOrientation:(UIInterfaceOrientation)orientation{
    NSInteger itemsPerPage = [self itemsPerPageForOrientation:orientation];
    NSInteger numberOfPages = numberOfItems / itemsPerPage;
    if (numberOfItems % [self itemsPerPageForOrientation:orientation] != 0) {
        numberOfPages ++;
    }
    return numberOfPages;
}

- (UIViewController <LEXReusablePageProtocol> *)pageInBook:(LEXBook *)book 
                                             forPageNumber:(NSInteger)pageNumber 
                                            forOrientation:(UIInterfaceOrientation)orientation
{
    LEXLazyPageViewController *page = (LEXLazyPageViewController*)[book dequeueReusablePage];
    BOOL isCreated = NO;
    if (!page) {
        isCreated = YES;
        page = [LEXLazyPageViewController pageWithRandomColor];
    }
    // Configuring
    NSString *configuringText = [NSString stringWithFormat:@"This page #%d is%@ configured at %@ \nfor page number %d.",
                                 page.uniqueNum,
                                 (isCreated == NO)? @" reusable-sourced \nand" : @"",
                                 [NSDate date],
                                 pageNumber];
    page.centerLabel.text =  configuringText;
    return page;
}

- (NSInteger)book:(LEXBook *)book shouldLeafToPageWithNumberWhenRotateToOrientation:(UIInterfaceOrientation)orientation fromPageWithNumber:(NSInteger)pageNumber
{
    UIInterfaceOrientation actualOrientation = book.pageViewController.interfaceOrientation;
    NSInteger firstShowingItemIndex = pageNumber * [self itemsPerPageForOrientation:actualOrientation];
    NSInteger newPageNumber = firstShowingItemIndex / [self itemsPerPageForOrientation:orientation];
    return newPageNumber;
}

- (BOOL)book:(LEXBook *)book shouldAutomaticallyFindNeededPageWhenRotateTo:(UIInterfaceOrientation)orientation fromPageWithNumber:(NSInteger)pageNumber
{
    UIInterfaceOrientation actualOrientation = book.pageViewController.interfaceOrientation;
    BOOL actualOrientationIsLandcsape = UIInterfaceOrientationIsLandscape(actualOrientation);
    BOOL futureOrientationIsLandscape = UIInterfaceOrientationIsLandscape(orientation);
    if (actualOrientationIsLandcsape == futureOrientationIsLandscape) {
        return YES;
    }
    return NO;
}

#pragma mark Book delegate

- (void)book:(LEXBook *)book didLeafToPageWithNumber:(NSInteger)pageNumber
{

}

- (void)book:(LEXBook *)book cancelLeafToPageWithNumber:(NSInteger)canceledPageNumber returnToPageWithNumber:(NSInteger)actualPageNumber 
{
    
}

- (void)book:(LEXBook *)book willRotateToOrientation:(UIInterfaceOrientation)orientation {
    
}

@end
