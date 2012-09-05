//
//  AppDelegate.m
//  TicTacToe
//
//  Created by Log n Labs on 1/31/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "GameConfig.h"
#import "MainMenuScene.h"
#import "RootViewController.h"

#import "TapjoyConnect.h"
//#import "FourmnowSDK.h"
#import "StatisticsCollector.h"

#import "SimpleAudioEngine.h"

//#import "TestFlight.h"
#import "BlockAlertView.h"


#import "NagScreenViewController.h"

#import "MKStoreManager.h"

#import "ChartBoost.h"

@implementation AppDelegate

@synthesize window;
@synthesize MultiplayerTimeout,delegate;
@synthesize facebook;
@synthesize adView;

- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController

//	CC_ENABLE_DEFAULT_GL_STATES();
//	CCDirector *director = [CCDirector sharedDirector];
//	CGSize size = [director winSize];
//	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
//	sprite.position = ccp(size.width/2, size.height/2);
//	sprite.rotation = -90;
//	[sprite visit];
//	[[director openGLView] swapBuffers];
//	CC_ENABLE_DEFAULT_GL_STATES();
	
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController	
}


void uncaughtExceptionHandler(NSException *exception) {
    
    NSArray *backtrace = [exception callStackSymbols];
    NSString *platform = [[UIDevice currentDevice] model];
    NSString *version = [[UIDevice currentDevice] systemVersion];
    NSString *message = [NSString stringWithFormat:@"Device: %@. OS: %@. Backtrace:\n%@",
                         platform,
                         version,
                         backtrace];
    [StatisticsCollector trackApplicationError:@"Uncaught" andMessage:message andException:exception];
    
}


- (void) applicationDidFinishLaunching:(UIApplication*)application
{
    
    //In-App Purchase
    [MKStoreManager sharedManager];
    
    MultiplayerTimeout=kWAITING_MAX_TIME;
    
//     [TestFlight takeOff:@"0364766fe2a01861d964688af6d35af7_NDQwODkyMDExLTExLTI5IDExOjAyOjQ3LjE2MDE2NQ"];
    
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	
	CCDirector *director = [CCDirector sharedDirector];
	
	// Init the View Controller
	viewController = [RootViewController sharedRootViewController];//[[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
	
//	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");
	
	//
	// VERY IMPORTANT:
	// If the rotation is going to be controlled by a UIViewController
	// then the device orientation should be "Portrait".
	//
	// IMPORTANT:
	// By default, this template only supports Landscape orientations.
	// Edit the RootViewController.m file to edit the supported orientations.
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif
	
	[director setAnimationInterval:1.0/60];
	[director setDisplayFPS:NO];
	
	
	// make the OpenGLView a child of the view controller
//	[viewController setView:glView];
	viewController.view=glView;
//    [viewController.view addSubview:viewController.imageView];
//    [viewController.view bringSubviewToFront:viewController.imageView];
	// make the View Controller a child of the main window
	[window setRootViewController: viewController];

    
    
	[window makeKeyAndVisible];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	
	// Removes the startup flicker
	[self removeStartupFlicker];
	
	// Run the intro Scene
	[[CCDirector sharedDirector] runWithScene: [MainMenuScene scene]];
    gameController=[Controller sharedController];
    [gameController authenticateLocalPlayer];

    
    //TapJoy Featured App
    [TJCLog setLogThreshold:LOG_DEBUG];
    
    // Connect Relevent Calls
    // Connect Notifications 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tjcConnectSuccess:) name:TJC_CONNECT_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tjcConnectFail:) name:TJC_CONNECT_FAILED object:nil];
    
    // NOTE: This must be replaced by your App ID. It is Retrieved from the Tapjoy website, in your account.
    
    
    [TapjoyConnect requestTapjoyConnect:kTAPJOY_APP_ID secretKey:kTAPJOY_APP_SECRET_KEY];
    
    // View Specific Calls
    [TapjoyConnect setTransitionEffect:TJCTransitionExpand];
    [TapjoyConnect setUserdefinedColorWithIntValue:0x808080];
    
    
//    [self getTapJoySetting ];
    _4mnowkey = @"enderval";
    
//    [[FourmnowSDK sharedFourmnowSDK]requestFourmnowInfoSettingsForDomain: _4mnowkey withDelegate:self];    
//    [[FourmnowSDK sharedFourmnowSDK]allPush:@"0"];
//    
    [[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"music.mp3" loop:YES];
    
    
    //Flurry Analytics:
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    [StatisticsCollector startSession:kFLURRY_APP_KEY];

    
//    [viewController.view addSubview:viewController.imageView];
//    [viewController.view bringSubviewToFront:viewController.imageView];
    
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    
    // Configure ChartBoost
    ChartBoost *cb = [ChartBoost sharedChartBoost];
    cb.appId = kCHARTBOOST_APP_ID;
    cb.appSignature = kCHARTBOOST_APP_SIGNATURE;
    
    // Notify an install
    [cb install];
    
	[[CCDirector sharedDirector] resume];

     [gameController authenticateLocalPlayer];
    
      [self getTapJoySetting ];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    
    CCLOG(@"in memory Warning");
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
    
    //disconnect current match:
    if (gameController.gkHelper.currentMatch) {
        [gameController multiPlayerSendDisconnected];
        
        BlockAlertView* alert=[BlockAlertView alertWithTitle: NSLocalizedString(@"Disconnection", @"") message: NSLocalizedString(@"You left your multiplayer game.", @"") andLoadingviewEnabled:NO];
        [alert setCancelButtonWithTitle:NSLocalizedString(@"Close", @"") block:nil];
        
        [alert show];
        
        [gameController.gkHelper disconnectCurrentMatch];
    }
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];
	
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[[CCDirector sharedDirector] end];
     [adView release];
	[window release];
    [nagDict release];
	[super dealloc];
}

