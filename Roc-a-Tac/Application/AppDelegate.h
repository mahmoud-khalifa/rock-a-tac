//
//  AppDelegate.h
//  TicTacToe
//
//  Created by Log n Labs on 1/31/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "FourmnowSDK.h"
#import "FBConnect.h"
@class Controller;
@class RootViewController;
@protocol AppDelegateProtocol
@optional
-(void)onDidRegisterForRemoteNotifications;
-(void)onDidFailToRegisterForRemoteNotifications;
@end


@interface AppDelegate : NSObject <UIApplicationDelegate,FBRequestDelegate,
FBDialogDelegate,
FBSessionDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;

    
    NSMutableData * tapjoy_data;
    
    int featuredAdDisplayCount;
//    int maxFeaturePerDay;
//    int maxFeaturePerHour;
    Controller* gameController;
    NSString *_4mnowkey;
    
    int MultiplayerTimeout;
    
    
    id<AppDelegateProtocol> delegate;
    
    NSDictionary* nagDict;
    
     Facebook *facebook;
}

@property (nonatomic, retain) UIWindow *window;
@property int MultiplayerTimeout;


@property (nonatomic,assign)id<AppDelegateProtocol> delegate;

@property (nonatomic, retain) Facebook *facebook;

-(void)getTapJoySetting;

- (void)prepareAdsStats;
- (void)showAd:(int)maxHourAllowed maxDayAllowed:(int)maxDayAllowed withTapjoyEnabled:(BOOL)tapjoyEnabled andCerebroNagScreenEnabled:(BOOL)cerebroEnabled;

#pragma mark facebook Methods
- (void)connectToFacebook:(NSString *)msg; 
- (void)postFacebookMessage;


@end
