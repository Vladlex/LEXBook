//
//  LEXViewController.m
//  UIPageViewController Helper
//
//  Created by Vladlex on 09.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LEXViewController.h"

@interface LEXViewController ()

@end

@implementation LEXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
