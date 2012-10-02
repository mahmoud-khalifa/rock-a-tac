// Copyright (C) 2011-2012 by Tapjoy Inc.
//
// This file is part of the Tapjoy SDK.
//
// By using the Tapjoy SDK in your software, you agree to the terms of the Tapjoy SDK License Agreement.
//
// The Tapjoy SDK is bound by the Tapjoy SDK License Agreement and can be found here: https://www.tapjoy.com/sdk/license


#import "TJ_PublisherAppDelegate.h"
#import "MainViewController.h"
#import "TapjoyConnect.h"

@implementation TJ_PublisherAppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[TJCLog setLogThreshold:LOG_DEBUG];
	
	// Connect Relevent Calls
	// Connect Notifications 
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tjcConnectSuccess:) name:TJC_CONNECT_SUCCESS object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tjcConnectFail:) name:TJC_CONNECT_FAILED object:nil];
	
	// NOTE: This must be replaced by your App ID. It is Retrieved from the Tapjoy website, in your account.
	[TapjoyConnect requestTapjoyConnect:@"93e78102-cbd7-4ebf-85cc-315ba83ef2d5" secretKey:@"JWxgS26URM0XotaghqGn"];
	// If you are not using Tapjoy Managed currency, you would set your own user ID here.
	//[TapjoyConnect setUserID:@"A_UNIQUE_USER_ID"];
	
	// View Specific Calls
	[TapjoyConnect setTransitionEffect:TJCTransitionExpand];
	[TapjoyConnect setUserdefinedColorWithIntValue:0x808080];
	//OR
	//[TapjoyConnect setUserDefinedColorWithRed:208 WithGreen:119 WithBlue:0];
	
	// Get Featured App Call
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFeaturedApp:) 
																name:TJC_FEATURED_APP_RESPONSE_NOTIFICATION 
															 object:nil];
	[TapjoyConnect getFeaturedApp];
	// This will set the display count to infinity effectively always showing the featured app.
	[TapjoyConnect setFeaturedAppDisplayCount:TJC_FEATURED_COUNT_INF];
	
	// Notifications for Tap Points related callbacks.
	[[NSNotificationCenter defaultCenter] addObserver:self 
														  selector:@selector(getUpdatedPoints:) 
																name:TJC_TAP_POINTS_RESPONSE_NOTIFICATION 
															 object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self 
														  selector:@selector(getUpdatedPoints:) 
																name:TJC_SPEND_TAP_POINTS_RESPONSE_NOTIFICATION 
															 object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self 
														  selector:@selector(getUpdatedPoints:) 
																name:TJC_AWARD_TAP_POINTS_RESPONSE_NOTIFICATION 
															 object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self 
														  selector:@selector(getUpdatedPointsError:) 
																name:TJC_TAP_POINTS_RESPONSE_NOTIFICATION_ERROR 
															 object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self 
														  selector:@selector(getUpdatedPointsError:) 
																name:TJC_SPEND_TAP_POINTS_RESPONSE_NOTIFICATION_ERROR 
															 object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self 
														  selector:@selector(getUpdatedPointsError:) 
																name:TJC_AWARD_TAP_POINTS_RESPONSE_NOTIFICATION_ERROR 
															 object:nil];
	[TapjoyConnect getTapPoints];
	
	// Get Tapjoy Banner Ads Call
	[TapjoyConnect getDisplayAdWithDelegate:mainCtrl_];
	[mainCtrl_.view addSubview:[TapjoyConnect getDisplayAdView]];
	
    [window setRootViewController:mainCtrl_];
	
	[window makeKeyAndVisible];
	
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Remove this to prevent the possibility of multiple redundant notifications.
	[[NSNotificationCenter defaultCenter] removeObserver:self name:TJC_TAPPOINTS_EARNED_NOTIFICATION object:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	 If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	 */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	/*
	 Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	 */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Call init videos here so that videos will be refreshed on each app session.
	[mainCtrl_ initVideoAds];
	
	// Add an observer for when a user has successfully earned currency.
	[[NSNotificationCenter defaultCenter] addObserver:self
														  selector:@selector(showEarnedCurrencyAlert:) 
																name:TJC_TAPPOINTS_EARNED_NOTIFICATION 
															 object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	/*
	 Called when the application is about to terminate.
	 Save data if appropriate.
	 See also applicationDidEnterBackground:.
	 */
}

- (void)dealloc
{
	[window release];
	[mainCtrl_ release];
   [super dealloc];
}




#pragma mark TJC_NOTIFICATION_HANDLERS

-(void)getUpdatedPoints:(NSNotification*)notifyObj
{
	NSNumber *tapPoints = notifyObj.object;
	NSString *tapPointsStr = [NSString stringWithFormat:@"Tap Points: %d", [tapPoints intValue]];
	NSLog(@"%@", tapPointsStr);
	
	[mainCtrl_.tapPointsLabel setText:tapPointsStr];
}


- (void)showEarnedCurrencyAlert:(NSNotification*)notifyObj
{
	NSNumber *tapPointsEarned = notifyObj.object;
	int earnedNum = [tapPointsEarned intValue];
	
	NSLog(@"Currency earned: %d", earnedNum);
	
	// Pops up a UIAlert notifying the user that they have successfully earned some currency.
	// This is the default alert, so you may place a custom alert here if you choose to do so.
	[TapjoyConnect showDefaultEarnedCurrencyAlert];
	
	// This is a good place to remove this notification since it is undesirable to have a pop-up alert during gameplay.
	[[NSNotificationCenter defaultCenter] removeObserver:self name:TJC_TAPPOINTS_EARNED_NOTIFICATION object:nil];
}


- (void)getUpdatedPointsError:(NSNotification*)notifyObj
{
	[mainCtrl_.tapPointsLabel setText:@"Loading..."];
}


-(void)getFeaturedApp:(NSNotification*)notifyObj
{
	// notifyObj will be returned as Nil in case of internet error or unavailibity of featured App 
	// or its Max Number of count has exceeded its limit
	TJCFeaturedAppModel *featuredApp = notifyObj.object;
	NSLog(@"Full Screen Ad Name: %@, Cost: %@, Description: %@, Amount: %d", featuredApp.name, featuredApp.cost, featuredApp.description, featuredApp.amount);
	NSLog(@"Full Screen Image URL %@ ", featuredApp.iconURL);
	
	// Show the custom Tapjoy full screen featured app ad view.
	if (featuredApp)
	{
		[TapjoyConnect showFeaturedAppFullScreenAdWithViewController:mainCtrl_];
		[mainCtrl_.showFeaturedBtn setEnabled:YES];
		[mainCtrl_.showFeaturedBtn setAlpha:1.0f];
	}
}


-(void)tjcConnectSuccess:(NSNotification*)notifyObj
{
	NSLog(@"Tapjoy connect Succeeded");
}


-(void)tjcConnectFail:(NSNotification*)notifyObj
{
	NSLog(@"Tapjoy connect Failed");	
}

@end
