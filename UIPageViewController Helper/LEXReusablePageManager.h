//
//  ITCHReusablePageManager.h
//  Zuma Menu
//
//  Created by iTech on 08.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEXReusablePageManager : NSObject {
    NSMutableSet *queuedPagesSet;
    NSMutableSet *pendingPagesSet;
}

- (NSArray*)queuedPages;
- (NSArray*)pendingPages;


- (void)addPageToQueue:(UIViewController*)page;
- (void)addPagesToQueue:(NSArray*)pages;

- (void)addPageToPending:(UIViewController*)page;
-  (void)addPagesToPending:(NSArray*)page;

- (void)removePageFromPending:(UIViewController*)page;
- (void)removePagesFromPending:(NSArray*)pages;

- (void)movePageFromQueueToPending:(UIViewController *)page;
- (void)movePagesFromQueueToPending:(NSArray *)pages;

- (void)movePageFromPendingToQueue:(UIViewController*)page;
- (void)movePagesFromPendingToQueue:(NSArray *)pages;

- (id)dequeueReusablePage;

- (BOOL)isPageInPending:(UIViewController*)page;
- (BOOL)isPageInQueue:(UIViewController*)page;

@end
