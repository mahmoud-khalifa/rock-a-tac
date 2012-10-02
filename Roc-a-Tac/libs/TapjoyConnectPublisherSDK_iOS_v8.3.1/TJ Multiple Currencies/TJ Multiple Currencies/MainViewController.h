// Copyright (C) 2011-2012 by Tapjoy Inc.
//
// This file is part of the Tapjoy SDK.
//
// By using the Tapjoy SDK in your software, you agree to the terms of the Tapjoy SDK License Agreement.
//
// The Tapjoy SDK is bound by the Tapjoy SDK License Agreement and can be found here: https://www.tapjoy.com/sdk/license

#import <UIKit/UIKit.h>
#import "TapjoyConnect.h"

@interface MainViewController : UIViewController <TJCAdDelegate>
{
	IBOutlet UIButton *showOffersBtn;
	IBOutlet UIButton *showOffers2ndCurrencyBtn;
	IBOutlet UIButton *showOffersWithSelectorBtn;
	IBOutlet UIButton *refreshAdBtn;
	IBOutlet UIButton *refreshAd2ndCurrencyBtn;
	IBOutlet UIButton *showFeaturedBtn;
	IBOutlet UIButton *showFeatured2ndCurrencyBtn;
	
	IBOutlet UIButton *setCurrencyMultiplier1xBtn;
	IBOutlet UIButton *setCurrencyMultiplier2xBtn;
	IBOutlet UILabel *currencyMutliplierLabel;
	
	IBOutlet UIScrollView *scrollView;
	
	IBOutlet UIView *loadingView;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	
	BOOL connectionSuccessful;
}

@property (nonatomic, retain) IBOutlet UIButton *showFeaturedBtn;
@property (nonatomic, retain) IBOutlet UIButton *showFeatured2ndCurrencyBtn;

- (IBAction)showOffersBtnAction:(id)sender;
- (IBAction)showOffers2ndCurrencyBtnAction:(id)sender;
- (IBAction)showOffersWithSelectorBtnAction:(id)sender;
- (IBAction)refreshAdAction:(id)sender;
- (IBAction)refreshAd2ndCurrencyAction:(id)sender;
- (IBAction)showFeaturedAdAction:(id)sender;
- (IBAction)showFeaturedAd2ndCurrencyAction:(id)sender;
- (IBAction)setCurrencyMutlplier1xAction:(id)sender;
- (IBAction)setCurrencyMutlplier2xAction:(id)sender;

- (void)showFeaturedAdFullScreen:(NSNotification*)notifyObj;
- (void)prepareForFeaturedAdLoad;
- (void)finishFeaturedAdLoad;
- (void)connectionError:(NSTimer*)timerObj;

@end
