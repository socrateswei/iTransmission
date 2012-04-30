//
//  ITWebViewController.m
//  iTransmission
//
//  Created by Mike Chen on 10/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ITWebViewController.h"
#import "ITSidebarItem.h"
#import "ITNavigationController.h"
#import <curl/curl.h>
#import <curl/types.h>
#import <curl/easy.h>
#import "ITApplication.h"
#import "ITTorrent.h"
#import "ITTransfersViewController.h"

@implementation ITWebViewController
@synthesize sidebarItem = _sidebarItem;
@synthesize controller = _controller;
@synthesize handle = _handle;
@synthesize torrent;
@synthesize downloadFile;
@synthesize downloadFilePath;
@synthesize transfers;
NSURL *requestedURL;

- (id)init
{
    if ((self = [super initWithAddress:@"http://www.thepiratebay.se"])) {
        self.sidebarItem = [[ITSidebarItem alloc] init];
        self.sidebarItem.title = @"Browser";
        self.sidebarItem.icon = [UIImage imageNamed:@"browser-icon.png"];
        self.navigationController.toolbarHidden = NO;
//        self.navigationController.toolbar.barStyle = UIBarStyleBlack;
    }
    return self;
}

size_t write_data(void *ptr, size_t size, size_t nmemb, FILE *stream)
{
    size_t written;
    written = fwrite(ptr, size, nmemb, stream);
    return written;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self.navigationController respondsToSelector:@selector(setUseDefaultTheme:)])
        [(ITNavigationController*)self.navigationController setUseDefaultTheme:YES];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *requestedURL = [request URL];
    NSString *fileExtension = [requestedURL pathExtension];
    NSString *scheme = [requestedURL scheme];
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        if( [scheme isEqualToString:@"magnet"] )
        {
            NSLog(@"magnet");
            NSString *magnetlink = [requestedURL absoluteString];
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            NSURL *webinterface = [NSURL URLWithString:@"http://127.0.0.1:9091/transmission/web/"];
            NSURLRequest *requestURL = [NSURLRequest requestWithURL:webinterface];
            pasteboard.string = magnetlink;
            UIAlertView *message;
            message = [[UIAlertView alloc] initWithTitle:@"How to add" message:@"Now paste the URL into the open button in the web interface" delegate:nil cancelButtonTitle:@"Ok!" otherButtonTitles:nil, nil];
            [message show];
            [webView loadRequest:requestURL];
        }
    }
    
    return YES;
}
                 
- (void)add
{
    [self.controller openFiles:[NSArray arrayWithObject:[[NSBundle mainBundle] pathForResource:@"torrent" ofType:@"torrent"]] addType:ITAddTypeManual];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
@end
