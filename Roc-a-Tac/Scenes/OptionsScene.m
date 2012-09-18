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
        
        forestSprite.position=ADJUST_XY(60, 354);
        forestSprite.visible=NO;
        forestSprite.tag=BackgroundThemeForest;
        [self addChild:forestSprite];
        
        egyptSprite=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"GUI_Button_Level_B_ON.png"]];
        
        egyptSprite.position=ADJUST_XY(160, 354);
        egyptSprite.visible=NO;
        egyptSprite.tag=BackgroundThemeEgypt;
        [self addChild:egyptSprite];
        
        kingdomSprite=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"GUI_Button_Level_C_ON.png"]];
        
        kingdomSprite.position=ADJUST_XY(262, 354);
        kingdomSprite.visible=NO;
        kingdomSprite.tag=BackgroundThemeKingdom;
        [self addChild:kingdomSprite];
        
        
        
        heroTeamSprite=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"GUI_Button_Team_A_Hero_ON.png"]];
//        heroTeamSprite.position=ADJUST_XY(86, 155);
        heroTeamSprite.position=ADJUST_XY(50, 155);
        heroTeamSprite.visible=NO;
        heroTeamSprite.tag=PiecesThemeA+BackgroundThemeMAX;
        [self addChild:heroTeamSprite];
        
        villainTeamSprite=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"GUI_Button_Team_A_Villain_ON.png"]];
//        villainTeamSprite.position=ADJUST_XY(233, 155);
        villainTeamSprite.position=ADJUST_XY(278, 155);
        villainTeamSprite.visible=NO;
        villainTeamSprite.tag=PiecesThemeB+BackgroundThemeMAX;
        [self addChild:villainTeamSprite];
        
        goldenTeamSprite=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"GUI_Button_Team_A_Golden_ON.png"]];
//        goldenTeamSprite.position=ADJUST_XY(158, 52);
        goldenTeamSprite.position=ADJUST_XY(163, 155);
        goldenTeamSprite.visible=NO;
        goldenTeamSprite.tag=PiecesThemeC+BackgroundThemeMAX;
        [self addChild:goldenTeamSprite];
        
        
        lockSprite=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"GUI_Lock_A.png"]];
//        lockSprite.position=ADJUST_XY(158, 52);
        lockSprite.position=ADJUST_XY(163, 155);
        [self addChild:lockSprite];
        [self setSelectedThemes];
        
        
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
//
//#ifdef LITE_VERSION
    
//    if (![gameController isFeaturePurchased:kREMOVE_ADS_ID ] &&
//        [[NSUserDefaults standardUserDefaults]boolForKey:kBANNER_AD_ENABLED_KEY]) {
    if ([[NSUserDefaults standardUserDefaults]boolForKey:kBANNER_AD_ENABLED_KEY]) {
//        removeAds=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"GUI_Menu_Options_NoAds.png"]];
        removeAds=[CCSprite spriteWithFile:@"noAdsBtn.png"];
        removeAds.position=ADJUST_XY(21, 62);
        [self addChild:removeAds];
    }
    
//#endif
    
