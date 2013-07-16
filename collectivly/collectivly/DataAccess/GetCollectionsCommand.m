//
//  GetCollectionsCommand.m
//  collectivly
//
//  Created by Nathan Fraenkel on 7/14/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import "GetCollectionsCommand.h"

@implementation GetCollectionsCommand

@synthesize userIsLoggedIn, delegate;

-(id)initWithUserAlreadyLoggedInBool:(BOOL)booleano {
    self = [super init];
    if (self) {
        // custom initialization
        self.userIsLoggedIn = booleano;
        
    }
    return self;
}

-(void)fetchCollections {
    
}

#pragma mark connection protocol functions
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"[collectivlyCollectionsViewController] conection did receive response!");
    _data = [[NSMutableData alloc] init];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"[collectivlyCollectionsViewController] conection did receive data!");
    [_data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // Please do something sensible here, like log the error.
    NSLog(@"[collectivlyCollectionsViewController] connection failed with error: %@", error.description);
    
    // stop spinners
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    [HUD hide:YES];
//    [self.refresherController endRefreshing];
    
    [self.delegate reactToGetCollectionsError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"[collectivlyCollectionsViewController] connectiondidfinishloading!");
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
//    NSString *responseString = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    //    NSLog(@"response data: %@", responseString);
    
    NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    
    // act based on what the request was (requestinvite, requestsignin, etc)
            
            //            NSLog(@"[collectivlyCollectionsViewController] DICT RESPONSE FOR COLLECTTIONSS: %@", dictResponse);
            NSMutableArray *colls = [[NSMutableArray alloc] init];
            // counter
            for (NSDictionary *dict in dictResponse){
                collectivlyCollection *cc = [[collectivlyCollection alloc] initWithDictionary:dict];
                
                // add collection to list of collections
                //                NSLog(@"[collectivlyCollectionsViewController] ADDINGGNGGGG collection with id: %d", cc.idNumber);
                [colls addObject:cc];
            }
    
    [self.delegate reactToGetCollectionsResponse:[NSArray arrayWithArray:colls]];
//            float contentHeight = SCROLLVIEWPADDING;
//    
//            self.currentUser.collections = colls;
//            
//            [self.collectionsTableView reloadData];
//            
//            [HUD hide:YES];
//            if (!self.refresherController.enabled)
//                self.refresherController.enabled = YES;
//            [self.refresherController endRefreshing];
//            
           
}

@end
