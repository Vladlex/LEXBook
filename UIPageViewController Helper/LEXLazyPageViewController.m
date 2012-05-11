//
//  LEXLazyPageViewController.m
//  UIPageViewController Helper
//
//  Created by iTech on 10.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LEXLazyPageViewController.h"

#import "UIColor+RandomColor.h"

@interface LEXLazyPageViewController ()

@end

@implementation LEXLazyPageViewController
@synthesize pageNumber = pageNumber_;
@synthesize pageColor = pageColor_;

#pragma mark Class methods

+ (id)pageWithRandomColor {
    id page = [[[self alloc] init] autorelease];
    [page setPageColor:[UIColor randomColor]];
    return page;
}

#pragma mark Life cycle

- (void)dealloc {
    [pageNumberLabel release];
    [pageColor_ release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.pageColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = self.pageColor;
    
    pageNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 20.0, 60.0, 27.0)];
    [self.view addSubview:pageNumberLabel];
	// Do any additional setup after loading the view.
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

#pragma mark Accessors

- (void)setPageColor:(UIColor *)newPageColor
{
    if (newPageColor != pageColor_)
    {
        [pageColor_ release];
        pageColor_ = [newPageColor retain];
        if (self.view != nil) {
            self.view.backgroundColor = pageColor_;
        }
    }
}

#pragma mark Reusable page protocol

 - (void)setPageNumberForLEXBook:(NSInteger)pageNumber
{
    self.pageNumber = pageNumber;
    pageNumberLabel.text = [NSString stringWithFormat:@"Page %d", self.pageNumber];
}

- (NSInteger)pageNumberForLEXBook
{
    return self.pageNumber;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Page with num %d", [self pageNumberForLEXBook]];
}

@end
