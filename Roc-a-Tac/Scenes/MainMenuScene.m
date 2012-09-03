//
//  MainMenuScene.m
//  TicTacToe
//
//  Created by Log n Labs on 1/31/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "MainMenuScene.h"
#import "GameConfig.h"

#import "OptionsScene.h"
#import "StatisticsScene.h"


//#ifdef LITE_VERSION
#import "RootViewController.h"
//#endif

#import "TapjoyConnect.h"

#import "SimpleAudioEngine.h"
#import "BlockAlertView.h"

#import "ChartBoost.h"


@interface MainMenuScene (PrivateMethods)
-(void)HideSelectedBtn;
-(void)moreGamesButtonTouched:(id)sender;
-(void)statsButtonTouched:(id)sender;
-(void)optionsButtonTouched:(id)sender;
-(void)multiPlayerButtonTouched:(id)sender;
-(void)singlePlayerButtonTouched:(id)sender;
-(void)setAdPositionAtBottom:(BOOL)bottom;
-(void)hideAd;
-(void)goToGameSceneBackgroundTheme:(BackgroundThemes)selectedTheme andPieceModel:(PiecesModels)selectedPieceModel;

-(void)addDifficultyView;
-(void)startSinglePlayerGameWithDifficulty:(NSNumber*)difficulty;
-(void)rateApp;
-(void)openMail;

-(void)rateBtnTouched:(id)sender;
-(void)problemBtnTouched:(id)sender;

-(void)registerForPushNotifications;

@end
// MainMenuScene implementation
@implementation MainMenuScene

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainMenuScene *layer = [MainMenuScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        
        frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        
        
        kAPP_DELEGATE.delegate=self;
        
        self.scale=SCREEN_SCALE;
        CCSprite* bgSprite=[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache]addImage:@"main_menu_bg.jpg"]];
        
        bgSprite.position=ccp(screenSize.width*0.5, screenSize.height*0.5);
        
        [self addChild:bgSprite];
        
        selectedButton=[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache]addImage:@"main_menu_button_selected.png"]];
        
        selectedButton.position=kMULTI_PLAYER_BTN_POS;
        [self addChild:selectedButton];
        
        
        self.isTouchEnabled=YES;
        
        [self rateApp];
        
//        [self registerForPushNotifications];
        
        if (![[Controller sharedController] isFeaturePurchased:kREMOVE_ADS_ID]&&
            [[NSUserDefaults standardUserDefaults]boolForKey:kBANNER_AD_ENABLED_KEY]) {
            NSString* imageName;
            CGPoint pos;
            
            if (IS_IPAD()) {
                imageName=@"ad_bg_ipad.png";
                 pos=ccp(0, screenSize.height);
            }else {
                imageName=@"ad_bg.png";
                 pos=ccp(-kXoffsetiPad*0.5, screenSize.height+kYoffsetiPad*1.5);
            }
            CCSprite* AdBg=[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache]addImage:imageName]];
            AdBg.anchorPoint=ccp(0,1);
            
            AdBg.position=pos;
            [self addChild:AdBg z:2000];
            
        }

	}
	return self;
}

#pragma Touches
#pragma Tracking Touches
-(void) registerWithTouchDispatcher{ 
    [[CCTouchDispatcher sharedDispatcher]addTargetedDelegate:self priority:-1 swallowsTouches:YES];
    
}

