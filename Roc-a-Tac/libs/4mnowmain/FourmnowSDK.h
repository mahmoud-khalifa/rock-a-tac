//
//  fourmnowsdk.h
//  fourmnowsdk
//
//  Created by Hafiz on 2/12/12.
//  Copyright (c) 2012 My Company. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#   define CILog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define CILog(...)
#endif

#define K_DOMAIN    [[NSUserDefaults standardUserDefaults]objectForKey:@"FMNOW_DOMAIN"]
#define k_ScrWidth (UI_USER_INTERFACE_IDIOM())? 768:320
#define k_ScrHeight (UI_USER_INTERFACE_IDIOM())?1024:480
#define k_ScrCenterP (UI_USER_INTERFACE_IDIOM())? CGPointMake(384,512):CGPointMake(160,240)
#define k_ScrCenterL (UI_USER_INTERFACE_IDIOM())? CGPointMake(512,384):CGPointMake(240,160)

@protocol FourmnowSDKDelegate;

@interface FourmnowSDK : NSObject{
    id <FourmnowSDKDelegate>delegate;
}
@property(nonatomic, retain) id <FourmnowSDKDelegate>delegate;
// Singleton 
+(FourmnowSDK*)sharedFourmnowSDK;

// Retreive saved dictionary
- (NSDictionary*)fourmnowPlist;

// For downloading Plist data
- (void)requestFourmnowInfoSettingsForDomain:(NSString*)domain withDelegate:(id)delegate;

// Initialize Fourmnow Push
- (void)enableFourmnowPush;

// For Registering Device Token for Push Notification
- (void)registerDeviceToken:(NSData*)deviceToken ;

// For Parsing push Notification
- (void)handlePush:(NSDictionary*)pushDictionary;

// Set Application Icon Badge Number
- (void)allPush:(NSString*)badgeString;
@end

#pragma mark PopupControllerDelegate
@protocol FourmnowSDKDelegate<NSObject>

// Automatically called this delegate if it successfully get plist data
- (void)fourmnowSDKDidReceiveSettings:(NSDictionary*)settingDictionary forFourmnowSDK:(FourmnowSDK*)fourmnowsdk;

// Automatically called this delegate if it failed to load/get plist data
- (void)fourmnowSDKDidFailedToReceiveSettings:(NSError*)error  forFourmnowSDK:(FourmnowSDK*)fourmnowsdk;

// Automatically called this delegate if it successfully registered device token on Fourmnow server and returned a response string
- (void)fourmnowSDKPushDidRegister:(NSString*)responseString forFourmnowSDK:(FourmnowSDK*)fourmnowsdk;

// Automatically called this delegate if it failed to registered device token on Fourmnow server and returned a error string
- (void)fourmnowSDKPushDidFailedToRegister:(NSError*)errorString forFourmnowSDK:(FourmnowSDK*)fourmnowsdk;
@end