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
#import "Chartboost.h"


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
        
        selectedButton=[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache]addImage:@"main_menu_button_selected.png"]];
        selectedButton.position=kMULTI_PLAYER_BTN_POS;
        
        if (IS_IPAD() && IS_RETINA()){
            bgSprite.scaleX = 2;
            bgSprite.scaleY = 1.8;
            selectedButton.scaleX = 2.1;
            selectedButton.scaleY = 2.3;
        }
        
        [self addChild:bgSprite];
        [self addChild:selectedButton];
        
        self.isTouchEnabled=YES;
        
        [self rateApp];
        [self registerForPushNotifications];
        
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
            if (IS_IPAD() && IS_RETINA()){
                AdBg.scaleX=2;
                AdBg.scaleY=1.5;
            }
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
        if(CGRectContainsPoint(DONE_RECT, location)){
//            [self removeChildByTag:MainMenuSceneTagRateAppSprite cleanup:YES];
//            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isAppRated"];
        }else if(CGRectContainsPoint(RATE_RECT, location)){
            btnSelector=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"GUI_Menu_RateApp_A_Selector_Blue.png"]];
            btnSelector.anchorPoint=ccp(0, 0);
            if (IS_IPAD() && IS_RETINA()) {
                btnSelector.position=ADJUST_DOUBLE_XY(28, 93);
            }else{
               btnSelector.position=ADJUST_DOUBLE_XY(55, 290); 
            }
            [rateAppSprite addChild:btnSelector];
        }else if(CGRectContainsPoint(PROBLEM_RECT, location)){
            [btnSelector removeFromParentAndCleanup:YES];
            btnSelector=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"GUI_Menu_RateApp_A_Selector_Red.png"]];
            btnSelector.anchorPoint=ccp(0, 0);
            if (IS_IPAD() && IS_RETINA()) {
                btnSelector.position=ADJUST_DOUBLE_XY(28, 67);
            }else{
                btnSelector.position=ADJUST_DOUBLE_XY(55, 240);
            }
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
    
    if (btnSelector) {
        [btnSelector removeFromParentAndCleanup:YES];
        btnSelector = NULL;
    }
    
    CGPoint location = [touch locationInView:[touch view]]; 
    location = [[CCDirector sharedDirector] convertToGL:location]; 
    
    if ([self getChildByTag:MainMenuSceneTagDifficultySprite]) {
//        CGRect easyRect=CGRectMake(easyLevel.position.x-easyLevel.contentSize.width*0.5,easyLevel.position.y , easyLevel.contentSize.width, easyLevel.contentSize.height);
//        CGRect mediumRect=CGRectMake(mediumLevel.position.x -mediumLevel.contentSize.width*0.5,mediumLevel.position.y   , mediumLevel.contentSize.width, mediumLevel.contentSize.height);
//        CGRect hardRect=CGRectMake(hardLevel.position.x-hardLevel.contentSize.width*0.5,hardLevel.position.y , hardLevel.contentSize.width, hardLevel.contentSize.height);
        
        if(CGRectContainsPoint(BACK_RECT, location)){
            [self removeChildByTag:MainMenuSceneTagDifficultySprite cleanup:YES];
            [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
        }else if (CGRectContainsPoint(EASY_RECT, location)) {
//             [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
            easyLevel.visible=YES;
            mediumLevel.visible=NO;
            hardLevel.visible=NO;
            siglePlayerDifficulty=GameDifficultyEasy;
            [self performSelector:@selector(startSinglePlayerGameWithDifficulty:) withObject:[NSNumber numberWithInt:GameDifficultyEasy] afterDelay:0.15];
//            [self startSinglePlayerGameWithDifficulty:GameDifficultyEasy];
        }else if(CGRectContainsPoint(MEDIUM_RECT, location)){
//             [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
            easyLevel.visible=NO;
            mediumLevel.visible=YES;
            hardLevel.visible=NO;
            siglePlayerDifficulty=GameDifficultyMedium;
            [self performSelector:@selector(startSinglePlayerGameWithDifficulty:) withObject:[NSNumber numberWithInt:GameDifficultyMedium] afterDelay:0.15];
//            [self startSinglePlayerGameWithDifficulty:GameDifficultyMedium];
        }else if(CGRectContainsPoint(HARD_RECT, location)){
//             [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
            easyLevel.visible=NO;
            mediumLevel.visible=NO;
            hardLevel.visible=YES;
            siglePlayerDifficulty=GameDifficultyHard;
            [self performSelector:@selector(startSinglePlayerGameWithDifficulty:) withObject:[NSNumber numberWithInt:GameDifficultyHard] afterDelay:0.15];
//             [self startSinglePlayerGameWithDifficulty:GameDifficultyHard];
        }
    }
    else if([self getChildByTag:MainMenuSceneTagRegisterPushNotifications]){
        if (CGRectContainsPoint(NO_THANKS_RECT, location)) {
            [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:kAPP_RUN_BEFORE_KEY];
            [[NSUserDefaults standardUserDefaults] synchronize];            
            [self removeChildByTag:MainMenuSceneTagRegisterPushNotifications cleanup:YES];
        }else if(CGRectContainsPoint(OK_RECT, location)){
            [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            [appDelegate registerForRemoteNotifications];
//            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:kAPP_RUN_BEFORE_KEY];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            [self removeChildByTag:MainMenuSceneTagRegisterPushNotifications cleanup:YES];
        }
    }
    else if([self getChildByTag:MainMenuSceneTagRateAppSprite]){
        if(CGRectContainsPoint(DONE_RECT, location)){
            [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
            [self removeChildByTag:MainMenuSceneTagRateAppSprite cleanup:YES];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isAppRated"];
        }else if(CGRectContainsPoint(RATE_RECT, location)){
            [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
            [self rateBtnTouched:nil];
//            [self performSelector:@selector(rateBtnTouched:) withObject:nil afterDelay:0.5];
//             [btnSelector removeFromParentAndCleanup:YES];
//            btnSelector=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"GUI_Menu_RateApp_A_Selector_Blue.png"]];
//            btnSelector.anchorPoint=ccp(0, 0);
//            btnSelector.position=ADJUST_DOUBLE_XY(55, 183);
//            [rateAppSprite addChild:btnSelector];
        }else if(CGRectContainsPoint(PROBLEM_RECT, location)){
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
    else{
        if (CGRectContainsPoint(kSINGLE_PLAYER_BTN_RECT, location) ) {
             [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
//           selectedButton.visible=YES;
//            selectedButton.position=kSINGLE_PLAYER_BTN_POS;
//            selectedButton.scale=1;
            [self performSelector:@selector(singlePlayerButtonTouched:) withObject:nil afterDelay:0.08];
//            [self singlePlayerButtonTouched:nil];
        }else if (CGRectContainsPoint(kMULTI_PLAYER_BTN_RECT, location) ) {
             [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
//            selectedButton.visible=YES;
//            selectedButton.position=kMULTI_PLAYER_BTN_POS;
//            selectedButton.scale=1;
            [self performSelector:@selector(multiPlayerButtonTouched:) withObject:nil afterDelay:0.08];
//            [self multiPlayerButtonTouched:nil];
        }else if (CGRectContainsPoint(kOPTIONS_BTN_RECT, location) ) {
             [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
//            selectedButton.visible=YES;
//            selectedButton.position=kOPTIONS_BTN_POS;
//            selectedButton.scale=1;
            [self performSelector:@selector(optionsButtonTouched:) withObject:nil afterDelay:0.08];
//            [self optionsButtonTouched:nil];
        }else if (CGRectContainsPoint(kSTATS_BTN_RECT, location) ) {
             [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
//            selectedButton.visible=YES;
//            selectedButton.position=kSTATS_BTN_POS;
//            selectedButton.scale=1;
            [self performSelector:@selector(statsButtonTouched:) withObject:nil afterDelay:0.08];
//            [self statsButtonTouched:nil];
        }else if (CGRectContainsPoint(kMORE_GAMES_BTN_RECT, location) ) {
             [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
//            selectedButton.visible=YES;
//            selectedButton.position=kMORE_GAMES_BTN_POS;
            [self performSelector:@selector(moreGamesButtonTouched:) withObject:nil afterDelay:0.2];
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
        Chartboost *cb=[Chartboost sharedChartboost];
        [cb showMoreApps];
    }
//    [self performSelector:@selector(HideSelectedBtn) withObject:nil afterDelay:0.5];
}

-(void)statsButtonTouched:(id)sender{
    selectedButton.visible=NO;
    [[CCDirector sharedDirector]pushScene:[StatisticsScene scene]];
    [self hideAd];
//    [self setAdPositionAtBottom:YES];
}

-(void)optionsButtonTouched:(id)sender{
    selectedButton.visible=NO;
    [[CCDirector sharedDirector]pushScene:[OptionsScene scene]];
    [self hideAd];
//    [self setAdPositionAtBottom:YES];
}

-(void)multiPlayerButtonTouched:(id)sender{
    selectedButton.visible=NO;
    NSString *settingFilePath=[NSString stringWithFormat: @"%@/Documents/%@.plist", NSHomeDirectory(),kSETTING_PLIST_FILE_NAME];//[[NSBundle mainBundle]  pathForResource:kSETTING_PLIST_FILE_NAME ofType:@"plist"];
    
    NSDictionary* settingDict=[[NSDictionary alloc]initWithContentsOfFile:settingFilePath];
    PiecesModels selectedPieceModel=[[settingDict objectForKey:kSETTING_PIECE_MODEL_KEY] intValue];
    BackgroundThemes selectedBackground=[[settingDict objectForKey:kSETTING_BACKGROUND_THEME_KEY] intValue];

    [self goToGameSceneBackgroundTheme:selectedBackground andPieceModel:selectedPieceModel]; 
    [settingDict release];
    
//    [self performSelector:@selector(HideSelectedBtn) withObject:nil afterDelay:0.5];
}

-(void)singlePlayerButtonTouched:(id)sender{
    selectedButton.visible=NO;
    [self addDifficultyView];
        
//    NSString *settingFilePath=[NSString stringWithFormat: @"%@/Documents/%@.plist", NSHomeDirectory(),kSETTING_PLIST_FILE_NAME];//[[NSBundle mainBundle]  pathForResource:kSETTING_PLIST_FILE_NAME ofType:@"plist"];
//    
//    NSDictionary* settingDict=[[NSDictionary alloc]initWithContentsOfFile:settingFilePath];
//    PiecesThemes selectedPieceTheme=[[settingDict objectForKey:kSETTING_PIECE_MODEL_KEY] intValue];
//    
//    [[CCDirector sharedDirector]pushScene:[[[GameScene alloc]initWithBackgroundTheme:BackgroundThemeForest andPieceTheme:selectedPieceTheme andIsMultiPlayer:NO]autorelease]];
//    
//    [settingDict release];
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
    
    mediumLevel=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"GUI_Button_Difficulty_Medium_A_ON.png"]];
    mediumLevel.anchorPoint=ccp(0.5, 1);
    mediumLevel.visible=NO;
    
    hardLevel=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"GUI_Button_Difficulty_Hard_A_ON.png"]];
    hardLevel.anchorPoint=ccp(0.5, 1);
    hardLevel.visible=NO;
    
    if (IS_IPAD() && IS_RETINA()) {
        blurSprite.scaleX = 2;
        blurSprite.scaleY = 1.8;
        easyLevel.position=ccp(ADJUST_DOUBLE(40), difficultySprite.contentSize.height);
        mediumLevel.position=ccp(ADJUST_DOUBLE(90), difficultySprite.contentSize.height);
        hardLevel.position=ccp(ADJUST_DOUBLE(140), difficultySprite.contentSize.height);
    }else{
        easyLevel.position=ccp(ADJUST_DOUBLE(76), difficultySprite.contentSize.height);
        mediumLevel.position=ccp(ADJUST_DOUBLE(177), difficultySprite.contentSize.height);
        hardLevel.position=ccp(ADJUST_DOUBLE(280), difficultySprite.contentSize.height);
    }
    
    [difficultySprite addChild:easyLevel];
    [difficultySprite addChild:mediumLevel];
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
            if (IS_IPAD() && IS_RETINA()) {
                blurSprite.scaleX = 2;
                blurSprite.scaleY = 1.8;
            }
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
        
		CCSprite *blurSprite=[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache]addImage:@"GUI_Menu_Blur_A_001.jpg"]];
        blurSprite.position=ccp(screenSize.width*0.5, screenSize.height*0.5);
        if (IS_IPAD() && IS_RETINA()) {
            blurSprite.scaleX = 2;
            blurSprite.scaleY = 1.8;
        }
        [self addChild:blurSprite z:0 tag:MainMenuSceneTagRegisterPushNotifications];
        
        pushNotificationsRequest=[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache]addImage:@"GUI_Menu_Notification_A001.png"]];
        pushNotificationsRequest.position=ccp(blurSprite.contentSize.width*0.5, blurSprite.contentSize.height*0.5);
        
        [blurSprite addChild:pushNotificationsRequest ];
	}
}

//#pragma mark AppDelegateProtocol
-(void)onDidRegisterForRemoteNotifications{
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:kAPP_RUN_BEFORE_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self removeChildByTag:MainMenuSceneTagRegisterPushNotifications cleanup:YES  ];
}

-(void)onDidFailToRegisterForRemoteNotifications{
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:kAPP_RUN_BEFORE_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self removeChildByTag:MainMenuSceneTagRegisterPushNotifications cleanup:YES  ];
    
}
@end
