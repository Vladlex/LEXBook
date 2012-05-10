//
//  ITCHReusablePageManager.m
//  Zuma Menu
//
//  Created by iTech on 08.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LEXReusablePageManager.h"


@interface LEXReusablePageManager ()

@end

@implementation LEXReusablePageManager 

- (void)dealloc {
    [queuedPagesSet release];
    [pendingPagesSet release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self != nil) {
        queuedPagesSet = [[NSMutableSet alloc] init];
        pendingPagesSet = [[NSMutableSet alloc] init];
    }
    return self;
}

#pragma mark Getter accessors

- (NSArray*)pendingPages {
    return pendingPagesSet.allObjects;
}

- (NSArray*)queuedPages {
    return queuedPagesSet.allObjects;
}

- (id)dequeueReusablePage {
    id page = [queuedPagesSet anyObject];
    if (page) {
        [self movePageFromQueueToPending:page];
    }
    
    return page;
}

- (BOOL)isPageInQueue:(UIViewController *)page {
    return [queuedPagesSet containsObject:page];
}

- (BOOL)isPageInPending:(UIViewController *)page {
    return [pendingPagesSet containsObject:page];
}

- (void)addPageToQueue:(UIViewController *)page {
    [queuedPagesSet addObject:page];
}

- (void)addPagesToQueue:(NSArray *)pages {
    for (id page in pages) {
        [self addPageToQueue:page];
    }
}

- (void)addPageToPending:(UIViewController *)page {
    if ([pendingPagesSet containsObject:page]) {
        NSLog(@"Adding page to pending when already added: %@", page);
    }
    [pendingPagesSet addObject:page];

}

- (void)addPagesToPending:(NSArray *)pages {
    for (id page in pages) {
        [self addPageToPending:page];
    }
}

- (void)removePageFromPending:(UIViewController *)page {
    if ([pendingPagesSet containsObject:page]) {
        [pendingPagesSet removeObject:page];
    }
    else {
        NSLog(@"There is no page in pending: %@", page);
    }
}

- (void)removePagesFromPending:(NSArray *)pages {
    for (id page in pages) {
        [self removePageFromPending:page];
    }
}

- (void)movePageFromQueueToPending:(UIViewController *)page {
    if ([queuedPagesSet containsObject:page]) {
        [queuedPagesSet removeObject:page];
    }
    else {
        NSLog(@"There is no page in queue: %@", page);
    }
    [pendingPagesSet addObject:page];
}

- (void)movePagesFromQueueToPending:(NSArray *)pages {
    for (id page in pages) {
        [self movePageFromQueueToPending:page];
    }
}

- (void)movePageFromPendingToQueue:(UIViewController *)page {
    [self removePageFromPending:page];
    [self addPageToQueue:page];
}

- (void)movePagesFromPendingToQueue:(NSArray *)pages {
    [self removePagesFromPending:pages];
    [self addPagesToQueue:pages];
}

- (void)pageNumbersLog {
    NSString *queueNumbers = [[self.queuedPages valueForKey:@"pageNumber"] componentsJoinedByString:@", "];
    NSString *pendingNumbers = [[self.pendingPages valueForKey:@"pageNumber"] componentsJoinedByString:@", "];
    NSLog(@"Q: %@\nP: %@", queueNumbers, pendingNumbers);
}

@end
