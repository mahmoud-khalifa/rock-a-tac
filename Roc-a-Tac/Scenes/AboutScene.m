//
//  AboutScene.m
//  Roc-a-Tac
//
//  Created by lognlabs on 8/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AboutScene.h"
#import "GameConfig.h"
#import "SimpleAudioEngine.h"

#import "NewsScreenViewController.h"

#import "AppDelegate.h"


@implementation AboutScene

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	AboutScene *layer = [AboutScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        self.isTouchEnabled = YES;
        gameController=    [Controller sharedController]; 
//        gameController.delegate=self;
        
        self.scale=SCREEN_SCALE;
        self.isTouchEnabled=YES;
        
        CCSprite* bgSprite=[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache]addImage:@"GUI_MenuAbout_A.png"]];
        
        bgSprite.position=ccp(screenSize.width*0.5, screenSize.height*0.5);
        //        bgSprite.position=ccp(screenSize.width*0.5, screenSize.height*0.45);
        
        [self addChild:bgSprite];
       
        buttonSelector=[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache]addImage: @"GUI_Menu_Options_Selector_Small.png"]];
        [self addChild:buttonSelector];
        buttonSelector.visible=NO;
        
    }
	return self;
}

-(void) registerWithTouchDispatcher{ 
    [[CCTouchDispatcher sharedDispatcher]addTargetedDelegate:self priority:-1 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch  withEvent:(UIEvent *)event{
    
    CGPoint location = [touch locationInView:[touch view]]; 
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    CGRect cancelRect=CGRectMake(ADJUST_DOUBLE (150*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(50*SCREEN_SCALE), ADJUST_DOUBLE(90*SCREEN_SCALE),ADJUST_DOUBLE(40*SCREEN_SCALE)) ;
      
    if(CGRectContainsPoint (cancelRect, location)){
        buttonSelector.position=ADJUST_XY(162, 34);
        buttonSelector.visible=YES;
        buttonSelector.scale = 1.3;
        buttonSelector.scaleX = 1.8;
    }
    return YES;
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
    
    CGRect cancelRect=CGRectMake(ADJUST_DOUBLE (150*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(50*SCREEN_SCALE), ADJUST_DOUBLE(90*SCREEN_SCALE),ADJUST_DOUBLE(40*SCREEN_SCALE)) ;
    
    if(CGRectContainsPoint (cancelRect, location)){
        [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
        self.isTouchEnabled=NO;
        [[CCDirector sharedDirector]popScene];
    }
    
}

-(void)onExit{
    [[CCTouchDispatcher sharedDispatcher]removeDelegate:self];
    [super onExit];
}

- (void) dealloc
{
	[super dealloc];
}


@end
