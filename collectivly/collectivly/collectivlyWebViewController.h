//
//  collectivlyWebViewController.h
//  collectivly
//
//  Created by Nathan Fraenkel on 6/29/13.
//  Copyright (c) 2013 Nathan Fraenkel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface collectivlyWebViewController : UIViewController <UIWebViewDelegate> {
    UIActivityIndicatorView *busy;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString *contentTitle;
@property (strong, nonatomic) NSURL *url;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton, *forwardButton, *stopButton, *refreshButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end
