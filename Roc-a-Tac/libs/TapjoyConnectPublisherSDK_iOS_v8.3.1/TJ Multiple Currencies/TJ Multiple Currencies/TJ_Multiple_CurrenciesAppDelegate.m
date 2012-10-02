// Copyright (C) 2011-2012 by Tapjoy Inc.
//
// This file is part of the Tapjoy SDK.
//
// By using the Tapjoy SDK in your software, you agree to the terms of the Tapjoy SDK License Agreement.
//
// The Tapjoy SDK is bound by the Tapjoy SDK License Agreement and can be found here: https://www.tapjoy.com/sdk/license

#import "TJ_Multiple_CurrenciesAppDelegate.h"
#import "TapjoyConnect.h"
#import "MainViewController.h"

@implementation TJ_Multiple_CurrenciesAppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[TJCLog setLogThreshold:LOG_DEBUG];
	
	// Connect Relevent Calls
	// Connect Notifications 
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tjcConnectSuccess:) name:TJC_CONNECT_SUCCESS object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tjcConnectFail:) name:TJC_CONNECT_FAILED object:nil];
	
	// NOTE: This must be replaced by your App ID. It is Retrieved from the Tapjoy website, in your account.
	[TapjoyConnect requestTapjoyConnect:@"f140e798-78fb-4d82-bb05-365a24d59547" secretKey:@"D5oHobtuxnPIERTh9D3q"];
	
	// If you are not using Tapjoy Managed currency, you would set your own user ID here.
	[TapjoyConnect setUserID:@"A_UNIQUE_USER_ID"];
	
	// View Specific Calls
	[TapjoyConnect setTransitionEffect:TJCTransitionExpand];
	[TapjoyConnect setUserdefinedColorWithIntValue:0x808080];
	//OR
	//[TapjoyConnect setUserDefinedColorWithRed:208 WithGreen:119 WithBlue:0];
	
	// This will set the display count to infinity effectively always showing the featured app.
	[TapjoyConnect setFeaturedAppDisplayCount:TJC_FEATURED_COUNT_INF];
	
	// Get Tapjoy Banner Ads Call
	[TapjoyConnect getDisplayAdWithDelegate:mainCtrl_];
	[mainCtrl_.view addSubview:[TapjoyConnect getDisplayAdView]];
	
	// Get Featured App Call
	[[NSNotificationCenter defaultCenter] addObserver:mainCtrl_ 
														  selector:@selector(showFeaturedAdFullScreen:) 
																name:TJC_FEATURED_APP_RESPONSE_NOTIFICATION 
															 object:nil];
	
	navCtrl_ = [[UINavigationController alloc]initWithRootViewController:mainCtrl_];
	navCtrl_.navigationBar.barStyle = UIBarStyleDefault;
	navCtrl_.navigationBarHidden = YES;
	
	[window setRootViewController:navCtrl_];
	
	[window makeKeyAndVisible];

	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
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
	/*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
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
	[navCtrl_ release];
	[mainCtrl_ release];
	[super dealloc];
}


#pragma mark TJC_NOTIFICATION_HANDLERS

-(void)tjcConnectSuccess:(NSNotification*)notifyObj
{
	NSLog(@"Tapjoy connect Succeeded");
}


-(void)tjcConnectFail:(NSNotification*)notifyObj
{
	NSLog(@"Tapjoy connect Failed");	
}

@end
