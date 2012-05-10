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
        sampleBook = [[LEXBook alloc] init];
        sampleBook.delegate = self;
        sampleBook.dataSource = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    
    // This is standart UIPageViewController initialization and configuring block
    /*
    LEXBookOrientationPageScheme pageScheme = [sampleBook pageSchemeForOrientation:self.interfaceOrientation];
    UIPageViewControllerSpineLocation spinLocation = [sampleBook spineLocationForPageScheme:pageScheme];
    
    NSNumber *spinLocationNumber = [NSNumber numberWithInteger:spinLocation];
    NSDictionary *pageViewControllerOptions = [NSDictionary dictionaryWithObject:spinLocationNumber forKey:UIPageViewControllerOptionSpineLocationKey];
    */
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

#pragma mark Book data source

- (NSInteger)numberOfPagesInBook:(LEXBook *)book {
    return 4;
}

- (UIViewController <LEXReusablePageProtocol> *)pageInBook:(LEXBook *)book 
                                             forPageNumber:(NSInteger)pageNumber 
                                            forOrientation:(UIInterfaceOrientation)orientation
{
    UIViewController <LEXReusablePageProtocol> *page = [LEXLazyPageViewController pageWithRandomColor];
    return page;
}

#pragma mark Book delegate

- (void)book:(LEXBook *)book didLeafToPageWithNumber:(NSInteger)pageNumber
{
    NSLog(@"Leafed to %d, controllers: %@", pageNumber, book.pageViewController.viewControllers);
}

- (void)book:(LEXBook *)book cancelLeafToPageWithNumber:(NSInteger)canceledPageNumber returnToPageWithNumber:(NSInteger)actualPageNumber 
{
    
}

@end