//    news=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"GUI_Menu_Options_News.png"]];
//    news.position=ADJUST_XY(21, 18);
//    [self addChild:news];
    if (![[NSUserDefaults standardUserDefaults]boolForKey:kREMOVE_RESTORE_BUTTON]) {
        restore = [CCSprite spriteWithFile:@"Restore_Button.png"];
        restore.position = ADJUST_XY(160, 62);
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
    
    CGRect newsRect=CGRectMake(ADJUST_DOUBLE(12*SCREEN_SCALE), ADJUST_DOUBLE_WITH_IPAD_TRIMMING(44*SCREEN_SCALE), ADJUST_DOUBLE(84*SCREEN_SCALE), ADJUST_DOUBLE(42*SCREEN_SCALE)) ;
    
    CGRect aboutRect=CGRectMake(ADJUST_DOUBLE (150*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(45*SCREEN_SCALE), ADJUST_DOUBLE(90*SCREEN_SCALE),ADJUST_DOUBLE(44*SCREEN_SCALE));
    
    CGRect restoreRect=CGRectMake(ADJUST_DOUBLE(150*SCREEN_SCALE), ADJUST_DOUBLE_WITH_IPAD_TRIMMING(90*SCREEN_SCALE), ADJUST_DOUBLE(90*SCREEN_SCALE), ADJUST_DOUBLE(44*SCREEN_SCALE)) ;

//#ifdef LITE_VERSION 
   
    if (![gameController isFeaturePurchased:kREMOVE_ADS_ID ]&&
        [[NSUserDefaults standardUserDefaults]boolForKey:kBANNER_AD_ENABLED_KEY]) {    
     CGRect removeAdsRect=CGRectMake(ADJUST_DOUBLE(12*SCREEN_SCALE), ADJUST_DOUBLE_WITH_IPAD_TRIMMING(90*SCREEN_SCALE), ADJUST_DOUBLE(84*SCREEN_SCALE), ADJUST_DOUBLE(42*SCREEN_SCALE)) ;
        if (CGRectContainsPoint (removeAdsRect, location)) {
//            buttonSelector.position=ADJUST_XY(21, 62);
            buttonSelector.position=removeAds.position;
            buttonSelector.visible=YES;
            //remove ads
        }
    }
//#endif  
    if(CGRectContainsPoint (newsRect, location)){
        buttonSelector.position=ADJUST_XY(21, 18);
        buttonSelector.visible=YES;
        buttonSelector.scale = 1;
    }
    
    else if(CGRectContainsPoint (aboutRect, location)){
        buttonSelector.position=ADJUST_XY(160, 18);
        buttonSelector.visible=YES;
        buttonSelector.scale = 1.3;
        buttonSelector.scaleX = 1.5;
    }
    
    else if(CGRectContainsPoint (restoreRect, location)){
        buttonSelector.position=ADJUST_XY(160, 62);
        buttonSelector.visible=YES;
        buttonSelector.scale = 1.3;
        buttonSelector.scaleX = 1.5;
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
    
        CGRect forestRect=CGRectMake(forestSprite.position.x-forestSprite.contentSize.width*0.5,forestSprite.position.y-forestSprite.contentSize.height*0.5 , forestSprite.contentSize.width, forestSprite.contentSize.height);
        
        CGRect egyptRect=CGRectMake(egyptSprite.position.x-egyptSprite.contentSize.width*0.5,egyptSprite.position.y-egyptSprite.contentSize.height*0.5 , egyptSprite.contentSize.width, egyptSprite.contentSize.height);
        
        CGRect kingdomRect=CGRectMake(kingdomSprite.position.x-kingdomSprite.contentSize.width*0.5,kingdomSprite.position.y-kingdomSprite.contentSize.height*0.5 , kingdomSprite.contentSize.width, kingdomSprite.contentSize.height);
        
        CGRect heroTeamRect=CGRectMake(heroTeamSprite.position.x-heroTeamSprite.contentSize.width*0.5,heroTeamSprite.position.y-heroTeamSprite.contentSize.height*0.5 + 25, heroTeamSprite.contentSize.width, heroTeamSprite.contentSize.height);
        
        CGRect villainTeamRect=CGRectMake(villainTeamSprite.position.x-villainTeamSprite.contentSize.width*0.5,villainTeamSprite.position.y-villainTeamSprite.contentSize.height*0.5 + 25, villainTeamSprite.contentSize.width, villainTeamSprite.contentSize.height);
        
        CGRect goldenTeamRect=CGRectMake(goldenTeamSprite.position.x-goldenTeamSprite.contentSize.width*0.5,goldenTeamSprite.position.y-goldenTeamSprite.contentSize.height*0.5 + 25, goldenTeamSprite.contentSize.width, goldenTeamSprite.contentSize.height);
        
        
        CGRect newsRect=CGRectMake(ADJUST_DOUBLE(12*SCREEN_SCALE), ADJUST_DOUBLE_WITH_IPAD_TRIMMING(44*SCREEN_SCALE), ADJUST_DOUBLE(84*SCREEN_SCALE), ADJUST_DOUBLE(42*SCREEN_SCALE)) ;
        
        CGRect aboutRect=CGRectMake(ADJUST_DOUBLE (150*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(45*SCREEN_SCALE), ADJUST_DOUBLE(90*SCREEN_SCALE),ADJUST_DOUBLE(44*SCREEN_SCALE));
        
        CGRect restoreRect=CGRectMake(ADJUST_DOUBLE(150*SCREEN_SCALE), ADJUST_DOUBLE_WITH_IPAD_TRIMMING(90*SCREEN_SCALE), ADJUST_DOUBLE(90*SCREEN_SCALE), ADJUST_DOUBLE(44*SCREEN_SCALE)) ;
        
//#ifdef LITE_VERSION 
        
        
        if (![gameController isFeaturePurchased:kREMOVE_ADS_ID]&&
            [[NSUserDefaults standardUserDefaults]boolForKey:kBANNER_AD_ENABLED_KEY]) {
            CGRect removeAdsRect=CGRectMake(ADJUST_DOUBLE(12*SCREEN_SCALE), ADJUST_DOUBLE_WITH_IPAD_TRIMMING(90*SCREEN_SCALE), ADJUST_DOUBLE(84*SCREEN_SCALE), ADJUST_DOUBLE(42*SCREEN_SCALE)) ;
            
            if (CGRectContainsPoint (removeAdsRect, location)) {
                [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];        
                buttonSelector.visible=NO;
                
                //remove ads
                [gameController buyFeature:kREMOVE_ADS_ID];
                //NSURL* url=[NSURL URLWithString:kFULL_APP_LINK];
                //[[UIApplication sharedApplication] openURL:url];
            }

        }
     
//#endif  
        if(CGRectContainsPoint (newsRect, location)){
           [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
            buttonSelector.visible=NO;
            //news
            NewsScreenViewController *newsScreen = [[NewsScreenViewController alloc] initWithNibName:nil bundle:nil];
            newsScreen.link =kNEWS_LINK; 
            newsScreen.view.frame = kAPP_DELEGATE.window.frame;
            [newsScreen.view layoutSubviews]; 
            [((UIViewController*)kAPP_DELEGATE.window.rootViewController) presentModalViewController:newsScreen animated:YES];
        }
        
        else if(CGRectContainsPoint (aboutRect, location)){
            [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
            buttonSelector.visible=NO;
            
            [[CCDirector sharedDirector]pushScene:[AboutScene scene]];
        }
        
        else if (CGRectContainsPoint (restoreRect, location)) {
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
        
        if (CGRectContainsPoint(forestRect, location) ) {
             [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
            forestSprite.visible=YES;
            egyptSprite.visible=NO;
            kingdomSprite.visible=NO;
            
            bgTheme=forestSprite.tag;
        
        }else if (CGRectContainsPoint(egyptRect, location) ){
             [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
            forestSprite.visible=NO;
            egyptSprite.visible=YES;
            kingdomSprite.visible=NO;
            
            bgTheme=egyptSprite.tag;
            
        }else if (CGRectContainsPoint(kingdomRect, location) ){
             [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
            forestSprite.visible=NO;
            egyptSprite.visible=NO;
            kingdomSprite.visible=YES;
            
            bgTheme=kingdomSprite.tag;
            
        }else if (CGRectContainsPoint(heroTeamRect, location) ){
             [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
            heroTeamSprite.visible=YES;
            villainTeamSprite.visible=NO;
            goldenTeamSprite.visible=NO;
            
            pieceTheme=heroTeamSprite.tag-BackgroundThemeMAX;
            
        }else if (CGRectContainsPoint(villainTeamRect, location) ){
             [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
            heroTeamSprite.visible=NO;
            villainTeamSprite.visible=YES;
            goldenTeamSprite.visible=NO;
            
            pieceTheme=villainTeamSprite.tag-BackgroundThemeMAX;
            
        }else if (CGRectContainsPoint(goldenTeamRect, location) ){
             [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
            if (lockSprite.visible) {
                
                CCSprite* blurBgSprite=[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache]addImage:@"GUI_Menu_Blur_A_001.jpg"]];
                blurBgSprite.position=ccp(screenSize.width*0.5, screenSize.height*0.5);
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
            okBtnSelector.position=ADJUST_XY(248, 56);
            
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

- (NSString*) storageFilePath
{
	return [NSString stringWithFormat: @"%@/Documents/%@.plist", NSHomeDirectory(),kSETTING_PLIST_FILE_NAME];
}

-(void)onExit{
    [[CCTouchDispatcher sharedDispatcher]removeDelegate:self];
    [super onExit];
}
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
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

- (void) checkPurchasedItems
{
    [[MKStoreManager sharedManager] 
     restorePreviousTransactionsOnComplete:^(void) {
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
         NSLog(@"Restore failed: %@", [error localizedDescription]);
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")  message:NSLocalizedString(@"Error Connecting to Itunes Store", @"Error Connecting to Itunes Store")  delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
         [alert show];
         [alert release];
         /* update views, etc. */
     }];

//    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    
}

@end
