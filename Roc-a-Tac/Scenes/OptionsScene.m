//
//  OptionsScene.m
//  TicTacToe
//
//  Created by Log n Labs on 1/31/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "OptionsScene.h"
#import "GameConfig.h"
#import "SimpleAudioEngine.h"

#import "NewsScreenViewController.h"

#import "AppDelegate.h"

#import "AboutScene.h"


@interface OptionsScene(PrivateMethods)
-(void)setSelectedThemes;
-(void)addButtons;
-(void)exitSceneAndSave;

- (NSString*) storageFilePath;

-(void)alertBackBtntouched:(id)sender;
-(void)alertRightBtntouched:(id)sender;

@end
@implementation OptionsScene
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	OptionsScene *layer = [OptionsScene node];
	
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
        gameController=    [Controller sharedController]; 
        gameController.delegate=self;
        
        frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [frameCache addSpriteFramesWithFile:@"options_scene_textures.plist"];
        
        self.scale=SCREEN_SCALE;
        self.isTouchEnabled=YES;
        
        CCSprite* bgSprite=[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache]addImage:@"GUI_MenuOptions_A.jpg"]];
        bgSprite.position=ccp(screenSize.width*0.5, screenSize.height*0.5);
//        bgSprite.position=ccp(screenSize.width*0.5, screenSize.height*0.45);
        [self addChild:bgSprite];
        
        forestSprite=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"GUI_Button_Level_A_ON.png"]];
        forestSprite.visible=NO;
        forestSprite.tag=BackgroundThemeForest;
        [self addChild:forestSprite];
        
        egyptSprite=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"GUI_Button_Level_B_ON.png"]];
        egyptSprite.visible=NO;
        egyptSprite.tag=BackgroundThemeEgypt;
        [self addChild:egyptSprite];
        
        kingdomSprite=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"GUI_Button_Level_C_ON.png"]];
        kingdomSprite.visible=NO;
        kingdomSprite.tag=BackgroundThemeKingdom;
        [self addChild:kingdomSprite];
        
        
        heroTeamSprite=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"GUI_Button_Team_A_Hero_ON.png"]];
//        heroTeamSprite.position=ADJUST_XY(86, 155);
        heroTeamSprite.visible=NO;
        heroTeamSprite.tag=PiecesThemeA+BackgroundThemeMAX;
        [self addChild:heroTeamSprite];
        
        villainTeamSprite=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"GUI_Button_Team_A_Villain_ON.png"]];
//        villainTeamSprite.position=ADJUST_XY(233, 155);
        villainTeamSprite.visible=NO;
        villainTeamSprite.tag=PiecesThemeB+BackgroundThemeMAX;
        [self addChild:villainTeamSprite];
        
        goldenTeamSprite=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"GUI_Button_Team_A_Golden_ON.png"]];
//        goldenTeamSprite.position=ADJUST_XY(158, 52);
        goldenTeamSprite.visible=NO;
        goldenTeamSprite.tag=PiecesThemeC+BackgroundThemeMAX;
        [self addChild:goldenTeamSprite];
        
        
        lockSprite=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"GUI_Lock_A.png"]];