-(BOOL) ccTouchBegan:(UITouch *)touch  withEvent:(UIEvent *)event{
    
    CGPoint location = [touch locationInView:[touch view]]; 
    location = [[CCDirector sharedDirector] convertToGL:location]; 
    
    if ([self getChildByTag:MainMenuSceneTagDifficultySprite]) {

        
    }else if([self getChildByTag:MainMenuSceneTagRateAppSprite]){
        CGRect doneRect=CGRectMake(ADJUST_DOUBLE(22*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(426*SCREEN_SCALE) , ADJUST_DOUBLE(57*SCREEN_SCALE), ADJUST_DOUBLE(31*SCREEN_SCALE));
        
        CGRect rateRect=CGRectMake(ADJUST_DOUBLE(76*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(309*SCREEN_SCALE)  , ADJUST_DOUBLE(240*SCREEN_SCALE), ADJUST_DOUBLE(43*SCREEN_SCALE));
        
        CGRect problemRect=CGRectMake(ADJUST_DOUBLE(76*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(259*SCREEN_SCALE)  , ADJUST_DOUBLE(240*SCREEN_SCALE), ADJUST_DOUBLE(43*SCREEN_SCALE));
        
        if(CGRectContainsPoint(doneRect, location)){
            [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
            
            [self removeChildByTag:MainMenuSceneTagRateAppSprite cleanup:YES];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isAppRated"];
            
        }else if(CGRectContainsPoint(rateRect, location)){
            
            btnSelector=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"GUI_Menu_RateApp_A_Selector_Blue.png"]];
            btnSelector.anchorPoint=ccp(0, 0);
            btnSelector.position=ADJUST_DOUBLE_XY(55, 183);
            [rateAppSprite addChild:btnSelector];
            
        }else if(CGRectContainsPoint(problemRect, location)){

            [btnSelector removeFromParentAndCleanup:YES];
            btnSelector=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"GUI_Menu_RateApp_A_Selector_Red.png"]];
            btnSelector.anchorPoint=ccp(0, 0);
            btnSelector.position=ADJUST_DOUBLE_XY(55, 134);
            [rateAppSprite addChild:btnSelector];
            
        }
        
    }else if([self getChildByTag:MainMenuSceneTagRegisterPushNotifications]){

    }else{
        
        if (CGRectContainsPoint(kSINGLE_PLAYER_BTN_RECT, location) ) {
           
            selectedButton.visible=YES;
            selectedButton.position=kSINGLE_PLAYER_BTN_POS;
           
        }else if (CGRectContainsPoint(kMULTI_PLAYER_BTN_RECT, location) ) {
           
            selectedButton.visible=YES;
            selectedButton.position=kMULTI_PLAYER_BTN_POS;
            
        }else if (CGRectContainsPoint(kOPTIONS_BTN_RECT, location) ) {
         
            selectedButton.visible=YES;
            selectedButton.position=kOPTIONS_BTN_POS;
           
        }else if (CGRectContainsPoint(kSTATS_BTN_RECT, location) ) {
         
            selectedButton.visible=YES;
            selectedButton.position=kSTATS_BTN_POS;
            
        }else if (CGRectContainsPoint(kMORE_GAMES_BTN_RECT, location) ) {
           
            selectedButton.visible=YES;
            selectedButton.position=kMORE_GAMES_BTN_POS;
        }
    }

    return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    
    
}