#pragma mark TapJoy 
-(void)getFeaturedApp:(NSNotification*)notifyObj
{
	// notifyObj will be returned as Nil in case of internet error or unavailibity of featured App 
	// or its Max Number of count has exceeded its limit
	TJCFeaturedAppModel *featuredApp = notifyObj.object;
	NSLog(@"Featured App Name: %@, Cost: %@, Description: %@, Amount: %d", featuredApp.name, featuredApp.cost, featuredApp.description, featuredApp.amount);
	NSLog(@"Featured App Image URL %@ ", featuredApp.iconURL);
	
	// Show the custom Tapjoy full screen featured app ad view.
	if (featuredApp)
	{
        [TapjoyConnect showFeaturedAppFullScreenAdWithViewController:viewController];
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

#pragma mark tapJoy setting
-(void)getTapJoySetting{
    [self prepareAdsStats ];

    NSLog(@"%@", TAPJOY_PLIST_URL);
    NSURL *url= [NSURL URLWithString:TAPJOY_PLIST_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];    
    [NSURLConnection connectionWithRequest:request delegate:self];
    tapjoy_data = [[NSMutableData alloc] init];
    
  }

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)_data{
    [tapjoy_data appendData:_data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSDictionary *dictServer = nil;
    CFPropertyListRef plist =  CFPropertyListCreateFromXMLData(kCFAllocatorDefault, (CFDataRef)tapjoy_data,
															   kCFPropertyListImmutable,
															   NULL);
    if ([(id)plist isKindOfClass:[NSDictionary class]])
	{
		dictServer = [(NSDictionary *)plist autorelease];
	}
	else
	{// clean up ref
        if (plist) {
            CFRelease(plist);
        }
		dictServer = nil;
	}
    if (dictServer) {
        NSLog(@"plist file: %@",dictServer);
        
        NSDictionary* tapjoyDict=[dictServer objectForKey:@"TapJoy"];
        bool tapjoyMoreScreenEnabled=[[tapjoyDict objectForKey:@"TapJoy_Marketplace_Enabled"] boolValue];
        [[NSUserDefaults standardUserDefaults]setBool:tapjoyMoreScreenEnabled forKey:kTAPJOY_MORE_SCREEN_ENABLED_KEY];
        
        CCLOG(@"tapjoy dic: %@",tapjoyDict);
        
        NSDictionary* moPubDict=[dictServer objectForKey:@"mopub"];
        
        NSDictionary* customDict=[dictServer objectForKey:@"Custom_Settings"];
        MultiplayerTimeout=[[customDict objectForKey:@"MultiplayerTimeout"] intValue];
        
//        int tapjoyDisabled =[[dict objectForKey:@"TapJoy_Disabled"] intValue];
//        if (!tapjoyDisabled) {
            
        if (![gameController isFeaturePurchased:kREMOVE_ADS_ID]) {
//#ifdef LITE_VERSION
            
            //BANNERS PART//
            bool bannerAdEnabled=[[tapjoyDict objectForKey:@"TapJoy_Banners_Enabled"] boolValue];
            bool moPubBannerEnabled=[[moPubDict objectForKey:@"Mopub_Banners_Enabled"] boolValue];
            
            
            [[NSUserDefaults standardUserDefaults]setBool:bannerAdEnabled forKey:kBANNER_AD_ENABLED_KEY];
            [[NSUserDefaults standardUserDefaults]setBool:moPubBannerEnabled forKey:kBANNER_AD_ENABLED_KEY];
            
            if (bannerAdEnabled) {// Get Tapjoy Display Ads Call
                    [TapjoyConnect getDisplayAdWithDelegate:viewController];
                    [viewController.view addSubview:[TapjoyConnect getDisplayAdView]];
                }
            else if(moPubBannerEnabled){
                // Instantiate the MPAdView with your ad unit ID.
                if(IS_IPAD()){
                    adView = [[MPAdView alloc] initWithAdUnitId:kMOPUB_ID size:MOPUB_BANNER_SIZE_IPAD];
                }
                else {
                    adView = [[MPAdView alloc] initWithAdUnitId:kMOPUB_ID size:MOPUB_BANNER_SIZE_IPHONE];
                }
//                adView = [[MPAdView alloc] initWithAdUnitId:kMOPUB_ID size:MOPUB_BANNER_SIZE];
                
                // Register your view controller as the MPAdView's delegate.
                adView.delegate = self;
                
                // Set the ad view's frame (in our case, to occupy the bottom of the screen).
                CGRect frame = adView.frame;
                frame.origin.y = 0;
                adView.frame = frame;
                
                // Add the ad view to your controller's view hierarchy. 
                [viewController.view addSubview:adView];
                
                // Call for an ad.
                [adView loadAd];
            }
//#endif	
            //END OF BANNERS PART//
            
            
            //FEATURED APP PART//
            
            bool featuredAppEnabled=[[tapjoyDict objectForKey:@"TapJoy_Featuredapp_Enabled"] boolValue];
            NSDictionary* customSetting=[tapjoyDict objectForKey:@"TapJoy_Custom_Settings"];
            int maxFeaturePerDay=[[customSetting objectForKey:@"max_feature_per_day"] intValue];
            int maxFeaturePerHour=[[customSetting objectForKey:@"max_feature_per_hour"] intValue];
            featuredAdDisplayCount=[[customSetting objectForKey:@"featured_app_display_count"] intValue];
            
            NSDictionary* bcfAdsDict=[dictServer objectForKey:@"BCFads"];
            bool revmobEnabled=[[bcfAdsDict objectForKey:@"BCFads_Nag_Enabled"] boolValue];
            
            NSDictionary* chartBoostDict=[dictServer objectForKey:@"Chartboost>"];
            bool chartEnabled=[[chartBoostDict objectForKey:@"Chartboost_Featured_App"] boolValue];

            if(featuredAppEnabled){
                
            [self showAd:maxFeaturePerHour maxDayAllowed:maxFeaturePerDay withTapjoyEnabled:YES andCerebroNagScreenEnabled:NO];
                    
//                }else {
//                    if (nagDict!=nil) {
//                        [nagDict release];
//                        nagDict=nil;
//                    } 
//                    NSArray* nagArray=[[dictServer objectForKey:@"4mnow"] objectForKey:@"Nagscreen"];
//                    if (nagArray!=nil &&[nagArray count]!=0) {
//                        nagDict= [[NSDictionary alloc] initWithDictionary:[nagArray objectAtIndex:0]];
//                         
//                        bool  nagScreenEnabled=[[nagDict objectForKey:@"nagscreen_enable"] boolValue];
//                        if (nagScreenEnabled) {
//                           
//                            
//                            [self showAd:maxFeaturePerHour maxDayAllowed:maxFeaturePerDay withTapjoyEnabled:NO andCerebroNagScreenEnabled:YES];
//                        }
            } else if (revmobEnabled){
                [RevMobAds showPopupWithAppID:kREVMOB_ID withDelegate:self];
//                [RevMobAds startSessionWithAppID:@"4fd138459398a2000c000078"];
                        
                self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
                // Override point for customization after application launch.
//                self.viewController = [[[SampleAppViewController alloc] init] autorelease];
                self.window.rootViewController = viewController;
                [self.window makeKeyAndVisible];
            } else if (chartEnabled){
                ChartBoost *cb = [ChartBoost sharedChartBoost];
                cb.appId = kCHARTBOOST_APP_ID;
                cb.appSignature = kCHARTBOOST_APP_SIGNATURE;
                [cb install];
                [cb showInterstitial];
            }
            
         //END OF FEATURED APP PART//
            
                        
//                    }else {
////                        [self showAd:maxFeaturePerHour maxDayAllowed:maxFeaturePerDay withTapjoyEnabled:NO andCerebroNagScreenEnabled:NO];
//                        
//                        //chartboost
//                        //            // Configure ChartBoost
//                        ChartBoost *cb = [ChartBoost sharedChartBoost];
//                        //            cb.appId = @"4ecc3db6cb60150a36000002";
//                        //            cb.appSignature = @"83d79f18f57660a19716e83b7616b56d8e8dd128";
//                        //            
//                        //            // Notify an install
//                        //            [cb install];
//                        
//                        // Load interstitial
//                        [cb showInterstitial];
//
//                    }

//            }else {
//                if (nagDict!=nil) {
//                    
//                    [nagDict release];
//                    nagDict=nil;
//                    
//                }
//                NSArray* nagArray=[[dictServer objectForKey:@"4mnow"] objectForKey:@"Nagscreen"];
//                
//                NSDictionary* customSetting=[tapjoyDict objectForKey:@"TapJoy_Custom_Settings"];
//                int maxFeaturePerDay=[[customSetting objectForKey:@"max_feature_per_day"] intValue];
//                int maxFeaturePerHour=[[customSetting objectForKey:@"max_feature_per_hour"] intValue];
//                if (nagArray!=nil &&[nagArray count]!=0) {
//                    
//                    nagDict= [[NSDictionary alloc] initWithDictionary:[nagArray objectAtIndex:arc4random()%[nagArray count]]];
//                   
//                    bool nagScreenEnabled=[[nagDict objectForKey:@"nagscreen_enable"] boolValue];
//                    
//                    if (nagScreenEnabled) {
//                      
//                        [self showAd:maxFeaturePerHour maxDayAllowed:maxFeaturePerDay withTapjoyEnabled:NO andCerebroNagScreenEnabled:YES];
//                    }
//                    
//                }else {
////                    [self showAd:maxFeaturePerHour maxDayAllowed:maxFeaturePerDay withTapjoyEnabled:NO andCerebroNagScreenEnabled:NO];
//                    
//                    //chartboost
//                    //            // Configure ChartBoost
//                    ChartBoost *cb = [ChartBoost sharedChartBoost];
//                    //            cb.appId = @"4ecc3db6cb60150a36000002";
//                    //            cb.appSignature = @"83d79f18f57660a19716e83b7616b56d8e8dd128";
//                    //            
//                    //            // Notify an install
//                    //            [cb install];
//                    
//                    // Load interstitial
//                    [cb showInterstitial];
//
//                }
//                
//                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kBANNER_AD_ENABLED_KEY];
//            }
        
//        }else { //show nagscreen
//            
//            if (nagDict!=nil) {
//                [nagDict release];
//                nagDict=nil;
//            }
//           nagDict= [[NSDictionary alloc] initWithDictionary:[dictServer objectForKey:@"Nagscreen"]];
//            int nagScreenEnabled=[[nagDict objectForKey:@"nagscreen_enable"] intValue];
//            if (nagScreenEnabled==1) {
//                NSDictionary* customSetting=[dict objectForKey:@"TapJoy_Custom_Settings"];
//                int maxFeaturePerDay=[[customSetting objectForKey:@"max_feature_per_day"] intValue];
//                int maxFeaturePerHour=[[customSetting objectForKey:@"max_feature_per_hour"] intValue];
//                
//                [self showAd:maxFeaturePerHour maxDayAllowed:maxFeaturePerDay withTapjoyEnabled:NO];
//            }
//            
//        }
       
    }
}
}

- (void) increaseBannerSize{
    CGRect frame = adView.frame;
    frame.origin.y = 0;
//    frame.size = MOPUB_BANNER_SIZE;
    adView.frame = frame;
}

- (void) decreaseBannerSize{
    CGRect frame = adView.frame;
    frame.origin.y = 0;
    frame.size = CGSizeMake(320, 35);
    adView.frame = frame;
}

#pragma Mark FourmnowSDK Delegate

- (void)fourmnowSDKDidReceiveSettings:(NSDictionary*)settingDictionary forFourmnowSDK:(FourmnowSDK*)fourmnowsdk{   
    CILog(@"4mnow settings plist: %@", settingDictionary);
    // Register for notifications
    [[FourmnowSDK sharedFourmnowSDK]enableFourmnowPush];
 
}

- (void)fourmnowSDKDidFailedToReceiveSettings:(NSError*)error  forFourmnowSDK:(FourmnowSDK*)fourmnowsdk{
    if (error){
        CILog(@"4mnow Error: %@", [error description]);
    }    
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    // Register the token on Remote Server (your provided domain)
    [[FourmnowSDK sharedFourmnowSDK]registerDeviceToken:deviceToken];
    
     [delegate onDidRegisterForRemoteNotifications];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{

    [delegate onDidFailToRegisterForRemoteNotifications];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
 	// Show the push notification alert message 
    [[FourmnowSDK sharedFourmnowSDK]handlePush:userInfo];
}


- (void)prepareAdsStats
{
    NSDate *lastAdDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastAdDate"];
    NSDate *todayDate = [NSDate date];
    if (lastAdDate != nil) {
        NSDateComponents *lasAdDateComponents = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:lastAdDate];
        int lasAdDateYear = lasAdDateComponents.year;
        int lasAdDateMonth = lasAdDateComponents.month;
        int lasAdDateDay = lasAdDateComponents.day;
        
        NSDateComponents *todayComponents = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:todayDate];
        int todayYear = todayComponents.year;
        int todayMonth = todayComponents.month;
        int today = todayComponents.day;
        
        if (todayYear == lasAdDateYear && todayMonth == lasAdDateMonth && today == lasAdDateDay) {
            return;
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:todayDate forKey:@"lastAdDate"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"adsOfDay"];
    for (int i = 0; i<25; i++) {
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:[NSString stringWithFormat:@"adsOfHour_%d",i]];
    }
}

- (void)showAd:(int)maxHourAllowed maxDayAllowed:(int)maxDayAllowed withTapjoyEnabled:(BOOL)tapjoyEnabled andCerebroNagScreenEnabled:(BOOL)cerebroEnabled
{
    NSDateComponents *todayComponents = [[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:[NSDate date]];
    int hour = todayComponents.hour;
    int adsOfDay = [[NSUserDefaults standardUserDefaults] integerForKey:@"adsOfDay"];
    int adsOfHour = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"adsOfHour_%d",hour]];
    if (adsOfDay < maxDayAllowed && adsOfHour < maxHourAllowed) {
        //Show Ads Here
        
        
        if (tapjoyEnabled) {
            // Get Featured App Call
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFeaturedApp:) 
                                                         name:TJC_FEATURED_APP_RESPONSE_NOTIFICATION 
                                                       object:nil];
            [TapjoyConnect getFeaturedApp];
            // This will set the display count to infinity effectively always showing the featured app.
            [TapjoyConnect setFeaturedAppDisplayCount:featuredAdDisplayCount];//TJC_FEATURED_COUNT_INF];
            
            [[NSUserDefaults standardUserDefaults] setInteger:(adsOfDay+1) forKey:@"adsOfDay"];
            [[NSUserDefaults standardUserDefaults] setInteger:(adsOfHour+1) forKey:[NSString stringWithFormat:@"adsOfHour_%d",hour]];
            
        } else if(cerebroEnabled){ 
            
            NSString* resourceString=[nagDict objectForKey:@"resource"];
         
            if (resourceString!=nil && ![resourceString isEqualToString:@""]) {
                NagScreenViewController *nagScreen = [[NagScreenViewController alloc] initWithNibName:nil bundle:nil];
                nagScreen.link = [nagDict objectForKey:@"nagscreen_url"];
                nagScreen.view.frame = window.frame;
                [nagScreen.view layoutSubviews];    
                [window.rootViewController presentModalViewController:nagScreen animated:YES];
                [nagScreen setResource:resourceString isHTML:[[nagDict objectForKey:@"isHTML"]boolValue]];
               
                
                [[NSUserDefaults standardUserDefaults] setInteger:(adsOfDay+1) forKey:@"adsOfDay"];
                [[NSUserDefaults standardUserDefaults] setInteger:(adsOfHour+1) forKey:[NSString stringWithFormat:@"adsOfHour_%d",hour]];
            }
        }else {
//            //chartboost
//            //            // Configure ChartBoost
//            ChartBoost *cb = [ChartBoost sharedChartBoost];
//            //            cb.appId = @"4ecc3db6cb60150a36000002";
//            //            cb.appSignature = @"83d79f18f57660a19716e83b7616b56d8e8dd128";
//            //            
//            //            // Notify an install
//            //            [cb install];
//            
//            // Load interstitial
//            [cb showInterstitial];

        }
        
        
       
    }
}