//        lockSprite.position=ADJUST_XY(158, 52);
        [self addChild:lockSprite];
        [self setSelectedThemes];
        
        if (IS_IPAD() && IS_RETINA()) {
            bgSprite.scaleX = 2;
            bgSprite.scaleY = 1.8;
            
            forestSprite.scaleX = 2;
            forestSprite.scaleY = 1.8;
            forestSprite.position=ADJUST_XY(60, 341);
            
            egyptSprite.scaleX = 2;
            egyptSprite.scaleY = 1.8;
            egyptSprite.position=ADJUST_XY(160, 341);
            
            kingdomSprite.scaleX = 2;
            kingdomSprite.scaleY = 1.8;
            kingdomSprite.position=ADJUST_XY(262, 341);
            
            heroTeamSprite.scaleX = 2;
            heroTeamSprite.scaleY = 1.8;
            heroTeamSprite.position=ADJUST_XY(50, 163);
            
            villainTeamSprite.scaleX = 2;
            villainTeamSprite.scaleY = 1.8;
            villainTeamSprite.position=ADJUST_XY(275, 163);
            
            goldenTeamSprite.scaleX = 2;
            goldenTeamSprite.scaleY = 1.8;
            goldenTeamSprite.position=ADJUST_XY(163, 163);
            
            lockSprite.scaleX = 2;
            lockSprite.scaleY = 1.8;
            lockSprite.position=ADJUST_XY(163, 163);
        }else{
            forestSprite.position=ADJUST_XY(60, 354);
            egyptSprite.position=ADJUST_XY(160, 354);
            kingdomSprite.position=ADJUST_XY(262, 354);
            
            heroTeamSprite.position=ADJUST_XY(50, 155);
            villainTeamSprite.position=ADJUST_XY(278, 155);
            goldenTeamSprite.position=ADJUST_XY(163, 155);
            
            lockSprite.position=ADJUST_XY(163, 155);
        }
        
        [self addButtons];
    }
	return self;
}

-(void)setSelectedThemes{
    NSFileManager* fileManager = [NSFileManager defaultManager];
	NSString *settingFilePath;
	if (![fileManager fileExistsAtPath: [self storageFilePath]])
	{
		settingFilePath= [[NSBundle mainBundle] pathForResource: kSETTING_PLIST_FILE_NAME ofType: @"plist"];
        
		[fileManager copyItemAtPath: settingFilePath toPath: [self storageFilePath] error: nil];
	}

    settingDict=[[NSMutableDictionary alloc]initWithContentsOfFile:[self storageFilePath]];
    
    bgTheme=[[settingDict objectForKey:kSETTING_BACKGROUND_THEME_KEY] intValue];
    pieceTheme=[[settingDict objectForKey:kSETTING_PIECE_MODEL_KEY] intValue];
    
    int goldenTeamLocked=[[settingDict objectForKey:kSETTING_GOLDEN_TEAM_LOCKED] intValue];
    lockSprite.visible=goldenTeamLocked;
    
    [self getChildByTag:bgTheme].visible=YES;
    [self getChildByTag:pieceTheme+BackgroundThemeMAX].visible=YES;
}

-(void)addButtons{
//#ifdef LITE_VERSION
//    if (![gameController isFeaturePurchased:kREMOVE_ADS_ID ] &&
//        [[NSUserDefaults standardUserDefaults]boolForKey:kBANNER_AD_ENABLED_KEY]) {
    if ([[NSUserDefaults standardUserDefaults]boolForKey:kBANNER_AD_ENABLED_KEY]) {
//        removeAds=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"GUI_Menu_Options_NoAds.png"]];
        removeAds=[CCSprite spriteWithFile:@"noAdsBtn.png"];
        if(IS_IPAD() && IS_RETINA()){
            removeAds.scaleX = 2;
            removeAds.scaleY = 1.8;
            removeAds.position=ADJUST_XY(21, 85);
        }else{
            removeAds.position=ADJUST_XY(21, 62);
        }
        [self addChild:removeAds];
    }
//#endif
    
//    news=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"GUI_Menu_Options_News.png"]];
//    news.position=ADJUST_XY(21, 18);
//    [self addChild:news];
    if (![[NSUserDefaults standardUserDefaults]boolForKey:kREMOVE_RESTORE_BUTTON]) {
        restore = [CCSprite spriteWithFile:@"Restore_Button.png"];
        
        if(IS_IPAD() && IS_RETINA()){
            restore.scaleX = 2;
            restore.scaleY = 1.8;
            restore.position=ADJUST_XY(160, 85);
        }else{
            restore.position = ADJUST_XY(160, 62);
        }
        [self addChild:restore];
    }
    
    buttonSelector=[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache]addImage: @"GUI_Menu_Options_Selector_Small.png"]];
    [self addChild:buttonSelector];
    buttonSelector.visible=NO;
}