-(void) disableSelectedButton{
    selectedButton.visible=NO;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    
    [self performSelector:@selector(disableSelectedButton) withObject:Nil afterDelay:5];
    
    [btnSelector removeFromParentAndCleanup:YES];
    CGPoint location = [touch locationInView:[touch view]]; 
    
    location = [[CCDirector sharedDirector] convertToGL:location]; 
    
    if ([self getChildByTag:MainMenuSceneTagDifficultySprite]) {
       
//        CGRect easyRect=CGRectMake(easyLevel.position.x-easyLevel.contentSize.width*0.5,easyLevel.position.y , easyLevel.contentSize.width, easyLevel.contentSize.height);
//        
//     
//        
//        CGRect mediumRect=CGRectMake(mediumLevel.position.x -mediumLevel.contentSize.width*0.5,mediumLevel.position.y   , mediumLevel.contentSize.width, mediumLevel.contentSize.height);
//        
//      
//        CGRect hardRect=CGRectMake(hardLevel.position.x-hardLevel.contentSize.width*0.5,hardLevel.position.y , hardLevel.contentSize.width, hardLevel.contentSize.height);
        
        CGRect easyRect=CGRectMake(ADJUST_DOUBLE(50*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(230*SCREEN_SCALE) , ADJUST_DOUBLE(80*SCREEN_SCALE), ADJUST_DOUBLE(174*SCREEN_SCALE));
        
        
        CGRect mediumRect=CGRectMake(ADJUST_DOUBLE(150*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(230*SCREEN_SCALE)  , ADJUST_DOUBLE(80*SCREEN_SCALE), ADJUST_DOUBLE(174*SCREEN_SCALE));
        
        
        CGRect hardRect=CGRectMake(ADJUST_DOUBLE(255*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(230*SCREEN_SCALE), ADJUST_DOUBLE(80*SCREEN_SCALE), ADJUST_DOUBLE(174*SCREEN_SCALE));
        
        CGRect backRect=CGRectMake(ADJUST_DOUBLE(146*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(170*SCREEN_SCALE), ADJUST_DOUBLE(84*SCREEN_SCALE), ADJUST_DOUBLE(44*SCREEN_SCALE));
        if(CGRectContainsPoint(backRect, location)){
            [self removeChildByTag:MainMenuSceneTagDifficultySprite cleanup:YES];
             [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
            
        }else if (CGRectContainsPoint(easyRect, location)) {
//             [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
            easyLevel.visible=YES;
            mediumLevel.visible=NO;
            hardLevel.visible=NO;
            
            siglePlayerDifficulty=GameDifficultyEasy;
            [self performSelector:@selector(startSinglePlayerGameWithDifficulty:) withObject:[NSNumber numberWithInt:GameDifficultyEasy] afterDelay:0.15];
//            [self startSinglePlayerGameWithDifficulty:GameDifficultyEasy];
        }else if(CGRectContainsPoint(mediumRect, location)){
//             [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
            easyLevel.visible=NO;
            mediumLevel.visible=YES;
            hardLevel.visible=NO;
            
            siglePlayerDifficulty=GameDifficultyMedium;
            [self performSelector:@selector(startSinglePlayerGameWithDifficulty:) withObject:[NSNumber numberWithInt:GameDifficultyMedium] afterDelay:0.15];
//            [self startSinglePlayerGameWithDifficulty:GameDifficultyMedium];
            
        }else if(CGRectContainsPoint(hardRect, location)){
//             [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
            easyLevel.visible=NO;
            mediumLevel.visible=NO;
            hardLevel.visible=YES;
            
            siglePlayerDifficulty=GameDifficultyHard;
            [self performSelector:@selector(startSinglePlayerGameWithDifficulty:) withObject:[NSNumber numberWithInt:GameDifficultyHard] afterDelay:0.15];
//             [self startSinglePlayerGameWithDifficulty:GameDifficultyHard];
        }
        
      
    }else if([self getChildByTag:MainMenuSceneTagRateAppSprite]){
        CGRect doneRect=CGRectMake(ADJUST_DOUBLE(22*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(426*SCREEN_SCALE) , ADJUST_DOUBLE(57*SCREEN_SCALE), ADJUST_DOUBLE(31*SCREEN_SCALE));
        
        CGRect rateRect=CGRectMake(ADJUST_DOUBLE(76*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(309*SCREEN_SCALE)  , ADJUST_DOUBLE(240*SCREEN_SCALE), ADJUST_DOUBLE(43*SCREEN_SCALE));
        
        
        CGRect problemRect=CGRectMake(ADJUST_DOUBLE(76*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(259*SCREEN_SCALE)  , ADJUST_DOUBLE(240*SCREEN_SCALE), ADJUST_DOUBLE(43*SCREEN_SCALE));
        
        if(CGRectContainsPoint(doneRect, location)){
         [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
            
            [self removeChildByTag:MainMenuSceneTagRateAppSprite cleanup:YES];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isAppRated"];
        
        }else if(CGRectContainsPoint(rateRect, location)){
             [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
        
            [self rateBtnTouched:nil];
//            [self performSelector:@selector(rateBtnTouched:) withObject:nil afterDelay:0.5];
//             [btnSelector removeFromParentAndCleanup:YES];
//            
//            btnSelector=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"GUI_Menu_RateApp_A_Selector_Blue.png"]];
//            btnSelector.anchorPoint=ccp(0, 0);
//            btnSelector.position=ADJUST_DOUBLE_XY(55, 183);
//            [rateAppSprite addChild:btnSelector];

        }else if(CGRectContainsPoint(problemRect, location)){
             [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
            [self problemBtnTouched:nil];
//            [self performSelector:@selector(problemBtnTouched:) withObject:nil afterDelay:0.5];
//            [btnSelector removeFromParentAndCleanup:YES];
//            btnSelector=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"GUI_Menu_RateApp_A_Selector_Red.png"]];
//            btnSelector.anchorPoint=ccp(0, 0);
//            btnSelector.position=ADJUST_DOUBLE_XY(55, 134);
//            [rateAppSprite addChild:btnSelector];

        }
       
    }
    else if([self getChildByTag:MainMenuSceneTagRegisterPushNotifications]){
//        CGRect noThanksRect=CGRectMake(ADJUST_DOUBLE(52*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(264*SCREEN_SCALE) , ADJUST_DOUBLE(92*SCREEN_SCALE), ADJUST_DOUBLE(34*SCREEN_SCALE));
//        
//        CGRect okRect=CGRectMake(ADJUST_DOUBLE(200*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(258*SCREEN_SCALE)  , ADJUST_DOUBLE(130*SCREEN_SCALE), ADJUST_DOUBLE(44*SCREEN_SCALE));
//        
//        if (CGRectContainsPoint(noThanksRect, location)) {
//            
//            [self removeChildByTag:MainMenuSceneTagRegisterPushNotifications cleanup:YES  ];
//            
//        }else if(CGRectContainsPoint(okRect, location)){
//        
//            NSString*  _4mnowkey = @"enderval";
//            [[FourmnowSDK sharedFourmnowSDK]requestFourmnowInfoSettingsForDomain: _4mnowkey withDelegate:kAPP_DELEGATE];    
//            [[FourmnowSDK sharedFourmnowSDK]allPush:@"0"];
//
//            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:kAPP_RUN_BEFORE_KEY];
//            
//              [self removeChildByTag:MainMenuSceneTagRegisterPushNotifications cleanup:YES  ];
//        }
    }
    else{
        
        if (CGRectContainsPoint(kSINGLE_PLAYER_BTN_RECT, location) ) {
             [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
//           selectedButton.visible=YES;
//            selectedButton.position=kSINGLE_PLAYER_BTN_POS;
//            selectedButton.scale=1;
//            
            [self performSelector:@selector(singlePlayerButtonTouched:) withObject:nil afterDelay:0.1];
//            [self singlePlayerButtonTouched:nil];
        }else if (CGRectContainsPoint(kMULTI_PLAYER_BTN_RECT, location) ) {
             [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
//            selectedButton.visible=YES;
//            selectedButton.position=kMULTI_PLAYER_BTN_POS;
//            selectedButton.scale=1;
            
            [self performSelector:@selector(multiPlayerButtonTouched:) withObject:nil afterDelay:0.1];
//            [self multiPlayerButtonTouched:nil];
            
        }else if (CGRectContainsPoint(kOPTIONS_BTN_RECT, location) ) {
             [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
//            selectedButton.visible=YES;
//            selectedButton.position=kOPTIONS_BTN_POS;
//            selectedButton.scale=1;
            
            [self performSelector:@selector(optionsButtonTouched:) withObject:nil afterDelay:0.1];
//            [self optionsButtonTouched:nil];
            
        }else if (CGRectContainsPoint(kSTATS_BTN_RECT, location) ) {
             [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
//            selectedButton.visible=YES;
//            selectedButton.position=kSTATS_BTN_POS;
//            selectedButton.scale=1;
            
            [self performSelector:@selector(statsButtonTouched:) withObject:nil afterDelay:0.1];
//            [self statsButtonTouched:nil];
            
        }else if (CGRectContainsPoint(kMORE_GAMES_BTN_RECT, location) ) {
             [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
//            selectedButton.visible=YES;
//            selectedButton.position=kMORE_GAMES_BTN_POS;
//            
            [self performSelector:@selector(moreGamesButtonTouched:) withObject:nil afterDelay:0.3];
//            [self moreGamesButtonTouched:nil];
        }
    }
}
-(void)rateBtnTouched:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:K_ITUNES_RATE_LINK]];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isAppRated"];
    [self removeChildByTag:MainMenuSceneTagRateAppSprite cleanup:YES];
}
-(void)problemBtnTouched:(id)sender{
    [self openMail];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isAppRated"];
}

#pragma mark Action Methods
-(void)HideSelectedBtn{
    selectedButton.visible=NO;
}
-(void)moreGamesButtonTouched:(id)sender{
    if( [[NSUserDefaults standardUserDefaults]boolForKey:kTAPJOY_MORE_SCREEN_ENABLED_KEY]==YES){
    [TapjoyConnect showOffersWithViewController:(UIViewController*)(((AppDelegate*)[UIApplication sharedApplication ].delegate).window.rootViewController)];
    }else {
        ChartBoost *cb=[ChartBoost sharedChartBoost];
        [cb showMoreApps];
    }
//    [self performSelector:@selector(HideSelectedBtn) withObject:nil afterDelay:0.5];
}
-(void)statsButtonTouched:(id)sender{
    [[CCDirector sharedDirector]pushScene:[StatisticsScene scene]];
    [self hideAd];
    
//    [self setAdPositionAtBottom:YES];
    
}
-(void)optionsButtonTouched:(id)sender{
    [[CCDirector sharedDirector]pushScene:[OptionsScene scene]];
    [self hideAd];
    
//    [self setAdPositionAtBottom:YES];
}
-(void)multiPlayerButtonTouched:(id)sender{
    NSString *settingFilePath=[NSString stringWithFormat: @"%@/Documents/%@.plist", NSHomeDirectory(),kSETTING_PLIST_FILE_NAME];//[[NSBundle mainBundle]  pathForResource:kSETTING_PLIST_FILE_NAME ofType:@"plist"];
    
    NSDictionary* settingDict=[[NSDictionary alloc]initWithContentsOfFile:settingFilePath];
    PiecesModels selectedPieceModel=[[settingDict objectForKey:kSETTING_PIECE_MODEL_KEY] intValue];
    BackgroundThemes selectedBackground=[[settingDict objectForKey:kSETTING_BACKGROUND_THEME_KEY] intValue];

    [self goToGameSceneBackgroundTheme:selectedBackground andPieceModel:selectedPieceModel]; 
    [settingDict release];
    
//    [self performSelector:@selector(HideSelectedBtn) withObject:nil afterDelay:0.5];
    
}

-(void)singlePlayerButtonTouched:(id)sender{
    
    [self addDifficultyView];
        
    
//    NSString *settingFilePath=[NSString stringWithFormat: @"%@/Documents/%@.plist", NSHomeDirectory(),kSETTING_PLIST_FILE_NAME];//[[NSBundle mainBundle]  pathForResource:kSETTING_PLIST_FILE_NAME ofType:@"plist"];
//    
//    NSDictionary* settingDict=[[NSDictionary alloc]initWithContentsOfFile:settingFilePath];
//    PiecesThemes selectedPieceTheme=[[settingDict objectForKey:kSETTING_PIECE_MODEL_KEY] intValue];
//    
//    [[CCDirector sharedDirector]pushScene:[[[GameScene alloc]initWithBackgroundTheme:BackgroundThemeForest andPieceTheme:selectedPieceTheme andIsMultiPlayer:NO]autorelease]];
//    
//    [settingDict release];
   selectedButton.visible=NO;
}
-(void)startSinglePlayerGameWithDifficulty:(NSNumber*)difficulty{
    [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
    GameDifficulties diff=[difficulty intValue];
    [self removeChildByTag:MainMenuSceneTagDifficultySprite cleanup:YES];
    
    NSString *settingFilePath=[NSString stringWithFormat: @"%@/Documents/%@.plist", NSHomeDirectory(),kSETTING_PLIST_FILE_NAME];//[[NSBundle mainBundle]  pathForResource:kSETTING_PLIST_FILE_NAME ofType:@"plist"];
    
    NSDictionary* settingDict=[[NSDictionary alloc]initWithContentsOfFile:settingFilePath];
  PiecesModels selectedPieceModel=[[settingDict objectForKey:kSETTING_PIECE_MODEL_KEY] intValue];
        [settingDict release];
    BackgroundThemes selectedBackGroundTheme;
    switch (diff) {
        case GameDifficultyEasy:
            selectedBackGroundTheme=BackgroundThemeForest;
            break;
        case GameDifficultyMedium:
            selectedBackGroundTheme=BackgroundThemeEgypt;
            break;
        case GameDifficultyHard:
            selectedBackGroundTheme=BackgroundThemeKingdom;
            break;
            
        default:
            break;
    }
  
    
    [[CCDirector sharedDirector]pushScene:(CCScene*)[[[GameScene alloc]initWithBackgroundTheme:selectedBackGroundTheme andPieceModel:selectedPieceModel andIsMultiPlayer:NO andDifficulty:diff]autorelease]];
    
}

-(void)goToGameSceneBackgroundTheme:(BackgroundThemes)selectedTheme andPieceModel:(PiecesModels)selectedPieceModel{
    [Controller sharedController].bgTheme=selectedTheme;
    [Controller sharedController].pieceModel=selectedPieceModel;
    [[Controller sharedController] createMatchNewRequest];

}

-(void)addDifficultyView{
    siglePlayerDifficulty=GameDifficultyEasy;
    [frameCache addSpriteFramesWithFile:@"single_difficulty.plist"];
    CCSprite* blurSprite=[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache]addImage:@"GUI_Menu_Blur_A_001.jpg"]];
    blurSprite.position=ccp(screenSize.width*0.5, screenSize.height*0.5);
    [self addChild:blurSprite z:0 tag:MainMenuSceneTagDifficultySprite];
    
    CCSprite* difficultySprite=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"GUI_Menu_Single_A.png"]];
    
    difficultySprite.position=ccp(blurSprite.contentSize.width*0.5, blurSprite.contentSize.height*0.5);
    
    [blurSprite addChild:difficultySprite ];
    
    easyLevel=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"GUI_Button_Difficulty_Easy_A_ON.png"]];
    easyLevel.anchorPoint=ccp(0.5, 1);
    easyLevel.position=ccp(ADJUST_DOUBLE(76), difficultySprite.contentSize.height);
    [difficultySprite addChild:easyLevel];
    
    mediumLevel=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"GUI_Button_Difficulty_Medium_A_ON.png"]];
    mediumLevel.anchorPoint=ccp(0.5, 1);
    mediumLevel.position=ccp(ADJUST_DOUBLE(177), difficultySprite.contentSize.height);
    mediumLevel.visible=NO;
    [difficultySprite addChild:mediumLevel];
    
    hardLevel=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"GUI_Button_Difficulty_Hard_A_ON.png"]];
    hardLevel.anchorPoint=ccp(0.5, 1);
    hardLevel.position=ccp(ADJUST_DOUBLE(280), difficultySprite.contentSize.height);
    hardLevel.visible=NO;
    [difficultySprite addChild:hardLevel];
    

}

//#ifdef LITE_VERSION
-(void)hideAds:(id)sender{
    if (((CCMenuItemToggle*)sender).selectedIndex ==0) {//show
        [[RootViewController sharedRootViewController] setAdViewFrameAtBottom:NO];
    }else{//hide
        [[RootViewController sharedRootViewController] hideAd];
        
    }
}
//#endif

-(void)setAdPositionAtBottom:(BOOL)bottom{
//#ifdef LITE_VERSION
    [[RootViewController sharedRootViewController]setAdViewFrameAtBottom:bottom];
//#endif
}

-(void)hideAd{
//#ifdef LITE_VERSION
    [[RootViewController sharedRootViewController]hideAd];
//#endif
}
-(void)onEnter{
    if ([[Controller sharedController] isFeaturePurchased:kREMOVE_ADS_ID ]) {  
        [self hideAd];
    } else {
         [self setAdPositionAtBottom:NO];
    }
        
   
  
    selectedButton.visible=NO;
    
    [super onEnter];
}

-(void)onExit{
    [[CCTouchDispatcher sharedDispatcher]removeDelegate:self];
    [super onExit];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
//	gkHelper.delegate=nil;
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark Rating Apps
-(void)rateApp{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    int sessionCounter = [[defaults objectForKey:@"sessionCounter"] intValue];
    if (sessionCounter < 5 ) {
		[defaults setObject:[NSNumber numberWithInt:sessionCounter + 1] forKey:@"sessionCounter"];
	}
    else{
        if (![defaults objectForKey:@"isAppRated"]) {
//            [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"isAppRated"];
            
            
            CCSprite* blurSprite=[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache]addImage:@"GUI_Menu_Blur_A_001.jpg"]];
            blurSprite.position=ccp(screenSize.width*0.5, screenSize.height*0.5);
            [self addChild:blurSprite z:0 tag:MainMenuSceneTagRateAppSprite];
//            NSString* rateAppImage;
           
#ifdef LITE_VERSION
             [frameCache addSpriteFramesWithFile:@"rate_app_free.plist"];
#else
             [frameCache addSpriteFramesWithFile:@"rate_app_paid.plist"];
#endif
            rateAppSprite=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"GUI_Menu_RateApp.png"]];
            
            rateAppSprite.position=ccp(blurSprite.contentSize.width*0.5, blurSprite.contentSize.height*0.5);
            
            [blurSprite addChild:rateAppSprite ];
            
            
            
            
//            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" 
//                                                                message:@"Hey, Thanks for playing!  Would you like to rate Elements+?" 
//                                                               delegate:self 
//                                                      cancelButtonTitle:@"No Thanks" 
//                                                      otherButtonTitles:@"Yes!!", nil];
//            [alertView show];
//            [alertView release];
        }
        
    }
    
    [defaults synchronize];
}

-(void)openMail{
    NSString* subject;
//#ifdef LITE_VERSION
//    subject=@"Rock-a-Tac Free";
//#else
    subject=@"Rock-a-Tac";
//#endif
    
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setToRecipients:[[[NSArray alloc]initWithObjects:@"support@stariosgames.com",nil]autorelease]];
   
    [controller setSubject:subject];
    [controller setEditing:NO];
    
//    NSString *messageBody=@"<p>Check out this awesome game: </p> <a href='http://itunes.apple.com/us/app/siga/id438932271?mt=8'>Siga</a>";
//    [controller setMessageBody:messageBody isHTML:YES];
    
    UIDevice* currentDevice=[UIDevice currentDevice];
 
    
//    NSString *messageBody=@"<p><br\><br\>Please enter your message above this line.  Provide as many details as possible. </p> ";
//    [controller setMessageBody:messageBody isHTML:YES];
    
    NSString *messageBody=[NSString stringWithFormat:@"\n\n Please enter your message above this line.  Provide as many details as possible. \n\n Device Information:\n\n model:%@ \n system version:%@ \n ",currentDevice.model,currentDevice.systemVersion];
    [controller setMessageBody:messageBody isHTML:NO];

    if (controller != nil) {
        AppDelegate* delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
        [delegate.window.rootViewController presentModalViewController:controller animated:YES];
    }
    [controller release];
}
#pragma mark MFMailComposeViewControllerDelegate Method
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
	
	if (result== MFMailComposeResultFailed){
//		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Faild" message:@"Sending Failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//		[alert show];
//		[alert release];
        
        BlockAlertView* alert=[BlockAlertView alertWithTitle: NSLocalizedString(@"Faild", @"Failed") message: NSLocalizedString(@"Sending Failed", @"Sending failed") andLoadingviewEnabled:NO];
        [alert setCancelButtonWithTitle: NSLocalizedString(@"OK", @"OK") block:nil];
        
        [alert show];

	}else if (result==MFMailComposeResultSaved) {
//		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Saved" message:@"message saved to draft" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//		[alert show];
//		[alert release];
        
        BlockAlertView* alert=[BlockAlertView alertWithTitle: NSLocalizedString(@"Saved", @"Saved") message:NSLocalizedString(@"message saved to draft", @"message saved to draft") andLoadingviewEnabled:NO];
        [alert setCancelButtonWithTitle:NSLocalizedString(@"OK", @"OK") block:nil];
        
        [alert show];
        
         [self removeChildByTag:MainMenuSceneTagRateAppSprite cleanup:YES];
	}else if (result==MFMailComposeResultSent) {
//		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Succeeded" message:@"message sent successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//		[alert show];
//		[alert release];
        
        BlockAlertView* alert=[BlockAlertView alertWithTitle: NSLocalizedString(@"Succeeded", @"Succeeded") message: NSLocalizedString(@"message sent successfully", @"message sent successfully") andLoadingviewEnabled:NO];
        [alert setCancelButtonWithTitle:NSLocalizedString(@"OK", @"OK") block:nil];
        
        [alert show];
        
         [self removeChildByTag:MainMenuSceneTagRateAppSprite cleanup:YES];
	}else {
        AppDelegate* delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
		[delegate.window.rootViewController dismissModalViewControllerAnimated:YES];
	}
}