#pragma mark facebook
- (void)connectToFacebook:(NSString *)msg {
    
	//msg IS THE STRING TO BE POSTED ONTO FACEBOOK
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    [userD setObject:msg forKey:@"ActiveFacebookMessage"];
    [userD synchronize];
    
    facebook = [[Facebook alloc] initWithAppId:kFACEBOOK_APP_ID andDelegate:self];
    NSArray *permissions = [[NSArray arrayWithObjects: @"publish_stream", nil] retain];
    [facebook authorize:permissions];
    
    
    // Check App ID:
    // This is really a warning for the developer, this should not
    // happen in a completed app
    // Now check that the URL scheme fb[app_id]://authorize is in the .plist and can
    // be opened, doing a simple check without local app id factored in here
    NSString *url = [NSString stringWithFormat:@"fb%@://authorize",kFACEBOOK_APP_ID];
    BOOL bSchemeInPlist = NO; // find out if the sceme is in the plist file.
    NSArray* aBundleURLTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
    if ([aBundleURLTypes isKindOfClass:[NSArray class]] && 
        ([aBundleURLTypes count] > 0)) {
        NSDictionary* aBundleURLTypes0 = [aBundleURLTypes objectAtIndex:0];
        if ([aBundleURLTypes0 isKindOfClass:[NSDictionary class]]) {
            NSArray* aBundleURLSchemes = [aBundleURLTypes0 objectForKey:@"CFBundleURLSchemes"];
            if ([aBundleURLSchemes isKindOfClass:[NSArray class]] &&
                ([aBundleURLSchemes count] > 0)) {
                NSString *scheme = [aBundleURLSchemes objectAtIndex:0];
                if ([scheme isKindOfClass:[NSString class]] && 
                    [url hasPrefix:scheme]) {
                    bSchemeInPlist = YES;
                }
            }
        }
    }
    //        // Check if the authorization callback will work
    //        BOOL bCanOpenUrl = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString: url]];
    //        if (!bSchemeInPlist || !bCanOpenUrl) {
    //            UIAlertView *alertView = [[UIAlertView alloc] 
    //                                      initWithTitle:@"Setup Error" 
    //                                      message:@"Invalid or missing URL scheme. You cannot run the app until you set up a valid URL scheme in your .plist." 
    //                                      delegate:self 
    //                                      cancelButtonTitle:@"OK" 
    //                                      otherButtonTitles:nil, 
    //                                      nil];
    //            [alertView show];
    //            [alertView release];
    //        }
    
}

