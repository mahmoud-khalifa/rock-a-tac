//
//  NagScreenViewController.m
//  MultiMatch_the_game
//
//  Created by Nik Rudenko on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewsScreenViewController.h"

#import "AppDelegate.h"
@implementation NewsScreenViewController
@synthesize link;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(IBAction)close{
    [((AppDelegate*)[UIApplication sharedApplication].delegate).window.rootViewController dismissModalViewControllerAnimated:YES];
}

#pragma delegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [activity startAnimating];
    loading.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [activity stopAnimating];
    loading.hidden = YES;
}

-(void)setLansdcapeMode{
//    self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    webView.scalesPageToFit = YES;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:link]]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