#pragma mark push notifications

-(void)registerForPushNotifications{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    int appRunsBefore = [defaults integerForKey:kAPP_RUN_BEFORE_KEY];
    if (appRunsBefore ==0  && [[Controller sharedController] connectedToWeb]) {
//        [[UIApplication sharedApplication] unregisterForRemoteNotifications ];
        
		CCSprite* blurSprite=[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache]addImage:@"GUI_Menu_Blur_A_001.jpg"]];
        blurSprite.position=ccp(screenSize.width*0.5, screenSize.height*0.5);
        [self addChild:blurSprite z:0 tag:MainMenuSceneTagRegisterPushNotifications];
        
        pushNotificationsRequest=[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache]addImage:@"GUI_Menu_Notification_A001.png"]];
        
        pushNotificationsRequest.position=ccp(blurSprite.contentSize.width*0.5, blurSprite.contentSize.height*0.5);
        
        [blurSprite addChild:pushNotificationsRequest ];
        
        NSString*  _4mnowkey = @"enderval";
        [[FourmnowSDK sharedFourmnowSDK]requestFourmnowInfoSettingsForDomain: _4mnowkey withDelegate:kAPP_DELEGATE];    
        [[FourmnowSDK sharedFourmnowSDK]allPush:@"0"];
	}
}

#pragma mark AppDelegateProtocol
-(void)onDidRegisterForRemoteNotifications{

    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:kAPP_RUN_BEFORE_KEY];
    [self removeChildByTag:MainMenuSceneTagRegisterPushNotifications cleanup:YES  ];
}
-(void)onDidFailToRegisterForRemoteNotifications{

    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:kAPP_RUN_BEFORE_KEY];
    
    [self removeChildByTag:MainMenuSceneTagRegisterPushNotifications cleanup:YES  ];
    
}
@end
