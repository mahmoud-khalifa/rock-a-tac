// Copyright (C) 2011-2012 by Tapjoy Inc.
//
// This file is part of the Tapjoy SDK.
//
// By using the Tapjoy SDK in your software, you agree to the terms of the Tapjoy SDK License Agreement.
//
// The Tapjoy SDK is bound by the Tapjoy SDK License Agreement and can be found here: https://www.tapjoy.com/sdk/license


#import "MainViewController.h"
#import "TapjoyConnect.h"


@implementation MainViewController

@synthesize showFeaturedBtn, showFeatured2ndCurrencyBtn;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	[super viewDidLoad];
	
	[loadingView setAlpha:0];
	[activityIndicator setAlpha:0];
	
	connectionSuccessful = YES;
}

NSString *kPrimaryCurrencyID = @"f140e798-78fb-4d82-bb05-365a24d59547";	// Respect Points
NSString *kSecondaryCurrencyID = @"4b4e99d4-c485-4f5d-a096-4f8cb8854205";	// Disrespect Points

- (IBAction)showOffersBtnAction:(id)sender
{
	[self.navigationController setNavigationBarHidden:YES];
	
	[TapjoyConnect showOffersWithCurrencyID:kPrimaryCurrencyID withViewController:self withCurrencySelector:NO];
}


- (IBAction)showOffers2ndCurrencyBtnAction:(id)sender
{
	[self.navigationController setNavigationBarHidden:YES];
	
	[TapjoyConnect showOffersWithCurrencyID:kSecondaryCurrencyID withViewController:self withCurrencySelector:NO];
}


- (IBAction)showOffersWithSelectorBtnAction:(id)sender
{
	[self.navigationController setNavigationBarHidden:YES];
	
	[TapjoyConnect showOffersWithCurrencyID:kPrimaryCurrencyID withViewController:self withCurrencySelector:YES];
}


- (IBAction)refreshAdAction:(id)sender
{
	[TapjoyConnect refreshDisplayAdWithCurrencyID:kPrimaryCurrencyID];
}


- (IBAction)refreshAd2ndCurrencyAction:(id)sender
{
	[TapjoyConnect refreshDisplayAdWithCurrencyID:kSecondaryCurrencyID];
}


- (void)prepareForFeaturedAdLoad
{
	[showFeaturedBtn setEnabled:NO];
	[showFeaturedBtn setAlpha:0.5f];
	[showFeatured2ndCurrencyBtn setEnabled:NO];
	[showFeatured2ndCurrencyBtn setAlpha:0.5f];
	
	[loadingView setAlpha:0.5f];
	[activityIndicator setAlpha:1.0f];
	
	// Position the loading and activity indicator views to the current scroll position.
	CGPoint scrollOffset = [scrollView contentOffset];
	
	CGRect frame = [self.view frame];
	
	CGPoint center = CGPointMake(scrollOffset.x + (frame.size.width / 2), scrollOffset.y + (frame.size.height / 2));
	
	loadingView.center = center;
	activityIndicator.center = center;
	
	// Disable scroll.
	[scrollView setScrollEnabled:NO];
	
	[NSTimer scheduledTimerWithTimeInterval:20
												target:self 
											 selector:@selector(connectionError:) 
											 userInfo:nil 
											  repeats:NO];
	
	connectionSuccessful = NO;
}

		 
- (void)connectionError:(NSTimer*)timerObj
{
	if (connectionSuccessful)
		return;
	
	[showFeaturedBtn setEnabled:YES];
	[showFeaturedBtn setAlpha:1];
	[showFeatured2ndCurrencyBtn setEnabled:YES];
	[showFeatured2ndCurrencyBtn setAlpha:1];
	
	[loadingView setAlpha:0];
	[activityIndicator setAlpha:0];
	
	// Enable scroll.
	[scrollView setScrollEnabled:YES];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
																	message:@"Connection Failed" 
																  delegate:self 
													  cancelButtonTitle:@"OK" 
													  otherButtonTitles:nil];
	[alert show];
	[alert release];
}


- (void)finishFeaturedAdLoad
{
	[showFeaturedBtn setEnabled:YES];
	[showFeaturedBtn setAlpha:1];
	[showFeatured2ndCurrencyBtn setEnabled:YES];
	[showFeatured2ndCurrencyBtn setAlpha:1];
	
	[loadingView setAlpha:0];
	[activityIndicator setAlpha:0];
	
	// Enable scroll.
	[scrollView setScrollEnabled:YES];
	
	connectionSuccessful = YES;
}


- (IBAction)showFeaturedAdAction:(id)sender
{
	[self prepareForFeaturedAdLoad];
	
	[TapjoyConnect getFeaturedAppWithCurrencyID:kPrimaryCurrencyID];
}


- (IBAction)showFeaturedAd2ndCurrencyAction:(id)sender
{
	[self prepareForFeaturedAdLoad];
	
	[TapjoyConnect getFeaturedAppWithCurrencyID:kSecondaryCurrencyID];
}


- (IBAction)setCurrencyMutlplier1xAction:(id)sender
{
	[TapjoyConnect setCurrencyMultiplier:1.0f];
	currencyMutliplierLabel.text = @"Multiplier Value: 1x";
}


- (IBAction)setCurrencyMutlplier2xAction:(id)sender
{
	[TapjoyConnect setCurrencyMultiplier:2.0f];
	currencyMutliplierLabel.text = @"Multiplier Value: 2x";
}


- (void)showFeaturedAdFullScreen:(NSNotification*)notifyObj
{
	// notifyObj will be returned as Nil in case of internet error or unavailibity of featured App 
	// or its Max Number of count has exceeded its limit
	TJCFeaturedAppModel *featuredApp = notifyObj.object;
	NSLog(@"Full Screen Ad Name: %@, Cost: %@, Description: %@", featuredApp.name, featuredApp.cost, featuredApp.description);
	NSLog(@"Full Screen Ad Image URL %@ ", featuredApp.iconURL);
	
	// Show the custom Tapjoy full screen featured app ad view.
	if (featuredApp)
	{
		[TapjoyConnect showFeaturedAppFullScreenAdWithViewController:self];
		[self finishFeaturedAdLoad];
	}
}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{	
    // Return YES for supported orientations
    return YES;
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	CGRect frame = [self.view frame];

	// Update scroll size.
	[scrollView setContentSize:CGSizeMake(frame.size.width, currencyMutliplierLabel.frame.origin.y + currencyMutliplierLabel.frame.size.height)];
}


- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc 
{	
    [super dealloc];
}



#pragma mark Tapjoy Banner Ads Delegate Methods

- (void)didReceiveAd:(TJCAdView*)adView
{
	adView.frame = CGRectMake(0, 0, 320, 50);
}


- (void)didFailWithMessage:(NSString*)msg
{
	NSLog(@"No Tapjoy Banner Ads available");
}


- (NSString*)adContentSize
{
	return TJC_AD_BANNERSIZE_320X50;
}


- (BOOL)shouldRefreshAd
{
	return NO;
}


@end
