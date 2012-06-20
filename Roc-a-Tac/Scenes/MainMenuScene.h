//
//  MainMenuScene.h
//  TicTacToe
//
//  Created by Log n Labs on 1/31/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "GameScene.h"
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"
// MainMenuScene

typedef enum
{
    MainMenuSceneTagDifficultySprite=100,
    MainMenuSceneTagRateAppSprite,
    MainMenuSceneTagRegisterPushNotifications
    
} MainMenuSceneTags;



@interface MainMenuScene : CCLayer<MFMailComposeViewControllerDelegate,AppDelegateProtocol>
{
    
    BackgroundThemes bgTheme;
    
    CCSprite * selectedButton;
    
    CCSprite* hardLevel;
    CCSprite* mediumLevel;
    CCSprite* easyLevel;
    GameDifficulties siglePlayerDifficulty;
    
    CCSprite* rateAppSprite;
    CCSprite* btnSelector;
    
    
    CCSprite* pushNotificationsRequest;
    
    CCSpriteFrameCache*frameCache;
}

// returns a CCScene that contains the MainMenuScene as the only child
+(CCScene *) scene;

@end
