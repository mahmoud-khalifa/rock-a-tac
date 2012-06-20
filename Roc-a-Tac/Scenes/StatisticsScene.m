//
//  StatisticsScene.m
//  TicTacToe
//
//  Created by Log n Labs on 1/31/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "StatisticsScene.h"
#import "GameConfig.h"
#import "SimpleAudioEngine.h"
#import "Controller.h"

#import "AppDelegate.h"
#import "ShareClass.h"

@interface StatisticsScene(PrivateMethods)
-(void)backButtonTouched:(id)sender;
-(void)facebookItemTouched:(id)sender;
-(void)twitterItemTouched:(id)sender;
@end
@implementation StatisticsScene
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	StatisticsScene *layer = [StatisticsScene node];
	
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
		
        self.scale=SCREEN_SCALE;
        self.isTouchEnabled=YES;
        
        CCSprite* bgSprite=[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache]addImage:@"GUI_MenuStatistics_A.jpg"]];
        
        bgSprite.position=ccp(screenSize.width*0.5, screenSize.height*0.5);
        
        [self addChild:bgSprite];
        //add labels
        NSUserDefaults*defaults=[NSUserDefaults standardUserDefaults];
        
        //multiplayer:
        int mp_total=[defaults integerForKey:kSTATS_MULTIPLAYER_TOTAL];
        int mp_wins=[defaults integerForKey:kSTATS_MULTIPLAYER_WIN];
        int mp_loses=[defaults integerForKey:kSTATS_MULTIPLAYER_LOSE];
        
        
        CCLabelBMFont* multiplayerTotal=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d",mp_total] fntFile:@"stats_bitmapfont.fnt"];
        multiplayerTotal.anchorPoint=ccp(0, 0.5);
        multiplayerTotal.position=ADJUST_XY(184, 373);
        [self addChild:multiplayerTotal];

        CCLabelBMFont* multiplayerWinLose=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d/%d",mp_wins,mp_loses] fntFile:@"stats_bitmapfont.fnt"];
        multiplayerWinLose.anchorPoint=ccp(0, 0.5);
        multiplayerWinLose.position=ADJUST_XY(184, 355);
        [self addChild:multiplayerWinLose];
        
        
        //single Player Easy
        int easy_total=[defaults integerForKey:kSTATS_SINGLE_EASY_TOTAL];
        int easy_wins=[defaults integerForKey:kSTATS_SINGLE_EASY_WIN];
        int easy_loses=[defaults integerForKey:kSTATS_SINGLE_EASY_LOSE];
        
        
        CCLabelBMFont* easyTotal=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d",easy_total] fntFile:@"stats_bitmapfont.fnt"];
        easyTotal.anchorPoint=ccp(0, 0.5);
        easyTotal.position=ADJUST_XY(184, 284);
        [self addChild:easyTotal];
        
        CCLabelBMFont* easyWinLose=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d/%d",easy_wins,easy_loses] fntFile:@"stats_bitmapfont.fnt"];
        easyWinLose.anchorPoint=ccp(0, 0.5);
        easyWinLose.position=ADJUST_XY(184, 266);
        [self addChild:easyWinLose];
        
        //single Player Medium
        int medium_total=[defaults integerForKey:kSTATS_SINGLE_MEDIUM_TOTAL];
        int medium_wins=[defaults integerForKey:kSTATS_SINGLE_MEDIUM_WIN];
        int medium_loses=[defaults integerForKey:kSTATS_SINGLE_MEDIUM_LOSE];
        
        
        CCLabelBMFont* mediumTotal=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d",medium_total] fntFile:@"stats_bitmapfont.fnt"];
        mediumTotal.anchorPoint=ccp(0, 0.5);
        mediumTotal.position=ADJUST_XY(184, 194);
        [self addChild:mediumTotal];
        
        CCLabelBMFont* mediumWinLose=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d/%d",medium_wins,medium_loses] fntFile:@"stats_bitmapfont.fnt"];
        mediumWinLose.anchorPoint=ccp(0, 0.5);
        mediumWinLose.position=ADJUST_XY(184, 176);
        [self addChild:mediumWinLose];
        
        //single Player Hard
        int hard_total=[defaults integerForKey:kSTATS_SINGLE_HARD_TOTAL];
        int hard_wins=[defaults integerForKey:kSTATS_SINGLE_HARD_WIN];
        int hard_loses=[defaults integerForKey:kSTATS_SINGLE_HARD_LOSE];
        
        
        CCLabelBMFont* hardTotal=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d",hard_total] fntFile:@"stats_bitmapfont.fnt"];
        hardTotal.anchorPoint=ccp(0, 0.5);
        hardTotal.position=ADJUST_XY(184, 103);
        [self addChild:hardTotal];
        
        CCLabelBMFont* hardWinLose=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d/%d",hard_wins,hard_loses] fntFile:@"stats_bitmapfont.fnt"];
        hardWinLose.anchorPoint=ccp(0, 0.5);
        hardWinLose.position=ADJUST_XY(184, 85);
        [self addChild:hardWinLose];
        
        CCSprite* gameCenter=[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache]addImage:@"gamecenter_icon.png"]];
        CCSprite* gameCenter_selected=[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache]addImage:@"gamecenter_icon_selected.png"]];
        gameCenter_selected.color=ccGRAY;
        CCMenuItemSprite*gameCenterItem=[CCMenuItemSprite itemFromNormalSprite:gameCenter selectedSprite:gameCenter_selected target:self selector:@selector(gameCenterItemTouched:)];
        
        gameCenterItem.position=ADJUST_XY(12,24 );
        gameCenterItem.scale=0.8;
        //facebook button:
        CCSprite* facebook=[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache]addImage:@"share_fb.png"]];
        CCSprite* facebook_selected=[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache]addImage:@"share_fb_selected.png"]];
        CCMenuItemSprite*facebookItem=[CCMenuItemSprite itemFromNormalSprite:facebook selectedSprite:facebook_selected target:self selector:@selector(facebookItemTouched:)];
        
        facebookItem.position=ADJUST_XY(90, 21);
        facebookItem.scaleX=0.85;