#pragma Touches
#pragma Tracking Touches
-(void) registerWithTouchDispatcher{ 
    [[CCTouchDispatcher sharedDispatcher]addTargetedDelegate:self priority:-1 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch  withEvent:(UIEvent *)event{
    CGPoint location = [touch locationInView:[touch view]]; 
    location = [[CCDirector sharedDirector] convertToGL:location];
    

//#ifdef LITE_VERSION 
    if (![gameController isFeaturePurchased:kREMOVE_ADS_ID ]&&
        [[NSUserDefaults standardUserDefaults]boolForKey:kBANNER_AD_ENABLED_KEY]) {    
//     CGRect removeAdsRect=CGRectMake(ADJUST_DOUBLE(12*SCREEN_SCALE), ADJUST_DOUBLE_WITH_IPAD_TRIMMING(90*SCREEN_SCALE), ADJUST_DOUBLE(84*SCREEN_SCALE), ADJUST_DOUBLE(42*SCREEN_SCALE)) ;
        if (CGRectContainsPoint (REMOVE_ADS_RECT, location)) {
//            buttonSelector.position=ADJUST_XY(21, 62);
            buttonSelector.position=removeAds.position;
            if (IS_IPAD() && IS_RETINA()) {
                buttonSelector.scaleX = 2;
                buttonSelector.scaleY = 1.8;
            }
            buttonSelector.visible=YES;
            //remove ads
        }
    }
//#endif  
    if(CGRectContainsPoint (NEWS_RECT, location)){
        if (IS_IPAD() && IS_RETINA()) {
            buttonSelector.scaleX = 2;
            buttonSelector.scaleY = 1.8;
            buttonSelector.position=ADJUST_XY(21, 42);
        }else{
            buttonSelector.scale = 1;
            buttonSelector.position=ADJUST_XY(21, 18);
        }
        buttonSelector.visible=YES;
    }
    else if(CGRectContainsPoint (ABOUT_RECT, location)){
        if (IS_IPAD() && IS_RETINA()) {
            buttonSelector.scaleX = 2.8;
            buttonSelector.scaleY = 2;
            buttonSelector.position=ADJUST_XY(160, 42);
        }else{
            buttonSelector.scale = 1.3;
            buttonSelector.scaleX = 1.5;
            buttonSelector.position=ADJUST_XY(160, 18);
        }
        buttonSelector.visible=YES;
    }
    else if(CGRectContainsPoint (RESTORE_RECT, location)){
        if (IS_IPAD() && IS_RETINA()) {
            buttonSelector.scaleX = 2.8;
            buttonSelector.scaleY = 2;
            buttonSelector.position=ADJUST_XY(160, 85);
        }else{
            buttonSelector.scale = 1.3;
            buttonSelector.scaleX = 1.5;
            buttonSelector.position=ADJUST_XY(160, 62);
        }
        buttonSelector.visible=YES;
    }
    return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
 
}

-(void)alertBackBtntouched:(id)sender{
  [self removeChildByTag:kBLUR_BACKGROUND_TAG cleanup:YES];
    self.isTouchEnabled=YES;
}

-(void)alertRightBtntouched:(id)sender{
self.isTouchEnabled=YES;
#ifdef LITE_VERSION
    NSURL* url=[NSURL URLWithString:kFULL_APP_LINK];
    [[UIApplication sharedApplication] openURL:url];
#else
    //            [settingDict setObject:[NSNumber numberWithInt:0] forKey:kSETTING_GOLDEN_TEAM_LOCKED];
    //            lockSprite.visible=NO;
    //           
#endif
    [self removeChildByTag:kBLUR_BACKGROUND_TAG cleanup:YES];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    
    buttonSelector.visible=NO;
    CGPoint location = [touch locationInView:[touch view]]; 
    
    location = [[CCDirector sharedDirector] convertToGL:location];
    CCLOG(@"location x:%f, y:%f",location.x,location.y );
    if ([self getChildByTag: kBLUR_BACKGROUND_TAG ]) {
        if (CGRectContainsPoint(kALERT_BACK_BUTTON_RECT, location) ) {
             [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
//          self.isTouchEnabled=NO;
//            [self performSelector:@selector(alertBackBtntouched:) withObject:nil afterDelay:0.5];
//            [btnSelector removeFromParentAndCleanup:YES];
//            btnSelector=[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache]addImage:@"GUI_Menu_PopUp_A_Selector.png"]];
//            btnSelector.anchorPoint=ccp(0, 0);
//            btnSelector.position=ADJUST_DOUBLE_XY(31, -6);
//            [alertSprite addChild:btnSelector];
            
            [self removeChildByTag:kBLUR_BACKGROUND_TAG cleanup:YES];
//            self.isTouchEnabled=YES;
        }else if(CGRectContainsPoint(kALERT_UNLOCK_BUTTON_RECT, location) ){
            
             [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
            //            self.isTouchEnabled=NO;
//            [self performSelector:@selector(alertRightBtntouched:) withObject:nil afterDelay:0.5];
//            [btnSelector removeFromParentAndCleanup:YES];
//            btnSelector=[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache]addImage:@"GUI_Menu_PopUp_A_Selector.png"]];
//            btnSelector.anchorPoint=ccp(0, 0);
//            btnSelector.position=ADJUST_DOUBLE_XY(166, -6);
//            [alertSprite addChild:btnSelector];
//            self.isTouchEnabled=YES;
//#ifdef LITE_VERSION
//            NSURL* url=[NSURL URLWithString:kFULL_APP_LINK];
//            [[UIApplication sharedApplication] openURL:url];
//             [self removeChildByTag:kBLUR_BACKGROUND_TAG cleanup:YES];
//#else
            [gameController buyFeature:kUNLOCK_GOLDEN_TEAM_ID];
//#endif
        }
    }else{
//#ifdef LITE_VERSION 
        if (![gameController isFeaturePurchased:kREMOVE_ADS_ID]&&
            [[NSUserDefaults standardUserDefaults]boolForKey:kBANNER_AD_ENABLED_KEY]) {
            if (CGRectContainsPoint (REMOVE_ADS_RECT, location)) {
                [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
                buttonSelector.visible=NO;
                //remove ads
                [gameController buyFeature:kREMOVE_ADS_ID];
                //NSURL* url=[NSURL URLWithString:kFULL_APP_LINK];
                //[[UIApplication sharedApplication] openURL:url];
            }
        }
//#endif  
        if(CGRectContainsPoint (NEWS_RECT, location)){
           [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
            buttonSelector.visible=NO;
            NewsScreenViewController *newsScreen = [[NewsScreenViewController alloc] initWithNibName:nil bundle:nil];
            newsScreen.link =kNEWS_LINK; 
            newsScreen.view.frame = kAPP_DELEGATE.window.frame;
            [newsScreen.view layoutSubviews]; 
            [((UIViewController*)kAPP_DELEGATE.window.rootViewController) presentModalViewController:newsScreen animated:YES];
        }
        else if(CGRectContainsPoint (ABOUT_RECT, location)){
            [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
            buttonSelector.visible=NO;
            [[CCDirector sharedDirector]pushScene:[AboutScene scene]];
        }
        else if (CGRectContainsPoint (RESTORE_RECT, location)) {
            [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
            buttonSelector.visible=NO;
            //test restore purchase
            [self checkPurchasedItems];
//            [self paymentQueueRestoreCompletedTransactionsFinished:[SKPaymentQueue defaultQueue]];
            for (NSObject* featureId in purchasedItemIDs) {
                if (featureId==kUNLOCK_GOLDEN_TEAM_ID) {
                    [settingDict setObject:[NSNumber numberWithInt:0] forKey:kSETTING_GOLDEN_TEAM_LOCKED];
                    lockSprite.visible=NO;
                    [self removeChildByTag:kBLUR_BACKGROUND_TAG cleanup:YES];
                }else if(featureId==kREMOVE_ADS_ID){
                    removeAds.visible=NO;
                }
            }
        }
        
        if (CGRectContainsPoint(FOREST_RECT, location) ) {
             [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
            forestSprite.visible=YES;
            egyptSprite.visible=NO;
            kingdomSprite.visible=NO;
            bgTheme=forestSprite.tag;
        }else if (CGRectContainsPoint(EGYPT_RECT, location) ){
             [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
            forestSprite.visible=NO;
            egyptSprite.visible=YES;
            kingdomSprite.visible=NO;
            bgTheme=egyptSprite.tag;
        }else if (CGRectContainsPoint(KINGDOM_RECT, location) ){
             [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
            forestSprite.visible=NO;
            egyptSprite.visible=NO;
            kingdomSprite.visible=YES;
            bgTheme=kingdomSprite.tag;
        }else if (CGRectContainsPoint(HERO_TEAM_RECT, location) ){
             [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
            heroTeamSprite.visible=YES;
            villainTeamSprite.visible=NO;
            goldenTeamSprite.visible=NO;
            pieceTheme=heroTeamSprite.tag-BackgroundThemeMAX;
        }else if (CGRectContainsPoint(VILLAN_TEAM_RECT, location) ){
             [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
            heroTeamSprite.visible=NO;
            villainTeamSprite.visible=YES;
            goldenTeamSprite.visible=NO;
            pieceTheme=villainTeamSprite.tag-BackgroundThemeMAX;
        }else if (CGRectContainsPoint(GOLDEN_TEAM_RECT, location) ){
             [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
            if (lockSprite.visible) {
                CCSprite* blurBgSprite=[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache]addImage:@"GUI_Menu_Blur_A_001.jpg"]];
                blurBgSprite.position=ccp(screenSize.width*0.5, screenSize.height*0.5);
                if (IS_IPAD() && IS_RETINA()) {
                    blurBgSprite.scaleX = 2;
                    blurBgSprite.scaleY = 1.8;
                }
                [self addChild:blurBgSprite z:0 tag:kBLUR_BACKGROUND_TAG];
                NSString* alertImageName;
//#ifdef LITE_VERSION
//                alertImageName=@"GUI_Menu_PopUp_A_Free.png";
//#else
                [frameCache addSpriteFramesWithFile:@"options_scene_textures.plist"];
                alertImageName=@"GUI_Menu_PopUp_A_Paid.png";
//#endif
                alertSprite=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:alertImageName]];
                alertSprite.position=ccp(blurBgSprite.contentSize.width*0.5, blurBgSprite.contentSize.height*0.5);
                [blurBgSprite addChild:alertSprite];
            } else{
                heroTeamSprite.visible=NO;
                villainTeamSprite.visible=NO;
                goldenTeamSprite.visible=YES;
                pieceTheme=goldenTeamSprite.tag-BackgroundThemeMAX;
            }
        }else if(CGRectContainsPoint(kOPTIONS_SCENE_OK_BUTTON_RECT, location)){
            //return to main menu
             [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
        
            CCSprite* okBtnSelector=[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache]addImage:@"GUI_Button_OK_Selector.png"]];
            okBtnSelector.anchorPoint=ccp(0, 1);
            if (IS_IPAD() && IS_RETINA()) {
                okBtnSelector.scaleX = 2;
                okBtnSelector.scaleY = 1.8;
                okBtnSelector.position=ADJUST_XY(248, 75);
            }else{
                okBtnSelector.position=ADJUST_XY(248, 56);
            }
            self.isTouchEnabled=NO;
            [self addChild:okBtnSelector];
            [self performSelector:@selector(exitSceneAndSave) withObject:nil afterDelay:0.6 ];
        }
    }
}

-(void)exitSceneAndSave{
    [settingDict setObject:[NSNumber numberWithInt:bgTheme] forKey:kSETTING_BACKGROUND_THEME_KEY];
    [settingDict setObject:[NSNumber numberWithInt:pieceTheme] forKey:kSETTING_PIECE_MODEL_KEY];
  
    [settingDict writeToFile:[self storageFilePath] atomically: YES];
    
    [[CCDirector sharedDirector]popScene];
    
    float adHeight;
    if (IS_IPAD()) {
        adHeight = 90;
        
    }else{
        adHeight = 50;
    }
    
    CGRect adFrame = CGRectMake(0, adHeight, screenSize.width, adHeight);
    adFrame.origin.y = 0;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate adView].frame = adFrame ;
}

- (NSString*) storageFilePath{
	return [NSString stringWithFormat: @"%@/Documents/%@.plist", NSHomeDirectory(),kSETTING_PLIST_FILE_NAME];
}

-(void)onExit{
    [[CCTouchDispatcher sharedDispatcher]removeDelegate:self];
    [super onExit];
}
// on "dealloc" you need to release all your retained objects
- (void) dealloc{
    [settingDict release];
	// don't forget to call "super dealloc"
	[super dealloc];
}
//#ifndef LITE_VERSION

#pragma Controller Delegate
-(void)onPurchaseFeatureCompleted:(NSString*)featureId{
    if (featureId==kUNLOCK_GOLDEN_TEAM_ID) {
        [settingDict setObject:[NSNumber numberWithInt:0] forKey:kSETTING_GOLDEN_TEAM_LOCKED];
        [settingDict writeToFile:[self storageFilePath] atomically: YES];
        lockSprite.visible=NO;
        [self removeChildByTag:kBLUR_BACKGROUND_TAG cleanup:YES];

    }else if(featureId==kREMOVE_ADS_ID){
        removeAds.visible=NO;
    }
}

- (void) checkPurchasedItems{
    [self activityIndicatorRun];
    
    [[MKStoreManager sharedManager] 
     restorePreviousTransactionsOnComplete:^(void) {
         
         [self activityIndicatorStop];
         
         NSLog(@"Restored.");
         NSLog(@"kREMOVE_ADS_ID:%d",[gameController isFeaturePurchased:kREMOVE_ADS_ID]);
         NSLog(@"kUNLOCK_GOLDEN_TEAM_ID:%d",[gameController isFeaturePurchased:kUNLOCK_GOLDEN_TEAM_ID]);
         
         /* update views, etc. */
         if ([gameController isFeaturePurchased:kUNLOCK_GOLDEN_TEAM_ID]) {
             [settingDict setObject:[NSNumber numberWithInt:0] forKey:kSETTING_GOLDEN_TEAM_LOCKED];
             [settingDict writeToFile:[self storageFilePath] atomically: YES];
             lockSprite.visible=NO;
         }
         
         if ([gameController isFeaturePurchased:kREMOVE_ADS_ID ]) {
             [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kBANNER_AD_ENABLED_KEY];
             removeAds.visible=NO;
         }
         
         restore.visible = NO;
         [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kREMOVE_RESTORE_BUTTON];
         [[NSUserDefaults standardUserDefaults]synchronize];
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Restore Complete", @"Restore Complete")  message:NSLocalizedString(@"Restore have been completed succssefully", @"Restore have been completed succssefully") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
         [alert show];
         [alert release];

    }
     onError:^(NSError *error) {
         
         [self activityIndicatorStop];
         
         NSLog(@"Restore failed: %@", [error localizedDescription]);
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")  message:NSLocalizedString(@"Error Connecting to Itunes Store", @"Error Connecting to Itunes Store")  delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
         [alert show];
         [alert release];
         /* update views, etc. */
     }];

//    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

-(void)activityIndicatorRun {
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    spinner.color = [UIColor greenColor];
    CGRect frame =  spinner.frame;
    frame.origin = ccp(screenSize.width*0.5, screenSize.height*0.5);
    spinner.frame = frame;
    spinner.hidesWhenStopped = YES;
    
//    AppDelegate* delegate = [[AppDelegate alloc] init];
//    [delegate.viewController addSubview:spinner];
    [[[CCDirector sharedDirector] openGLView] addSubview:spinner];
    [spinner startAnimating];
    self.isTouchEnabled = NO;
//    [self schedule:@selector(activityIndicatorStop) interval:5.0f];
}

-(void)activityIndicatorStop {
    self.isTouchEnabled = YES;
    [spinner stopAnimating];
}


@end