- (void)postFacebookMessage {
    
    SBJSON *jsonWriter = [[SBJSON new] autorelease];
    
    // The action links to be shown with the post in the feed
    NSArray* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      @"Get Started",@"name",kLITE_APP_LINK,@"link", nil], nil];
    NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
    // Dialog parameters
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSString *msg = [[NSString alloc] initWithFormat:@"%@",[userD objectForKey:@"ActiveFacebookMessage"]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   
                                   @"Try Roc-A-Tac for iPhone/iPad", @"name",
                                   @"Roc-A-Tac for iPhone", @"caption",
                                   @"Challenge yourself", @"description",
                                   kLITE_APP_LINK, @"link",
                                   //                                   @"http://www.rockettier.com/wp-content/uploads/2011/10/word_boom_icon.png", @"picture",
                                   actionLinksStr, @"actions",
                                   msg,@"message",
                                   nil];
    [msg release];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
	[facebook requestWithGraphPath:@"me/feed" andParams:params andHttpMethod:@"POST" andDelegate:self];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [self.facebook handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [self.facebook handleOpenURL:url];
}

#pragma mark - FBSessionDelegate Methods
/**
 * Called when the user has logged in successfully.
 */
- (void)fbDidLogin {
    //    [self showLoggedIn];
    //    [self  apiDialogFeedUser];
    //       
    // Save authorization information
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    
    [self postFacebookMessage];
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
    CCLOG(@"did not login");
    
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout {
    CCLOG(@"log out");
}

#pragma mark - FBRequestDelegate Methods
/**
 * Called when the Facebook API request has returned a response. This callback
 * gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    CCLOG(@"received response");
}

/**
 * Called when a request returns and its response has been parsed into
 * an object. The resulting object may be a dictionary, an array, a string,
 * or a number, depending on the format of the API response. If you need access
 * to the raw response, use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];
    }
    // This callback can be a result of getting the user's basic
    // information or getting the user's permissions.
    if ([result objectForKey:@"name"]) {
        //        // If basic information callback, set the UI objects to
        //        // display this.
        //        //nameLabel.text = [result objectForKey:@"name"];
        //        // Get the profile image
        //        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[result objectForKey:@"pic"]]]];
        //        
        //        // Resize, crop the image to make sure it is square and renders
        //        // well on Retina display
        //        float ratio;
        //        float delta;
        //        float px = 100; // Double the pixels of the UIImageView (to render on Retina)
        //        CGPoint offset;
        //        CGSize size = image.size;
        //        if (size.width > size.height) {
        //            ratio = px / size.width;
        //            delta = (ratio*size.width - ratio*size.height);
        //            offset = CGPointMake(delta/2, 0);
        //        } else {
        //            ratio = px / size.height;
        //            delta = (ratio*size.height - ratio*size.width);
        //            offset = CGPointMake(0, delta/2);
        //        }
        //        CGRect clipRect = CGRectMake(-offset.x, -offset.y,
        //                                     (ratio * size.width) + delta,
        //                                     (ratio * size.height) + delta);
        //        UIGraphicsBeginImageContext(CGSizeMake(px, px));
        //        UIRectClip(clipRect);
        //        [image drawInRect:clipRect];
        //        UIImage *imgThumb =   UIGraphicsGetImageFromCurrentImageContext();
        //        [imgThumb retain];
        
        // [profilePhotoImageView setImage:imgThumb];
        //        [self apiGraphUserPermissions];
    } else {
        // Processing permissions information
        
        CCLOG(@"%@",[[result objectForKey:@"data"] objectAtIndex:0]);
        //        [self setUserPermissions:[[result objectForKey:@"data"] objectAtIndex:0]];
    }
    
    //collect statistics
    [StatisticsCollector logEvent:@"Post On Facebook"];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [viewController dismissModalViewControllerAnimated:YES];
}

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    CCLOG(@"Err message: %@", [[error userInfo] objectForKey:@"error_msg"]);
    CCLOG(@"Err code: %d", [error code]);
    
    // Show logged out state if:
    // 1. the app is no longer authorized
    // 2. the user logged out of Facebook from m.facebook.com or the Facebook app
    // 3. the user has changed their password
    if ([error code] == 190) {
        //        [self showLoggedOut:YES];
        
        // Remove saved authorization information if it exists and it is
        // ok to clear it (logout, session invalid, app unauthorized)
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ( [defaults objectForKey:@"FBAccessTokenKey"]) {
            [defaults removeObjectForKey:@"FBAccessTokenKey"];
            [defaults removeObjectForKey:@"FBExpirationDateKey"];
            [defaults synchronize];
            
            // Nil out the session variables to prevent
            // the app from thinking there is a valid session
            if (nil != [ facebook accessToken]) {
                facebook.accessToken = nil;
            }
            if (nil != [facebook expirationDate]) {
                facebook.expirationDate = nil;
            }
        }
        
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [viewController dismissModalViewControllerAnimated:YES];
}

#pragma mark MPAdViewDelegate Methods

// Implement MPAdViewDelegate's required method, -viewControllerForPresentingModalView. 
- (UIViewController *)viewControllerForPresentingModalView {
    return viewController;
}

@end