//        facebookItem.scaleY=0.95;
        
        //facebook button:
        CCSprite* twitter=[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache]addImage:@"share_twitter.png"]];
        CCSprite* twitter_selected=[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache]addImage:@"share_twitter_selected.png"]];
        CCMenuItemSprite*twitterItem=[CCMenuItemSprite itemFromNormalSprite:twitter selectedSprite:twitter_selected target:self selector:@selector(twitterItemTouched:)];
        
        twitterItem.position=ADJUST_XY((90+104), 20);
        twitterItem.scaleX=0.85;
//        twitterItem.scaleY=0.95;
        
        CCMenu* menu=[CCMenu menuWithItems:gameCenterItem,facebookItem,twitterItem, nil];
//        menu.scale=0.85;
        menu.position=ccp(0,0);
        menu.anchorPoint=ccp(0,0);
        
        [self addChild:menu];
        
        NSArray *nums=[NSArray arrayWithObjects:[NSNumber numberWithInt:easy_wins],[NSNumber numberWithInt:medium_wins],[NSNumber numberWithInt:hard_wins],[NSNumber numberWithInt:mp_wins], nil];
        
        int maxNum=[[nums valueForKeyPath:@"@max.intValue"] intValue];
        leaderboardCategory=[[NSString alloc]init];
        if (maxNum!=0) {
            if(maxNum==mp_wins) {
            leaderboardCategory=kLEADERBOARD_CATEGORY_MULTIPLAYER;
            }else if (maxNum==easy_wins) {
                leaderboardCategory=kLEADERBOARD_CATEGORY_EASY;
            }else if(maxNum==medium_wins) {
                 leaderboardCategory=kLEADERBOARD_CATEGORY_MEDIUM;
            }else if(maxNum==hard_wins) {
                 leaderboardCategory=kLEADERBOARD_CATEGORY_HARD;
            }
        }else {
            leaderboardCategory=kLEADERBOARD_CATEGORY_EASY;
        }
        
        
        
        okBtnSelector=[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache]addImage:@"GUI_Button_OK_Selector.png"]];
        okBtnSelector.anchorPoint=ccp(0, 1);
         okBtnSelector.position=ADJUST_XY(248, 56);
        [self addChild:okBtnSelector];
        okBtnSelector.visible=NO;
          
    }
	return self;
}

-(void)gameCenterItemTouched:(id)sender{
    [[Controller sharedController]showLeaderBoardWithCategory:leaderboardCategory];
}
-(void)facebookItemTouched:(id)sender{
    [ShareClass shareOnFacebook];
}

-(void)twitterItemTouched:(id)sender{
    [ShareClass tweet];
    
}

-(void)backButtonTouched:(id)sender{
     [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
    [[CCDirector sharedDirector]popScene];
}

#pragma Touches
#pragma Tracking Touches
-(void) registerWithTouchDispatcher{ 
    [[CCTouchDispatcher sharedDispatcher]addTargetedDelegate:self priority:-1 swallowsTouches:YES];
    
}
-(BOOL) ccTouchBegan:(UITouch *)touch  withEvent:(UIEvent *)event{
    CGPoint location = [touch locationInView:[touch view]]; 
    
    location = [[CCDirector sharedDirector] convertToGL:location];
    if(CGRectContainsPoint(kOPTIONS_SCENE_OK_BUTTON_RECT, location)){
        
        okBtnSelector.visible=YES;
    }
    return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    
    
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    okBtnSelector.visible=NO;
    CGPoint location = [touch locationInView:[touch view]]; 
    
    location = [[CCDirector sharedDirector] convertToGL:location];

    if(CGRectContainsPoint(kOPTIONS_SCENE_OK_BUTTON_RECT, location)){
        
       
       
        //self.isTouchEnabled=NO;
      
        [self backButtonTouched:nil];
//        [self performSelector:@selector(backButtonTouched:) withObject:nil afterDelay:0.6 ];
        
        
    }

}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// don't forget to call "super dealloc"
	[super dealloc];
    [leaderboardCategory release];
}

@end
