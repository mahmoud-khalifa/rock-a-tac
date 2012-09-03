//
//  GameScene.m
//  TicTacToe
//
//  Created by Log n Labs on 1/31/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "GameConfig.h"
#import "RootViewController.h"
#import "SimpleAudioEngine.h"
#import "StatisticsCollector.h"
#import "AppDelegate.h"


@interface GameScene(PrivateMethods)
-(void)addInstructionsAndTutorialsWithTutorialtype:(TutorialTypes)tutoType;
-(void) addWhoStartFirstView;
-(void) addWaitingTimer;
-(void) resetWaitingTimer;
-(void) decreaseWaitingTime:(ccTime)delta;
-(void) pieceSelected:(id)sender;

-(void) disableWhoFirstMenu;
-(void) showOpponentStartPiece;
-(void) checkWhoStarts;
-(void) setConstantArrays;
-(void) drawLocalPlayerPieces;
-(void) drawOpponentPieces;

-(void) backButtonTouched:(id)sender;
-(void) addScoreLabel;
-(void) newGame;
-(void) resetGameBoard;
-(void) setRightStagePiece;
-(void) setLeftStagePiece;
-(void) usePieceWithType:(PiecesTypes)type forPlayer:(PlayerTypes)playerType;
-(void) checkAddingPieceToBoardAtLocation:(CGPoint)location;

-(void) playerWins:(PlayerTypes)player;
-(void)showGameAlertWithWinner:(PlayerTypes)winner;

-(bool) playerPlayedPiece:(GamePiece*)piece atBoardIndex:(int)index withPlayer: (PlayerTypes)playerType;


-(void) addAvailablePieceWithType:(PiecesTypes)replacedPieceType forPlayer:(PlayerTypes)replacedPiecePlayerType;

-(void)setWhoPlay:(PlayerTypes)playerType;
-(void)singlePlayerComputerTurn;

-(void)playAtRandomPlace;

-(void)animateVulnerablePiecesWithPiece:(PiecesTypes)pieceType andPlayerType:(PlayerTypes)playerType;

-(void)addComputerPieceToBoardAtIndex:(NSNumber*)index;


- (void)logGameStart;
- (void)logGameEnd;
- (void)logGameWin;
- (void)logGameLose;

@end
@implementation GameScene


+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameScene *layer = [GameScene node];
    
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) initWithBackgroundTheme:(BackgroundThemes)selectedTheme andPieceModel:(PiecesModels)selectedPieceModel andIsMultiPlayer:(bool )multiplayer andDifficulty:(GameDifficulties)difficulty
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        
        frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];

        [[CCDirector sharedDirector] purgeCachedData];
        gameDifficulty=difficulty;
        defaults=[NSUserDefaults standardUserDefaults];
        playerWinsBefore=[defaults integerForKey:kSETTING_PLAYER_WINS];
        
        self.isTouchEnabled=YES;
        isMultiplayer=multiplayer;
        gameController=[Controller sharedController];
        gameController.delegate=self;
        lp_score =0;
        opp_score=0;
        isFirstGame=YES;
//        if (isMultiplayer) {
////            gkHelper=[GameKitHelper sharedGameKitHelper];
////            gkHelper.delegate=self;
//            
//            self.isTouchEnabled= gameController.isLocalPlayerTurn;
//        }
        self.scale=SCREEN_SCALE;
        [self setConstantArrays];
        
        selectedPiecesTheme=PiecesThemeA;//selectedPieceTheme;
        localPlayerPiecesModel=selectedPieceModel;
        switch (localPlayerPiecesModel) {
            case PiecesModelDevil:
                opponentPiecesModel=PiecesModelGood;
                break;
            case PiecesModelGood:
            case PiecesModelGold:
                opponentPiecesModel=PiecesModelDevil;
                break;
                
            default:
                break;
        }
        
//        NSLog(@"theme: %d",selectedTheme);
        CCSprite* bgSprite=[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache]addImage:[NSString stringWithFormat:@"lvl_design_%d.jpg",selectedTheme]]];
        //bgSprite.scale=0.833;
        bgSprite.position=ccp(screenSize.width*0.5, screenSize.height*0.5);
        
        [self addChild:bgSprite];
        //        bgSprite.anchorPoint=ccp(0, 0);
        
        [frameCache addSpriteFramesWithFile:@"ingame_textures.plist"];
        
        grid=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"Grid_Test_A.png"]];
        
        if (gameDifficulty==GameDifficultyEasy) {
            grid.visible=YES;
        }else{
            grid.visible=NO;
        }
        
        grid.position=ccp(screenSize.width*0.5, screenSize.height*0.5);
        [self addChild:grid];
        
        boardSpritesArray=[[NSMutableArray alloc]initWithCapacity:kBOARD_OBJECTS_COUNT];
        boardPiecesArray=[[NSMutableArray alloc]initWithCapacity:kBOARD_OBJECTS_COUNT];
        
        lp_availablePiecesCounts=[[NSMutableArray alloc]initWithCapacity:PiecesTypesMAX];
        
        lp_Available_Pieces=[[NSMutableArray alloc]initWithCapacity:PiecesTypesMAX];
        
        opp_availablePiecesCounts=[[NSMutableArray alloc]initWithCapacity:PiecesTypesMAX];
        
        opp_Available_Pieces=[[NSMutableArray alloc]initWithCapacity:PiecesTypesMAX];
        
        CCSprite* back=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"ingame_button_menu.png"]];
        
        CCSprite* back_selected=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"ingame_button_menu.png"]];
        back_selected.color=ccGRAY;
        
        CCMenuItemSprite* backItem=[CCMenuItemSprite itemFromNormalSprite:back selectedSprite:back_selected target:self selector:@selector(backButtonTouched:)];
        backItem.anchorPoint=ccp(0, 1);

        
        CCSprite* grid_btn=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"ingame_button_grid.png"]];
        
        CCSprite* grid_btn_selected=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"ingame_button_grid.png"]];
        grid_btn_selected.color=ccGRAY;
        
        CCMenuItemSprite* grid_btnItem=[CCMenuItemSprite itemFromNormalSprite:grid_btn selectedSprite:grid_btn_selected target:self selector:@selector(gridButtonTouched:)];
        grid_btnItem.anchorPoint=ccp(1, 1);
        int buttonsYPos;
        if(![gameController isFeaturePurchased:kREMOVE_ADS_ID]&&
           [[NSUserDefaults standardUserDefaults]boolForKey:kBANNER_AD_ENABLED_KEY]){
//#ifdef LITE_VERSION
       
        if (IS_IPAD()) {
            buttonsYPos= screenSize.height-90;
        }else{
            buttonsYPos= screenSize.height-60;
        }
//#else
         }else {
              buttonsYPos= screenSize.height;
         }
       
//#endif        
        if (IS_IPAD()) {
            #ifdef ARABIC_VERSION
                backItem.position=ccp(-70, buttonsYPos + 75);
            #else
                backItem.position=ccp(0, buttonsYPos);
            #endif
            
            grid_btnItem.position=ccp(screenSize.width, buttonsYPos);
            
        }else{
            #ifdef ARABIC_VERSION
                backItem.position=ccp(-kXoffsetiPad*0.5 - 35, buttonsYPos+kYoffsetiPad*1.5 + 38);
            #else
                backItem.position=ccp(-kXoffsetiPad*0.5, buttonsYPos+kYoffsetiPad*1.5);
            #endif
            
            grid_btnItem.position=ccp(screenSize.width+kXoffsetiPad*0.5, buttonsYPos+kYoffsetiPad*1.5);
        }
        
        CCMenu* menu=[CCMenu menuWithItems:backItem,grid_btnItem, nil];
        menu.anchorPoint=ccp(0, 0);
        menu.position=ccp(0, 0);
              
        [self addChild:menu z:200];
        
         scale=225.0f/256.0f;
 
        RightStagePiece=[[GamePiece alloc]init];
        RightStagePiece.type=PiecesTypeStone;
        RightStagePiece.theme=selectedPiecesTheme;
        RightStagePiece.model=localPlayerPiecesModel;
        RightStagePiece.animationName=PiecesAnimationNameStatic;
        RightStagePiece.direction=PiecesDirectionLeft;
   
        rightStage=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:[gameController getPieceNameWithPiece:RightStagePiece ]]];
       
        rightStage.position=RIGHT_STAGE_POS;
        rightStage.scale=scale;
        
        [self addChild:rightStage z:5];
        
        //animate Right Stage:
        [rightStage stopAllActions];
        [gameController animateSprite:rightStage withPiece:RightStagePiece WithAnimationName:PiecesAnimationNameIdle andLoop:YES];
        
        //blink RightStage:
        if (!isMultiplayer &&playerWinsBefore==0) {
            
            CCBlink* blink=[CCBlink actionWithDuration:.5 blinks:2];
            CCRepeatForever* repeat=[CCRepeatForever actionWithAction:blink];
            repeat.tag=GameSceneTagBlinkAction;
            [rightStage runAction:repeat];
            
            [rightStage stopActionByTag:GameSceneTagBlinkAction];
            
        }

        LeftStagePiece=[[GamePiece alloc]init];
        LeftStagePiece.type=PiecesTypeStone;
        LeftStagePiece.theme=selectedPiecesTheme;
        LeftStagePiece.model=localPlayerPiecesModel;
        LeftStagePiece.animationName=PiecesAnimationNameStatic;
        LeftStagePiece.direction=PiecesDirectionRight;
        LeftStagePiece.model=opponentPiecesModel;
        
        leftStage=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:[gameController getPieceNameWithPiece:LeftStagePiece ]]];
        leftStage.position=LEFT_STAGE_POS;
        leftStage.scale=scale;
        [self addChild:leftStage z:5];
       
        //animate Right Stage:
        [leftStage stopAllActions];
        [gameController animateSprite:leftStage withPiece:LeftStagePiece WithAnimationName:PiecesAnimationNameIdle andLoop:YES];
        
        //Score Label:
//        [self addScoreLabel];
        
        [self newGame];
        
//        [self addWhoStartFirstView];
        
        [self addInstructionsAndTutorialsWithTutorialtype:TutorialA];
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

-(void)addInstructionsAndTutorialsWithTutorialtype:(TutorialTypes)tutoType{
    if (!isMultiplayer &&playerWinsBefore==0) {
        NSString* tutImageName;
        switch (tutoType) {
            case TutorialA:
                tutImageName=@"GUI_Tuto_PopUp_A.png";
                whoFisrtMenu.isTouchEnabled=NO;
                self.isTouchEnabled=NO;
                break;
            case TutorialB:
                tutImageName=@"GUI_Tuto_PopUp_B.png";
            default:
                break;
        }
        [frameCache addSpriteFramesWithFile:@"alerts2.plist"];
        tutorialSprite=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:tutImageName]];
        tutorialSprite.position=ccp(screenSize.width*0.5, screenSize.height*0.5);
        [self addChild:tutorialSprite z:1000];
        
        CCSprite* back=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"tuto_ok_btn.png"]];
        CCSprite* back_selected=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"tuto_ok_btn.png"]];
        back_selected.color=ccGRAY;
        
        CCMenuItemSprite* backItem=[CCMenuItemSprite itemFromNormalSprite:back selectedSprite:back_selected target:self selector:@selector(removeTutorial:)];
        backItem.anchorPoint=ccp(0, 0);
        backItem.position=ADJUST_DOUBLE_XY(220, 5);
        
        CCMenu* menu=[CCMenu menuWithItems:backItem, nil];
        menu.position=ccp(0, 0);
        menu.anchorPoint=ccp(0, 0);
        [tutorialSprite addChild:menu z:1500];
        
        tutorialSprite.tag=tutoType;
        
//        oldTouchEnabledState=self.isTouchEnabled;
//        
        [[CCDirector sharedDirector]pause];
        
        isTutorialShown = YES;
    }

}

-(void)removeTutorial:(id)sender{
    [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
    if (tutorialSprite.tag==TutorialA) {
//        [self schedule:@selector(decreaseWaitingTime:)];
        whoFisrtMenu.isTouchEnabled=YES;
        self.isTouchEnabled=YES;
    }
    [tutorialSprite removeFromParentAndCleanup:YES];
    tutorialSprite=nil;
    
//    self.isTouchEnabled=oldTouchEnabledState;
    
    [[CCDirector sharedDirector]resume];
    
}

-(void) addWhoStartFirstView{
    
    gameController.opp_startPieceType=PiecesTypeNone;
    gameController.lp_startPieceType=PiecesTypeNone;
    blackOverlaySprite=[CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache]addImage:@"black_overlay.png"] ];
    
    blackOverlaySprite.position=ccp(screenSize.width*0.5, screenSize.height*0.5);
    blackOverlaySprite.opacity=190;
    
    [self addChild:blackOverlaySprite z:100];
    self.isTouchEnabled=NO;
  
    GamePiece* piece=[[GamePiece alloc]init];
    piece.type=PiecesTypeStone;
    piece.theme=selectedPiecesTheme;
    piece.model=localPlayerPiecesModel;
    piece.animationName=PiecesAnimationNameStatic;
    piece.direction=PiecesDirectionCenter;
    
    CCSprite* stone=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:[gameController getPieceNameWithPiece:piece ]]];
    CCSprite* stone_selected=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:[gameController getPieceNameWithPiece:piece ]]];
    stone_selected.color=ccGRAY;
    CCMenuItemSprite* stoneItem =[CCMenuItemSprite itemFromNormalSprite:stone selectedSprite:stone_selected target:self selector:@selector(pieceSelected:)];
    stoneItem.tag=PiecesTypeStone;
    stoneItem.position=ccp  ((blackOverlaySprite.contentSize.width)*0.5-ADJUST_DOUBLE(130),( blackOverlaySprite.contentSize.height*0.5+ADJUST_DOUBLE(40)));
    stoneItem.scale=scale;
    
    piece.type=PiecesTypePaper;
    CCSprite* paper=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:[gameController getPieceNameWithPiece:piece ]]];
    CCSprite* paper_selected=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:[gameController getPieceNameWithPiece:piece ]]];
    paper_selected.color=ccGRAY;
    CCMenuItemSprite* paperItem =[CCMenuItemSprite itemFromNormalSprite:paper selectedSprite:paper_selected target:self selector:@selector(pieceSelected:)];
    paperItem.tag=PiecesTypePaper;
    
    paperItem.position=ccp  ((blackOverlaySprite.contentSize.width)*0.5,( blackOverlaySprite.contentSize.height*0.5+ADJUST_DOUBLE(40)));
    paperItem.scale=scale;
    
    piece.type=PiecesTypeScissor;
    CCSprite* scissor=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:[gameController getPieceNameWithPiece:piece ]]];
    CCSprite* scissor_selected=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:[gameController getPieceNameWithPiece:piece ]]];
    scissor_selected.color=ccGRAY;
    CCMenuItemSprite* scissorItem =[CCMenuItemSprite itemFromNormalSprite:scissor selectedSprite:scissor_selected target:self selector:@selector(pieceSelected:)];
    scissorItem.tag=PiecesTypeScissor;
    scissorItem.position=ccp  ((blackOverlaySprite.contentSize.width)*0.5+ADJUST_DOUBLE(130),( blackOverlaySprite.contentSize.height*0.5+ADJUST_DOUBLE(40)));
    scissorItem.scale=scale;
    
    whoFisrtMenu=[CCMenu menuWithItems:stoneItem,paperItem,scissorItem, nil];

    whoFisrtMenu.anchorPoint=ccp(0, 0);
    whoFisrtMenu.position=ccp(0, 0);
    
    [blackOverlaySprite addChild:whoFisrtMenu];
    
    [self addWaitingTimer];
}

-(void) addWaitingTimer{
    
        waitingTimerLabel=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"00:%02d",30] fntFile:@"score_bitmapfont.fnt"];
        if (blackOverlaySprite) {
            waitingTimerLabel.position=ccp(blackOverlaySprite.contentSize.width*0.5,+ADJUST_DOUBLE(480) );
            [blackOverlaySprite addChild:waitingTimerLabel];
        }else{
            waitingTimerLabel.position =ccp (screenSize.width*0.5,ADJUST_Y(58));
            
            [self addChild:waitingTimerLabel];
        }

//    if (!gameController.isLocalPlayerTurn&& !blackOverlaySprite) {
//        myWaitingTime=0;
//        waitingTime=myWaitingTime;
//
//    }else{
    myWaitingTime=kAPP_DELEGATE.MultiplayerTimeout;//kWAITING_MAX_TIME;
        waitingTime=myWaitingTime;
//    }
    
//    if (playerWinsBefore) {
         [self schedule:@selector(decreaseWaitingTime:)];
//    }
   
}

-(void)resetWaitingTimer{
    
    myWaitingTime=kAPP_DELEGATE.MultiplayerTimeout;//kWAITING_MAX_TIME;
    waitingTime=myWaitingTime;
    [waitingTimerLabel setString:[NSString stringWithFormat:@"00:%0d",myWaitingTime]];
    [self schedule:@selector(decreaseWaitingTime:)];
    
}

-(void)decreaseWaitingTime:(ccTime)delta{
    waitingTime-=delta;
    int currentTime=(int)waitingTime;
    if (myWaitingTime>currentTime && currentTime>=0) {
        myWaitingTime=currentTime;
        
        [waitingTimerLabel setString:[NSString stringWithFormat:@"00:%02d",myWaitingTime]];
        if (myWaitingTime==10) {
             [[SimpleAudioEngine sharedEngine]playEffect:@"dingTickTock.mp3"];
        }
        if (myWaitingTime<10) {
            [waitingTimerLabel runAction:[CCBlink actionWithDuration:0.5 blinks:1]];
            
//            [[SimpleAudioEngine sharedEngine]playEffect:@"dingTickTock.mp3"];
        }
        if (myWaitingTime==0) {
          //  [self unschedule:_cmd];
            if (blackOverlaySprite&& !isPieceSelected) {
                
            
                [self pieceSelected:[whoFisrtMenu.children objectAtIndex:arc4random()%whoFisrtMenu.children.count]];
                 [self unschedule:_cmd];
            }else{
                [self unschedule:_cmd];
                if (isLocalPlayerTurn) {
                    [self playAtRandomPlace];
                }
                
            }
        }
    }

}


-(void)pieceSelected:(id)sender{
    isPieceSelected=YES;
    [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
//    [self unschedule:@selector(decreaseWaitingTime:)];
     
    CCMenuItemSprite* item=(CCMenuItemSprite*)sender;
    gameController.lp_startPieceType=item.tag;

    lp_selectedPiece=[CCSprite spriteWithSpriteFrame:((CCSprite*)item.normalImage).displayedFrame];
    lp_selectedPiece.position=item.position;
    lp_selectedPiece.scale=scale;
    [blackOverlaySprite addChild:lp_selectedPiece];
    [lp_selectedPiece runAction:[CCMoveTo actionWithDuration:0.3 position:ccp((blackOverlaySprite.contentSize.width)*0.5+ADJUST_DOUBLE(110),( blackOverlaySprite.contentSize.height*0.5+ADJUST_DOUBLE(140)))]];
    
    
    if (gameController.opp_startPieceType==PiecesTypeNone && isMultiplayer) {
        
        //Loading
        [gameController showLoadingIndicator];
        
    }else{
        if (!isMultiplayer) {
            gameController.opp_startPieceType=arc4random()%PiecesTypesMAX;
        }
        [self showOpponentStartPiece];
    }
    
    [self performSelector:@selector(disableWhoFirstMenu) withObject:nil afterDelay:0.05];
    if (isMultiplayer) {
        
        [gameController multiplayerSendWhoStartPiece:gameController.lp_startPieceType];
    }
    
  //  [((CCMenu*)item.parent) set]
    
}

-(void)disableWhoFirstMenu{
    [whoFisrtMenu setIsTouchEnabled:NO];
    [whoFisrtMenu setOpacity:100];
}

-(void)showOpponentStartPiece{
    GamePiece*piece=[[GamePiece alloc]init];
    piece.type=gameController.opp_startPieceType;
    piece.theme=selectedPiecesTheme;
    piece.model=opponentPiecesModel;
    piece.animationName=PiecesAnimationNameStatic;
    piece.direction=PiecesDirectionCenter;
    
    opp_selectedPiece=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:[gameController getPieceNameWithPiece:piece ]]];
    [piece release];
    opp_selectedPiece.position=ccp  ((blackOverlaySprite.contentSize.width)*0.5-ADJUST_DOUBLE(110),( blackOverlaySprite.contentSize.height*0.5+ADJUST_DOUBLE(140)));
    //    selectedPiece.position=item.position;//ccpAdd(ccpAdd(item.position,ccp(item.contentSize.width*0.5*scale, item.contentSize.height*scale*0.5)), item.parent.position) ;
    opp_selectedPiece.scale=scale;
    [blackOverlaySprite addChild:opp_selectedPiece];
    
    
    //Check Who beats
    [self performSelector:@selector(checkWhoStarts) withObject:nil afterDelay:0.5 ];
}
-(void)checkWhoStarts{
     whoBeats= [gameController checkWhoStarts];

    if (whoStartAlert!=nil) {
        [whoStartAlert dismissWithClickedButtonIndex:0 animated:NO];
        whoStartAlert=nil;
    }
    
    switch (whoBeats) {
        case PlayerTypeLocalPlayer:
            [self logGameStart];
            
//            [blackOverlaySprite removeFromParentAndCleanup:YES];
            gameController.isLocalPlayerTurn=YES;
//            self.isTouchEnabled=YES;
            
       
            [self setWhoPlay:whoBeats];
            
            
//            whoStartAlert=[[UIAlertView alloc]initWithTitle:@"" message:@"You will start" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            whoStartAlert=[BlockAlertView alertWithTitle:nil message:NSLocalizedString(@"You will start" , @"Show you will start message") andLoadingviewEnabled:NO];
            
//            [whoStartAlert setCancelButtonWithTitle:@"OK" block:^{
            [whoStartAlert setCancelButtonWithTitle:NSLocalizedString(@"OK", @"OK button message") block:^{
                if (blackOverlaySprite!=nil) {
                    [self unschedule:@selector(decreaseWaitingTime:)];
                    [blackOverlaySprite removeFromParentAndCleanup:YES];
                    blackOverlaySprite=nil;
                    if (isMultiplayer) {
                        waitingTimerLabel=nil;
                        [self addWaitingTimer];
                    }
                    
                    if (!isMultiplayer&&!gameController.isLocalPlayerTurn) {
                        [self setWhoPlay:whoBeats];
                    }
                    whoStartAlert=nil;
                    //            if (gameController.isLocalPlayerTurn) {
                    
                    //            }
                    
                }
               
            }];
            
           
            
            [self unschedule:@selector(decreaseWaitingTime:)];
            break;
            
        case PlayerTypeOpponent:
            [self logGameStart];
            
//            [blackOverlaySprite removeFromParentAndCleanup:YES];
            gameController.isLocalPlayerTurn=NO;
//            self.isTouchEnabled=NO;
//            whoStartAlert=[[UIAlertView alloc]initWithTitle:@"" message:@"Opponent will start" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            whoStartAlert=[BlockAlertView alertWithTitle:nil message:NSLocalizedString(@"Opponent will start", @"Show opponent will start message") andLoadingviewEnabled:NO];
            
//            [whoStartAlert setCancelButtonWithTitle:@"OK" block:^{
            [whoStartAlert setCancelButtonWithTitle:NSLocalizedString(@"OK", @"OK button message") block:^{
                if (blackOverlaySprite!=nil) {
                    [self unschedule:@selector(decreaseWaitingTime:)];
                    [blackOverlaySprite removeFromParentAndCleanup:YES];
                    blackOverlaySprite=nil;
                    if (isMultiplayer) {
                        waitingTimerLabel=nil;
                        [self addWaitingTimer];
                    }
                    
                    if (!isMultiplayer&&!gameController.isLocalPlayerTurn) {
                        [self setWhoPlay:whoBeats];
                    }
                    //            if (gameController.isLocalPlayerTurn) {
                    
                    //            }
                    
                }
                 whoStartAlert=nil;
            }];

            if (isMultiplayer) {
                 [self setWhoPlay:whoBeats];
            }
            
            
            [self unschedule:@selector(decreaseWaitingTime:)];
            break;
        case PlayerTypeNone:
            [lp_selectedPiece removeFromParentAndCleanup:YES ];
            [opp_selectedPiece removeFromParentAndCleanup:YES];
            
            gameController.lp_startPieceType=gameController.opp_startPieceType=PiecesTypeNone;
            
            [whoFisrtMenu setIsTouchEnabled:YES];
            [whoFisrtMenu setOpacity:255];
//            whoStartAlert=[[UIAlertView alloc]initWithTitle:@"Tie" message:@"Choose your piece again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
//            whoStartAlert=[BlockAlertView alertWithTitle:@"Tie" message:@"Choose your piece again" andLoadingviewEnabled:NO];
            
            whoStartAlert=[BlockAlertView alertWithTitle: NSLocalizedString(@"Tie", @"Tie choice") message: NSLocalizedString(@"Choose your piece again", @"Choose your piece again") andLoadingviewEnabled:NO];
            
            [whoStartAlert setCancelButtonWithTitle: NSLocalizedString(@"OK", @"OK button message") block:^{ whoStartAlert=nil;}];

            
            //restart the timer:
            [self resetWaitingTimer];
            
            break;
            
        default:
            break;
    }
    [whoStartAlert show];
//    [whoStartAlert release];
    
}
-(void)setWhoPlay:(PlayerTypes)playerType{
    if (isFirstPlay) {
        if (!isMultiplayer) {
              [gameController singlePlayerStartNewGameWithDifficulty:gameDifficulty andWhoFirst:playerType];
        }
      
        isFirstPlay=NO;
    }

    switch (playerType) {
        case PlayerTypeLocalPlayer:
            isLocalPlayerTurn=YES;
            self.isTouchEnabled=YES;
            rightStage.visible=YES;
            leftStage.visible=NO;
            if (!isFirstPlay && isMultiplayer) {
                [self resetWaitingTimer];

            
            }
            //stop board animation
            for (CCSprite* boardSprite in boardSpritesArray) {
                [boardSprite stopActionByTag:PiecesAnimationNameIdle];
            }
            
            [rightStage setDisplayFrame:[frameCache spriteFrameByName:[gameController getPieceNameWithPiece:RightStagePiece ]]];
//            [rightStage setTexture:[[CCTextureCache sharedTextureCache]addImage:[gameController getPieceNameWithPiece:RightStagePiece]]];
            [gameController animateSprite:rightStage withPiece:RightStagePiece WithAnimationName:PiecesAnimationNameIdle andLoop:YES];
            [self animateVulnerablePiecesWithPiece:RightStagePiece.type andPlayerType:PlayerTypeOpponent];     
            
            break;
        case PlayerTypeOpponent:
            isLocalPlayerTurn=NO;
            self.isTouchEnabled=NO;
            rightStage.visible=NO;
            [rightStage stopAllActions];
            leftStage.visible=YES;
            
            //stop board animation
            for (CCSprite* boardSprite in boardSpritesArray) {
                [boardSprite stopActionByTag:PiecesAnimationNameIdle];
            }

           
            [leftStage setDisplayFrame:[frameCache spriteFrameByName:[gameController getPieceNameWithPiece:LeftStagePiece]]];
            [gameController animateSprite:leftStage withPiece:LeftStagePiece WithAnimationName:PiecesAnimationNameIdle andLoop:YES];
//            [self animateVulnerablePiecesWithPiece:LeftStagePiece.type andPlayerType:PlayerTypeLocalPlayer];     

            
            CCLOG(@"left stage piece type:%d",LeftStagePiece.type );
            //Single Player machine turn:
            if (!isMultiplayer) {
                [self performSelector:@selector(singlePlayerComputerTurn) withObject:nil afterDelay:1];
                
               
//                myWaitingTime=0;
//                waitingTime=myWaitingTime;
//                [self unschedule:@selector(decreaseWaitingTime:)];
//
//                [waitingTimerLabel setString:[NSString stringWithFormat:@"00:%02d",myWaitingTime]];

                
            }else{
                [self resetWaitingTimer];
            }
              
            break;
        default:
            break;
    }  
    
}

-(void)singlePlayerComputerTurn{
    
    [gameController singlePlayerComputerTurn];
//    [self setWhoPlay:PlayerTypeLocalPlayer];

}

-(void)setConstantArrays{
    Points=[[NSArray alloc]initWithObjects: [NSValue valueWithCGPoint: PT1 ],[NSValue valueWithCGPoint:PT2],[NSValue valueWithCGPoint:PT3],[NSValue valueWithCGPoint:PT4],[NSValue valueWithCGPoint:PT5],[NSValue valueWithCGPoint:PT6],[NSValue valueWithCGPoint:PT7],[NSValue valueWithCGPoint:PT8],[NSValue valueWithCGPoint:PT9], nil];
    Rects=[[NSArray alloc]initWithObjects:[NSValue valueWithCGRect:RECT1],[NSValue valueWithCGRect:RECT2],[NSValue valueWithCGRect:RECT3],[NSValue valueWithCGRect:RECT4],[NSValue valueWithCGRect:RECT5],[NSValue valueWithCGRect:RECT6],[NSValue valueWithCGRect:RECT7],[NSValue valueWithCGRect:RECT8],[NSValue valueWithCGRect:RECT9], nil];
    
    zOrders=[[NSArray alloc]initWithObjects:[NSNumber numberWithInt:2],[NSNumber numberWithInt:1],[NSNumber numberWithInt:0],[NSNumber numberWithInt:3],[NSNumber numberWithInt:2],[NSNumber numberWithInt:1],[NSNumber numberWithInt:4],[NSNumber numberWithInt:3],[NSNumber numberWithInt:2],nil];
    MappedDirections=[[NSArray alloc]initWithObjects:[NSNumber numberWithInt:PiecesDirectionRight],[NSNumber numberWithInt:PiecesDirectionRight],[NSNumber numberWithInt:PiecesDirectionCenter],[NSNumber numberWithInt:PiecesDirectionRight],[NSNumber numberWithInt:PiecesDirectionCenter],[NSNumber numberWithInt:PiecesDirectionLeft],[NSNumber numberWithInt:PiecesDirectionCenter],[NSNumber numberWithInt:PiecesDirectionLeft],[NSNumber numberWithInt:PiecesDirectionLeft], nil];
}

-(void) drawLocalPlayerPieces{
//    
//    [lp_Available_Pieces removeAllObjects];
   
    
    //Right Pieces:
    GamePiece* piece=[[[GamePiece alloc]init] autorelease];
    piece.theme=selectedPiecesTheme;
    piece.model=localPlayerPiecesModel;
    piece.animationName=PiecesAnimationNameStatic;
    piece.direction=PiecesDirectionLeft;
    
    piece.type=PiecesTypeScissor;
    CCSprite* right_scissor_small_3=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:[gameController getPieceNameWithPiece:piece ]]];
    right_scissor_small_3.scale=kSMALL_PIECES_SCALE;
    right_scissor_small_3.position=RIGHT_PIECES_SCISSOR_3_POS;
    [self addChild:right_scissor_small_3];
    
    CCSprite* right_scissor_small_1=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:[gameController getPieceNameWithPiece:piece ]]];
    right_scissor_small_1.scale=kSMALL_PIECES_SCALE;
    right_scissor_small_1.position=RIGHT_PIECES_SCISSOR_1_POS;
    [self addChild:right_scissor_small_1];
    //        
    CCSprite* right_scissor_small_2=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:[gameController getPieceNameWithPiece:piece ]]];
    right_scissor_small_2.scale=kSMALL_PIECES_SCALE;
    right_scissor_small_2.position=RIGHT_PIECES_SCISSOR_2_POS;
    [self addChild:right_scissor_small_2];
    

    
    piece.type=PiecesTypePaper;
    CCSprite* right_paper_small_1=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:[gameController getPieceNameWithPiece:piece ]]];
    right_paper_small_1.scale=kSMALL_PIECES_SCALE;
    right_paper_small_1.position=RIGHT_PIECES_PAPER_1_POS;
    [self addChild:right_paper_small_1];
    
    CCSprite* right_paper_small_2=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:[gameController getPieceNameWithPiece:piece ]]];
    right_paper_small_2.scale=kSMALL_PIECES_SCALE;
    right_paper_small_2.position=RIGHT_PIECES_PAPER_2_POS;
    [self addChild:right_paper_small_2];
    
    CCSprite* right_paper_small_3=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:[gameController getPieceNameWithPiece:piece ]]];
    right_paper_small_3.scale=kSMALL_PIECES_SCALE;
    right_paper_small_3.position=RIGHT_PIECES_PAPER_3_POS;
    [self addChild:right_paper_small_3];
    
   
    
    piece.type=PiecesTypeStone;
    CCSprite* right_stone_small_1=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:[gameController getPieceNameWithPiece:piece ]]];
    right_stone_small_1.scale=kSMALL_PIECES_SCALE;
    right_stone_small_1.position=RIGHT_PIECES_STONE_1_POS;
    [self addChild:right_stone_small_1];
    
    CCSprite* right_stone_small_2=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:[gameController getPieceNameWithPiece:piece ]]];
    right_stone_small_2.scale=kSMALL_PIECES_SCALE;
    right_stone_small_2.position=RIGHT_PIECES_STONE_2_POS;
    [self addChild:right_stone_small_2];
    
    CCSprite* right_stone_small_3=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:[gameController getPieceNameWithPiece:piece ]]];
    right_stone_small_3.scale=kSMALL_PIECES_SCALE;
    right_stone_small_3.position=RIGHT_PIECES_STONE_3_POS;
    [self addChild:right_stone_small_3];
    
    NSArray* stones=[[NSArray alloc]initWithObjects:right_stone_small_1,right_stone_small_2,right_stone_small_3, nil];
    [lp_Available_Pieces addObject:stones];
    [stones release];
    NSArray* scissors=[[NSArray alloc]initWithObjects:right_scissor_small_1,right_scissor_small_2,right_scissor_small_3, nil];
    [lp_Available_Pieces addObject:scissors];
    [scissors release];
    NSArray* papers=[[NSArray alloc]initWithObjects:right_paper_small_1,right_paper_small_2,right_paper_small_3, nil];
    [lp_Available_Pieces addObject:papers ];
    [papers release];

}

-(void) drawOpponentPieces{
//    
//    [opp_Available_Pieces removeAllObjects];
    //Left Pieces:
    GamePiece* piece=[[[GamePiece alloc]init] autorelease];
    

    piece.theme=selectedPiecesTheme;
    piece.model=opponentPiecesModel;
    piece.animationName=PiecesAnimationNameStatic;
    piece.direction=PiecesDirectionRight;
    
    piece.type=PiecesTypeScissor;

    CCSprite* left_scissor_small_3=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:[gameController getPieceNameWithPiece:piece ]]];
    left_scissor_small_3.scale=kSMALL_PIECES_SCALE;
    left_scissor_small_3.position=LEFT_PIECES_SCISSOR_3_POS;
    [self addChild:left_scissor_small_3];
    
    CCSprite* left_scissor_small_1=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:[gameController getPieceNameWithPiece:piece ]]];
    left_scissor_small_1.scale=kSMALL_PIECES_SCALE;
    left_scissor_small_1.position=LEFT_PIECES_SCISSOR_1_POS;
    [self addChild:left_scissor_small_1];
    //        
    CCSprite* left_scissor_small_2=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:[gameController getPieceNameWithPiece:piece ]]];
    left_scissor_small_2.scale=kSMALL_PIECES_SCALE;
    left_scissor_small_2.position=LEFT_PIECES_SCISSOR_2_POS;
    [self addChild:left_scissor_small_2];
    
    
    piece.type=PiecesTypePaper;
    
    CCSprite* left_paper_small_1=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:[gameController getPieceNameWithPiece:piece ]]];
    left_paper_small_1.scale=kSMALL_PIECES_SCALE;
    left_paper_small_1.position=LEFT_PIECES_PAPER_1_POS;
    [self addChild:left_paper_small_1];
    
    CCSprite* left_paper_small_2=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:[gameController getPieceNameWithPiece:piece ]]];
    left_paper_small_2.scale=kSMALL_PIECES_SCALE;
    left_paper_small_2.position=LEFT_PIECES_PAPER_2_POS;
    [self addChild:left_paper_small_2];
    
    CCSprite* left_paper_small_3=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:[gameController getPieceNameWithPiece:piece ]]];
    left_paper_small_3.scale=kSMALL_PIECES_SCALE;
    left_paper_small_3.position=LEFT_PIECES_PAPER_3_POS;
    [self addChild:left_paper_small_3];
    
    
    piece.type=PiecesTypeStone;
    CCSprite* left_stone_small_1=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:[gameController getPieceNameWithPiece:piece ]]];
    left_stone_small_1.scale=kSMALL_PIECES_SCALE;
    left_stone_small_1.position=LEFT_PIECES_STONE_1_POS;
    [self addChild:left_stone_small_1];
    
    CCSprite* left_stone_small_2=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:[gameController getPieceNameWithPiece:piece ]]];
    left_stone_small_2.scale=kSMALL_PIECES_SCALE;
    left_stone_small_2.position=LEFT_PIECES_STONE_2_POS;
    [self addChild:left_stone_small_2];
    
    CCSprite* left_stone_small_3=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:[gameController getPieceNameWithPiece:piece ]]];
    left_stone_small_3.scale=kSMALL_PIECES_SCALE;
    left_stone_small_3.position=LEFT_PIECES_STONE_3_POS;
    [self addChild:left_stone_small_3];
    
    NSArray* stones=[[NSArray alloc]initWithObjects:left_stone_small_1,left_stone_small_2,left_stone_small_3, nil];
    [opp_Available_Pieces addObject:stones];
    [stones release];
    NSArray* scissors=[[NSArray alloc]initWithObjects:left_scissor_small_1,left_scissor_small_2,left_scissor_small_3, nil];
    [opp_Available_Pieces addObject:scissors];
    [scissors release];
    NSArray* papers=[[NSArray alloc]initWithObjects:left_paper_small_1,left_paper_small_2,left_paper_small_3, nil];
    [opp_Available_Pieces addObject:papers ];
    [papers release];

}

-(void) addScoreLabel{
    scoreLable=[CCLabelBMFont labelWithString:[NSString stringWithFormat: @"%d:%d",opp_score,lp_score] fntFile:@"score_bitmapfont.fnt"];
    
    scoreLable.position=ccp (screenSize.width*0.5,ADJUST_Y(58));
    [self addChild:scoreLable];
}

-(void) newGame{
    piecesAddedCount=0;
    if (isMultiplayer) {
         [waitingTimerLabel removeFromParentAndCleanup:YES];
        
    }
   
   // [waitingTimerLabel setString:@"00:00"];
    isFirstPlay=YES;
    [self resetGameBoard];
    myWaitingTime=kAPP_DELEGATE.MultiplayerTimeout;//kWAITING_MAX_TIME;
    waitingTime=myWaitingTime;
    
    [lp_availablePiecesCounts removeAllObjects];
    [lp_availablePiecesCounts addObjectsFromArray:[NSArray  arrayWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:3],[NSNumber numberWithInt:3], nil]];
    
    [opp_availablePiecesCounts removeAllObjects];
    [opp_availablePiecesCounts addObjectsFromArray:[NSArray  arrayWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:3],[NSNumber numberWithInt:3], nil]];

    [self drawLocalPlayerPieces];
    [self drawOpponentPieces];
    
    isSwapping=NO;
    if (!isFirstGame) {
        [self setRightStagePiece];
        [self setLeftStagePiece];
    }
//    if (isMultiplayer) {
//        gameController.isLocalPlayerTurn=!gameController.isLocalPlayerTurn;
//        [self performSelector:@selector(changeTouchEnabled:) withObject:nil afterDelay:0.1];
//        
//    }
    gameController.isLocalPlayerTurn=NO;//!gameController.isLocalPlayerTurn;
    [self performSelector:@selector(changeTouchEnabled:) withObject:nil afterDelay:0.1];

    
    isFirstGame=NO;
    
    
//    if (!isMultiplayer) {
//        //Single player new game
//        [gameController singlePlayerStartNewGame];
//    }
    
    isPieceSelected=NO;
  [self addWhoStartFirstView];
}

-(void) changeTouchEnabled:(id)sender{
    self.isTouchEnabled=gameController.isLocalPlayerTurn;
    
}

-(void) resetGameBoard{
  [gameController resetBoardArray];
    
    for (CCSprite * sprite in boardSpritesArray) {
        [sprite removeFromParentAndCleanup:YES];
    }
    [boardSpritesArray removeAllObjects];
    [boardPiecesArray removeAllObjects];
    
    for (NSArray * array in lp_Available_Pieces) {
        for (CCSprite* sprite in array) {
            [sprite removeFromParentAndCleanup:YES];
        }
        
    }
    [lp_Available_Pieces removeAllObjects];
    
    for (NSArray * array in opp_Available_Pieces) {
         for (CCSprite* sprite in array) {
             [sprite removeFromParentAndCleanup:YES];
         }
    }
    [opp_Available_Pieces removeAllObjects];
    
}

-(void) setRightStagePiece{
    RightStagePiece.type=PiecesTypeStone;
    RightStagePiece.theme=selectedPiecesTheme;
    RightStagePiece.model=localPlayerPiecesModel;
    RightStagePiece.animationName=PiecesAnimationNameStatic;
    RightStagePiece.direction=PiecesDirectionLeft;
    [rightStage setDisplayFrame:[frameCache spriteFrameByName:[gameController getPieceNameWithPiece:RightStagePiece ]]];
//    [rightStage setTexture:[[CCTextureCache sharedTextureCache]addImage:[gameController getPieceNameWithPiece:RightStagePiece ]]];
    
    //animate Right Stage:
    [rightStage stopAllActions];
    [gameController animateSprite:rightStage withPiece:RightStagePiece WithAnimationName:PiecesAnimationNameIdle andLoop:YES];
    //animate the board
//    [self animateVulnerablePiecesWithPiece:RightStagePiece.type]; 
}

-(void) setLeftStagePiece{
    LeftStagePiece.type=PiecesTypeStone;
    LeftStagePiece.theme=selectedPiecesTheme;
    LeftStagePiece.model=localPlayerPiecesModel;
    LeftStagePiece.animationName=PiecesAnimationNameStatic;
    LeftStagePiece.direction=PiecesDirectionRight;
    
    LeftStagePiece.model=opponentPiecesModel;
    
    [leftStage setDisplayFrame:[frameCache spriteFrameByName:[gameController getPieceNameWithPiece:LeftStagePiece ]]];
    
    //animate Left Stage:
    [leftStage stopAllActions];
    [gameController animateSprite:leftStage withPiece:LeftStagePiece WithAnimationName:PiecesAnimationNameIdle andLoop:YES];
}

-(void) backButtonTouched:(id)sender{
    if (sender!=nil) {
        [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
//        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Leave game and go to the Main Menu?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
//        alert.tag=GameSceneTagConfirmationAlert;
//        [alert show];
//        [alert release];
//        
        BlockAlertView* alert=[BlockAlertView alertWithTitle:nil message: NSLocalizedString(@"Leave game and go to the Main Menu?", @"Leave game and go to the Main Menu?") andLoadingviewEnabled:NO];
        
        [alert setCancelButtonWithTitle:NSLocalizedString(@"No", @"NO") block:^{
        
            
        }];
        [alert addButtonWithTitle: NSLocalizedString(@"Yes",@"Yes") block:^{
            [self backButtonTouched:nil];
            
        }];
        [alert show];

    }else{
  
        if(isMultiplayer){
            
            [gameController multiPlayerSendDisconnected];
            [gameController.gkHelper disconnectCurrentMatch];
        
        }
        
        [[CCDirector sharedDirector]popScene];
        [self logGameEnd];
    
    }
}

-(void)gridButtonTouched:(id)sender{

    [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
    grid.visible=!grid.visible;
}

#pragma Touches
#pragma Tracking Touches
-(void) registerWithTouchDispatcher{ 
    [[CCTouchDispatcher sharedDispatcher]addTargetedDelegate:self priority:-1 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch  withEvent:(UIEvent *)event{
    CGPoint location = [touch locationInView:[touch view]]; 
    location = [[CCDirector sharedDirector] convertToGL:location];         

    [self checkAddingPieceToBoardAtLocation:location];
    return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint location = [touch locationInView:[touch view]]; 
    location = [[CCDirector sharedDirector] convertToGL:location];  
    CGPoint previousLocation= [[CCDirector sharedDirector] convertToGL:[touch previousLocationInView:[touch view]]];

    CGRect rightStageRect=CGRectMake(rightStage.position.x-(rightStage.contentSize.width*0.5), rightStage.position.y-(rightStage.contentSize.height*0.5), rightStage.contentSize.width, rightStage.contentSize.height); 

    if (CGRectContainsPoint(rightStageRect, location)) {
        
        CGPoint translation = ccpSub(location, previousLocation);    

        CGPoint newPos = ccpAdd(rightStage.position, translation);
        rightStage.position = newPos;
        isSwapping=YES;
        
        if (playerWinsBefore==0&&!isMultiplayer) {
            [rightStage stopActionByTag:GameSceneTagBlinkAction];
        }
        
    }else{
        isSwapping=NO;
    }
    
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint location = [touch locationInView:[touch view]]; 
    location = [[CCDirector sharedDirector] convertToGL:location]; 
    
    if (CGRectContainsPoint(RIGHT_STAGE_RECT, location) ) {
//        [[SimpleAudioEngine sharedEngine] playEffect:@"click.mp3"];
        if (playerWinsBefore==0&&!isMultiplayer) {
             [rightStage stopActionByTag:GameSceneTagBlinkAction];
        }
       
        do {
            RightStagePiece.type=(RightStagePiece.type+1)%PiecesTypesMAX;
            
        } while ([[lp_availablePiecesCounts objectAtIndex:RightStagePiece.type] intValue]==0);
        
        [rightStage setDisplayFrame:[frameCache spriteFrameByName:[gameController getPieceNameWithPiece:RightStagePiece]]];
        //animate Right Stage:
        [rightStage stopAllActions];
        [gameController animateSprite:rightStage withPiece:RightStagePiece WithAnimationName:PiecesAnimationNameIdle andLoop:YES];
        
        //stop board animation
        for (CCSprite* boardSprite in boardSpritesArray) {
            [boardSprite stopActionByTag:PiecesAnimationNameIdle];
        }
        
        //animate the board
        [self animateVulnerablePiecesWithPiece:RightStagePiece.type andPlayerType:PlayerTypeOpponent]; 
        
        if (isMultiplayer) {
              [gameController multiplayerSendStagePiece:RightStagePiece ];
        }
    }
    else if (isSwapping) {
        [self checkAddingPieceToBoardAtLocation:location ];
        isSwapping=NO;
    }
    
//    else if (CGRectContainsPoint(tutoOkButton, location) ) {
//        [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
//        if (tutorialSprite.tag==TutorialA) {
//            whoFisrtMenu.isTouchEnabled=YES;
//            self.isTouchEnabled=YES;
//        }
//        [tutorialSprite removeFromParentAndCleanup:YES];
//        tutorialSprite=nil;
//        
//        [[CCDirector sharedDirector]resume]; 
//        
//        isTutorialShown = NO;
//    }
    
}

#pragma -
-(void)checkAddingPieceToBoardAtLocation:(CGPoint)location{
//    //stop board animation
//    for (CCSprite* boardSprite in boardSpritesArray) {
//        [boardSprite stopAllActions];
//    }
    
    int index=0;
    for (NSValue * val in Rects){
        CGRect rect=[val CGRectValue];
        if (CGRectContainsPoint(rect, location) ) {

            PiecesTypes pieceType=RightStagePiece.type;
            PiecesDirections direction=[[MappedDirections objectAtIndex:index] intValue];
            GamePiece* piece=[[[GamePiece alloc]init] autorelease];
            piece.theme=selectedPiecesTheme;
            piece.model=localPlayerPiecesModel;
            piece.animationName=PiecesAnimationNameStatic;
            piece.direction=direction;
            
            piece.type=pieceType;
            
            
            if (isMultiplayer) {
                
            
            //Send To opponent:
            //////////////////////////////////////
            [gameController multiplayerSendPiece:piece atIndex:index];

            }else{
            
//                //Single Player local player turn:
//                [gameController singlePlayerPlayedPiece:piece atBoardIndex:index];
            }
            
            [self playerPlayedPiece:piece atBoardIndex:index withPlayer: PlayerTypeLocalPlayer];
            
                       
            break;
        }
        
        index++;
    }
    
    if (isSwapping) {
        rightStage.position=RIGHT_STAGE_POS;
    }
}

-(void)playerWins:(PlayerTypes)player{
//    [self performSelector:@selector(newGame) withObject:nil afterDelay:1.6];
//    UIAlertView* newGameAlertView;
    NSMutableArray * spritesArray=[[NSMutableArray alloc]init];
   
    NSMutableArray *piecesArray=[[NSMutableArray alloc]init];
    int i=0;
    for (CCSprite *sprite in boardSpritesArray) {
        if ([gameController.winningPlaces containsObject:[NSNumber numberWithInt:sprite.tag ]]) {
            [spritesArray addObject:sprite];
            [piecesArray addObject:[boardPiecesArray objectAtIndex:i]];
        }
        i++;
    }
    
//    for (GamePiece *piece in boardPiecesArray) {
//        if ([gameController.winningPlaces containsObject:[NSNumber numberWithInt:piece.tag ]]) {
//            [piecesArray addObject:piece];
//           
//        }
//    }

    i=0;
    CCLOG(@"Pieces: %@",piecesArray);
    for (CCSprite * sprite in spritesArray) {
        
        
        [gameController animateSprite:sprite withPiece:[piecesArray objectAtIndex:i ] WithAnimationName:PiecesAnimationNameVictory andLoop:YES];
//        CCBlink* blink=[CCBlink actionWithDuration:0.5 blinks:1];
//        CCRepeatForever* repeat=[CCRepeatForever actionWithAction:blink];
//        [sprite performSelector:@selector(runAction:) withObject:repeat afterDelay:1.2];
//         
         i++;
    }
    
    [self unschedule:@selector(decreaseWaitingTime:)];
    if(isMultiplayer){
    
        [gameController.gkHelper disconnectCurrentMatch];
    }
    
    
    if (player==PlayerTypeLocalPlayer) { //Win
       
        if (!isMultiplayer&& playerWinsBefore==0) {
            playerWinsBefore=1;
            [defaults setInteger:playerWinsBefore forKey:kSETTING_PLAYER_WINS];
        }
//#ifndef LITE_VERSION
        if (isMultiplayer) {
           int winningtimes= [defaults integerForKey:KNUMBER_OF_WINNING_TIMES];
            winningtimes++;
            [defaults setInteger:winningtimes forKey:KNUMBER_OF_WINNING_TIMES];
            if (winningtimes==30) {
                
                NSFileManager* fileManager = [NSFileManager defaultManager];
                NSString *settingFilePath;
                NSString* storageFilePath=[NSString stringWithFormat: @"%@/Documents/%@.plist", NSHomeDirectory(),kSETTING_PLIST_FILE_NAME];
                if (![fileManager fileExistsAtPath: storageFilePath])
                {
                    settingFilePath= [[NSBundle mainBundle] pathForResource: kSETTING_PLIST_FILE_NAME ofType: @"plist"];
                    
                    [fileManager copyItemAtPath: settingFilePath toPath: storageFilePath error: nil];
                }
                
                
                NSMutableDictionary* settingDict=[[NSMutableDictionary alloc]initWithContentsOfFile:storageFilePath];
                
                
                [settingDict setObject:[NSNumber numberWithInt:0] forKey:kSETTING_GOLDEN_TEAM_LOCKED];
               
                [settingDict writeToFile:storageFilePath atomically: YES];
            }
            
            
            //statistics:
           int wins= [defaults integerForKey:kSTATS_MULTIPLAYER_WIN];
            wins++;
            [defaults setInteger:wins forKey:kSTATS_MULTIPLAYER_WIN];
            
            int total=[defaults integerForKey:kSTATS_MULTIPLAYER_TOTAL];
            total++;
            [defaults setInteger:total forKey:kSTATS_MULTIPLAYER_TOTAL];

            
            [gameController submitScore:wins category:kLEADERBOARD_CATEGORY_MULTIPLAYER];
            
        }else{//singlePlayer
            int wins;
            int total;
            switch (gameDifficulty) {
                case GameDifficultyEasy:
                    wins= [defaults integerForKey:kSTATS_SINGLE_EASY_WIN];
                    wins++;
                    [defaults setInteger:wins forKey:kSTATS_SINGLE_EASY_WIN];
                    
                    total=[defaults integerForKey:kSTATS_SINGLE_EASY_TOTAL];
                    total++;
                    [defaults setInteger:total forKey:kSTATS_SINGLE_EASY_TOTAL];
                    [gameController submitScore:wins category:kLEADERBOARD_CATEGORY_EASY];
                    break;
                case GameDifficultyMedium:
                    wins= [defaults integerForKey:kSTATS_SINGLE_MEDIUM_WIN];
                    wins++;
                    [defaults setInteger:wins forKey:kSTATS_SINGLE_MEDIUM_WIN];
                    
                    total=[defaults integerForKey:kSTATS_SINGLE_MEDIUM_TOTAL];
                    total++;
                    [defaults setInteger:total forKey:kSTATS_SINGLE_MEDIUM_TOTAL];
                    [gameController submitScore:wins category:kLEADERBOARD_CATEGORY_MEDIUM];
                    break;
                case GameDifficultyHard:
                    wins= [defaults integerForKey:kSTATS_SINGLE_HARD_WIN];
                    wins++;
                    [defaults setInteger:wins forKey:kSTATS_SINGLE_HARD_WIN];
                    
                    total=[defaults integerForKey:kSTATS_SINGLE_HARD_TOTAL];
                    total++;
                    [defaults setInteger:total forKey:kSTATS_SINGLE_HARD_TOTAL];
                    [gameController submitScore:wins category:kLEADERBOARD_CATEGORY_HARD];
                    break;
                    
                default:
                    break;
            }
        
        }
//#endif
        
//        lp_score++;
    }else{ //Lose
       //        opp_score++;
        
        if (isMultiplayer) {
            //statistics:
            int loses= [defaults integerForKey:kSTATS_MULTIPLAYER_LOSE];
            loses++;
            [defaults setInteger:loses forKey:kSTATS_MULTIPLAYER_LOSE];
            
            int total=[defaults integerForKey:kSTATS_MULTIPLAYER_TOTAL];
            total++;
            [defaults setInteger:total forKey:kSTATS_MULTIPLAYER_TOTAL];

        }else{
        
            int wins;
            int total;
            switch (gameDifficulty) {
                case GameDifficultyEasy:
                    wins= [defaults integerForKey:kSTATS_SINGLE_EASY_LOSE];
                    wins++;
                    [defaults setInteger:wins forKey:kSTATS_SINGLE_EASY_LOSE];
                    
                    total=[defaults integerForKey:kSTATS_SINGLE_EASY_TOTAL];
                    total++;
                    [defaults setInteger:total forKey:kSTATS_SINGLE_EASY_TOTAL];
                    
                    break;
                case GameDifficultyMedium:
                    wins= [defaults integerForKey:kSTATS_SINGLE_MEDIUM_LOSE];
                    wins++;
                    [defaults setInteger:wins forKey:kSTATS_SINGLE_MEDIUM_LOSE];
                    
                    total=[defaults integerForKey:kSTATS_SINGLE_MEDIUM_TOTAL];
                    total++;
                    [defaults setInteger:total forKey:kSTATS_SINGLE_MEDIUM_TOTAL];
                    
                    break;
                case GameDifficultyHard:
                    wins= [defaults integerForKey:kSTATS_SINGLE_HARD_LOSE];
                    wins++;
                    [defaults setInteger:wins forKey:kSTATS_SINGLE_HARD_LOSE];
                    
                    total=[defaults integerForKey:kSTATS_SINGLE_HARD_TOTAL];
                    total++;
                    [defaults setInteger:total forKey:kSTATS_SINGLE_HARD_TOTAL];
                    break;
                    
                default:
                    break;
            }

        }
    }
       
   
    [defaults synchronize];

    
    [self showGameAlertWithWinner:player];
//    [scoreLable setString:[NSString stringWithFormat:@"%d:%d",opp_score,lp_score]];
}
-(void)showGameAlertWithWinner:(PlayerTypes)winner{
     [frameCache addSpriteFramesWithFile:@"alerts1.plist"];
    NSString*imageName;
    switch (winner) {
            
            
        case PlayerTypeLocalPlayer://win
            [self logGameWin];
             [[SimpleAudioEngine sharedEngine]playEffect:@"win.mp3"];
//             newGameAlertView=[[UIAlertView alloc]initWithTitle:@"" message:@"You Win...Play Again?"  delegate:self cancelButtonTitle:@"BACK" otherButtonTitles: @"OK",nil];
            
            switch (localPlayerPiecesModel) {
                case PiecesModelGold:
                    imageName=@"GUI_Menu_Win_A_Golden.png";
                    break;
                case PiecesModelGood:
                    imageName=@"GUI_Menu_Win_A_Good.png";
                    break;
                    
                case PiecesModelDevil:
                    imageName=@"GUI_Menu_Win_A_Villain.png";
                    break;

                    
                default:
                    
                    break;
            }
            
            
            break;
            
        case PlayerTypeOpponent://lose
            [self logGameLose];
             [[SimpleAudioEngine sharedEngine]playEffect:@"failTuba.mp3"];
//            newGameAlertView=[[UIAlertView alloc]initWithTitle:@"" message:@"You Lose...Play Again?"  delegate:self cancelButtonTitle:@"BACK" otherButtonTitles:@"OK", nil];

            
//            switch (opponentPiecesModel) {
//                case PiecesModelGold:
//                    
//                    imageName=@"GUI_Menu_Lose_A_Golden.png";
//                    break;
//                case PiecesModelGood:
//                    
//                    imageName=@"GUI_Menu_Lose_A_Good.png";
//                    break;
//                    
//                case PiecesModelDevil:
//                     [frameCache addSpriteFramesWithFile:@"alerts2.plist"];
//                    imageName=@"GUI_Menu_Lose_A_Villain.png";
//                    break;
//                    
//                    
//                default:
//                    
//                    break;
//            }
            
            imageName=@"GUI_Menu_Lose_A.png";
            
            break;
            
        default:
            break;
    }
    
    
//    [newGameAlertView performSelector:@selector(show) withObject:nil afterDelay:1.2];
    
    
    winnerAllert=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:imageName]];
    if (IS_IPAD()) {
//#ifdef LITE_VERSION
        if (![gameController isFeaturePurchased:kREMOVE_ADS_ID]&&
            [[NSUserDefaults standardUserDefaults]boolForKey:kBANNER_AD_ENABLED_KEY]) {
             winnerAllert.position=ccp(screenSize.width*0.5, ADJUST_Y(362));
        }else{
             winnerAllert.position=ccp(screenSize.width*0.5, ADJUST_Y(408));
        }
       
//#else
//        winnerAllert.position=ccp(screenSize.width*0.5, ADJUST_Y(408));
//#endif
    }else{
//#ifdef LITE_VERSION
        if (![gameController isFeaturePurchased:kREMOVE_ADS_ID]&&
            [[NSUserDefaults standardUserDefaults]boolForKey:kBANNER_AD_ENABLED_KEY]) {
         winnerAllert.position=ccp(screenSize.width*0.5, ADJUST_Y(378));
        }else{
         winnerAllert.position=ccp(screenSize.width*0.5, ADJUST_Y(418));
        }
//#else
//        winnerAllert.position=ccp(screenSize.width*0.5, ADJUST_Y(418));
//#endif
       
    }
    id fadeIn = [CCFadeIn actionWithDuration:0.1];
    id scale1 = [CCSpawn actions:fadeIn, [CCScaleTo actionWithDuration:0.15 scale:1.1], nil];
    id scale2 = [CCScaleTo actionWithDuration:0.1 scale:0.9];
    id scale3 = [CCScaleTo actionWithDuration:0.05 scale:1.0];
    id pulse = [CCSequence actions:scale1, scale2, scale3, nil];
    
    [winnerAllert runAction:pulse];
    
    [self addChild:winnerAllert z:2000];
    CCSprite* mainMenu=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"main_menu_btn.png"]];
    
    CCSprite* mainMenu_selected=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"main_menu_btn.png"]];
    mainMenu_selected.color=ccGRAY;
    
    CCMenuItemSprite* mainMenuItem=[CCMenuItemSprite itemFromNormalSprite:mainMenu selectedSprite:mainMenu_selected target:self selector:@selector(alertMainMenuItemTouched:)];
    mainMenuItem.anchorPoint=ccp(0, 0);
    mainMenuItem.position=ADJUST_DOUBLE_XY(11, 6);
    
    CCSprite* playAgain=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"play_again.png"]];
    
    CCSprite* playAgain_selected=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:@"play_again.png"]];
    playAgain_selected.color=ccGRAY;
    
    CCMenuItemSprite* playAgainItem=[CCMenuItemSprite itemFromNormalSprite:playAgain selectedSprite:playAgain_selected target:self selector:@selector(alertplayAgainItemTouched:)];
    playAgainItem.anchorPoint=ccp(0, 0);
    playAgainItem.position=ADJUST_DOUBLE_XY(220, 6);

    CCMenu* menu=[CCMenu menuWithItems:mainMenuItem,playAgainItem, nil];
    menu.anchorPoint=ccp(0, 0);
    menu.position=ccp(0, 0);
    [winnerAllert addChild:menu];
    
    self.isTouchEnabled=NO;

    
}
-(void)alertMainMenuItemTouched:(id)sender{
     [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
        
    [self backButtonTouched:nil];
        
    [winnerAllert removeFromParentAndCleanup:YES];
    winnerAllert=nil;
    
}
-(void)alertplayAgainItemTouched:(id)sender{
     [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
    if (isMultiplayer) {
        self.isTouchEnabled=NO;
        [gameController createMatchNewRequest];
    }else{
        
        [self newGame];
    }
    [winnerAllert removeFromParentAndCleanup:YES];
    winnerAllert=nil;
    
}

-(bool )playerPlayedPiece:(GamePiece*)piece atBoardIndex:(int)index withPlayer: (PlayerTypes)playerType{
    bool pieceAdded=NO;
    CGPoint piecePosition;
    
    int pieceZOrder;
    
    BoardObject* boardObj=[[BoardObject alloc]init];
    boardObj.playerType=playerType;
    boardObj.pieceType=piece.type;
    
    PlaceStates placeAvailablity=[gameController checkIfPlaceAvailableWithBoardObject:boardObj atIndex:index];
    if (placeAvailablity==PlaceStateEmpty || placeAvailablity==PlaceStateCanReplace) {
        piecePosition=[[Points objectAtIndex:index] CGPointValue];
        pieceZOrder=[[zOrders objectAtIndex:index] intValue];
        if (placeAvailablity==PlaceStateEmpty) {
            //Add New Sprite:
            
            CCSprite* pieceSprite=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:[gameController getPieceNameWithPiece:piece]]];
            pieceSprite.position=piecePosition;
            pieceSprite.scale=scale;
            pieceSprite.tag=index;
            [self addChild:pieceSprite z:pieceZOrder];
            
            [boardSpritesArray addObject:pieceSprite];
            piece.tag=index;
            [boardPiecesArray addObject:piece];
            pieceAdded=YES;
            
            [gameController animateSprite:pieceSprite withPiece:piece WithAnimationName:PiecesAnimationNameBringToLife andLoop:NO];
        }else if(placeAvailablity==PlaceStateCanReplace){
            
            //Replace sprite:
            CCSprite* oldSprite;
            int replacedPieceIndex=-1;
            for (CCSprite* replacablePiece in boardSpritesArray) {
                replacedPieceIndex++;
                if (replacablePiece.position.x==piecePosition.x && replacablePiece.position.y==piecePosition.y) {
//                    replacedPieceIndex=[Points indexOfObject:[NSValue valueWithCGPoint: replacablePiece.position]];
                    
                    PiecesTypes replacedPieceType=((BoardObject*)[gameController.boardArray objectAtIndex:index]).pieceType;
                    PlayerTypes replacedPiecePlayerType;
                    switch (playerType) {
                        case PlayerTypeLocalPlayer:
                            replacedPiecePlayerType=PlayerTypeOpponent;
                            break;
                        case PlayerTypeOpponent:
                            replacedPiecePlayerType=PlayerTypeLocalPlayer;
                            break;
                            
                        default:
                            break;
                    }
                    int i=0;
                    int foundIndex=-1;
                    for (GamePiece*p in boardPiecesArray) {
                        if (p.tag==index) {
                            foundIndex=i;
                            break;
                           
                        }
                        i++;
                    }
                    piece.tag=index;
                     [boardPiecesArray replaceObjectAtIndex:foundIndex  withObject:piece];
                    
                    [self addAvailablePieceWithType:replacedPieceType forPlayer:replacedPiecePlayerType];
                    
                    
//                    CCLOG(@"piece index: %d",index);
                    [replacablePiece stopAllActions];
                   // replacablePiece.textureRect=
//                    replacablePiece.contentSize=CGSizeMake(ADJUST_DOUBLE(128), ADJUST_DOUBLE(128));
//                    [replacablePiece setTexture:[[CCTextureCache sharedTextureCache]addImage:[gameController getPieceNameWithPiece:piece]]];
                    
//                    CCLOG(@"replacable piece texture:%@",[replacablePiece texture]);
//                    CCLOG(@"replacable piece texture rect:w:%f, h:%f ,x:%f,y:%f",[replacablePiece textureRect].size.width,[replacablePiece textureRect].size.height,[replacablePiece textureRect].origin.x,[replacablePiece textureRect].origin.y);
//                    CCLOG(@"replacable piece sprite rect:w:%f, h:%f ,x:%f,y:%f",[replacablePiece contentSize].width,[replacablePiece contentSize].height,replacablePiece.position.x,replacablePiece.position.y);
//                    CCLOG(@"piece image: %@",piece.imageName);
//                    [gameController animateSprite:replacablePiece withPiece:piece WithAnimationName:PiecesAnimationNameBringToLife andLoop:NO];
                    pieceAdded=YES;
                    
                    oldSprite=replacablePiece;
                    break;
                }
                
            }
            //to solve the animation problem
            if (pieceAdded&&replacedPieceIndex!=-1) {
                
                CCSprite * newReplacedSprite=[CCSprite spriteWithSpriteFrame:[frameCache spriteFrameByName:[gameController getPieceNameWithPiece:piece]]];
                newReplacedSprite.position=oldSprite.position;
                newReplacedSprite.scale=scale;
                newReplacedSprite.tag=index;
                [self addChild:newReplacedSprite z:oldSprite.zOrder]; 
                [boardSpritesArray replaceObjectAtIndex:replacedPieceIndex withObject:newReplacedSprite];
                [oldSprite removeFromParentAndCleanup:YES];
                  [gameController animateSprite:newReplacedSprite withPiece:piece WithAnimationName:PiecesAnimationNameBringToLife andLoop:NO];
                
                
            }
        }

        if (pieceAdded) {
            piecesAddedCount++;
            if (isMultiplayer) {
                [self unschedule:@selector(decreaseWaitingTime:)];
                myWaitingTime=0;
                
                waitingTime=myWaitingTime;
                
                [waitingTimerLabel setString:[NSString stringWithFormat:@"00:%02d",myWaitingTime]];

            }
                       
            if (!isMultiplayer && playerType==PlayerTypeLocalPlayer) {
                //Single Player local player turn:
                [gameController singlePlayerPlayedPiece:piece atBoardIndex:index];
            }
        }
        [self usePieceWithType:piece.type forPlayer:playerType];
        
    
        PlayerTypes winner= [gameController addPiece:piece atBoardIndex:index withPlayer:playerType];
        
        if(winner==PlayerTypeNone){
            //check to add tutorial 2:
            if (playerWinsBefore==0 &&piecesAddedCount==kBOARD_OBJECTS_COUNT) {
                
                [self addInstructionsAndTutorialsWithTutorialtype:TutorialB];
                
            }
        }
        
        if (winner!=PlayerTypeNone) {
            [self playerWins:winner];
        }else if(playerType==PlayerTypeLocalPlayer){
            //Opponent turn:
            [self setWhoPlay:PlayerTypeOpponent];
//            self.isTouchEnabled=NO;
        }else if (playerType==PlayerTypeOpponent){
            [self setWhoPlay:PlayerTypeLocalPlayer];
//            self.isTouchEnabled=YES;
        }
    }
    return pieceAdded;
}
-(void)usePieceWithType:(PiecesTypes)type forPlayer:(PlayerTypes)playerType{
    NSMutableArray* availablePiecesCount;
    NSMutableArray* availablePieces;
    GamePiece* stagePiece;
    CCSprite* stageSprite;
    bool isRightStage;
    switch (playerType) {
        case PlayerTypeLocalPlayer:
            availablePiecesCount=lp_availablePiecesCounts;
            availablePieces=lp_Available_Pieces;
            stagePiece=RightStagePiece;
            stageSprite=rightStage;
            isRightStage=YES;
            
            break;
        case PlayerTypeOpponent:
            availablePiecesCount=opp_availablePiecesCounts;
            availablePieces=opp_Available_Pieces;
            stagePiece=LeftStagePiece;
            stageSprite=leftStage;
            isRightStage=NO;
            
            break;
            
        default:
            break;
    }
    
    //remove selected peice from available pieces:
    int availableCount=[[ availablePiecesCount objectAtIndex:type] intValue];
     NSLog(@"available count before using:%d",availableCount);
    availableCount--;
    NSLog(@"available count after using:%d",availableCount);
    [ availablePiecesCount replaceObjectAtIndex:type withObject:[NSNumber numberWithInt:availableCount]];
    
    [(CCSprite*)[(NSArray*)[availablePieces objectAtIndex:type] objectAtIndex:availableCount] setVisible:NO];
    
    if (availableCount==0) {
        do {
            
            stagePiece.type=(stagePiece.type+1)%PiecesTypesMAX;
            NSLog(@"stagePiece type: %d , right:%d , left:%d",stagePiece.type, RightStagePiece.type,LeftStagePiece.type);
            
        } while ([[availablePiecesCount objectAtIndex:stagePiece.type] intValue]==0);
        

    }
 
    //Sounds:
    
    switch (type) {
        case PiecesTypePaper:
            [[SimpleAudioEngine sharedEngine]playEffect:@"paper.mp3"];
            break;
        case PiecesTypeScissor:
             [[SimpleAudioEngine sharedEngine]playEffect:@"scissors.mp3"];
            break;
            
        case PiecesTypeStone:
             [[SimpleAudioEngine sharedEngine]playEffect:@"rock.mp3"];
            break;
            
        default:
            break;
    }
}

-(void) addAvailablePieceWithType:(PiecesTypes)replacedPieceType forPlayer:(PlayerTypes)replacedPiecePlayerType{
    
    NSMutableArray* availablePiecesCount;
    NSMutableArray* availablePieces;
    
    switch (replacedPiecePlayerType) {
        case PlayerTypeLocalPlayer:
            availablePiecesCount=lp_availablePiecesCounts;
            availablePieces=lp_Available_Pieces;
            
            break;
        case PlayerTypeOpponent:
            availablePiecesCount=opp_availablePiecesCounts;
            availablePieces=opp_Available_Pieces;
           
            break;
            
        default:
            break;
    }

    //remove selected peice from available pieces:
    int availableCount=[[ availablePiecesCount objectAtIndex:replacedPieceType] intValue];
    [(CCSprite*)[(NSArray*)[availablePieces objectAtIndex:replacedPieceType] objectAtIndex:availableCount] setVisible:YES];
    NSLog(@"available count before adding:%d",availableCount);
    availableCount++;
     NSLog(@"available count after adding:%d",availableCount);
    [ availablePiecesCount replaceObjectAtIndex:replacedPieceType withObject:[NSNumber numberWithInt:availableCount]];
}


-(void)playAtRandomPlace{
    bool pieceAdded=NO;
    
    NSMutableArray* array=[[NSMutableArray alloc]initWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:1], [NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4],[NSNumber numberWithInt:5],[NSNumber numberWithInt:6],[NSNumber numberWithInt:7],[NSNumber numberWithInt:8],nil];
    do {
        int randomIndex=arc4random()%kBOARD_OBJECTS_COUNT;
        if ([array containsObject:[NSNumber numberWithInt:randomIndex]]) {
            [array removeObject:[NSNumber numberWithInt:randomIndex]];
        }
        PiecesTypes pieceType=RightStagePiece.type;
        PiecesDirections direction=[[MappedDirections objectAtIndex:randomIndex] intValue];
        GamePiece* piece=[[[GamePiece alloc]init] autorelease];
        piece.theme=selectedPiecesTheme;
        piece.model=localPlayerPiecesModel;
        piece.animationName=PiecesAnimationNameStatic;
        piece.direction=direction;
        
        piece.type=pieceType;
        
        
        //Send To opponent:
        //////////////////////////////////////
        [gameController multiplayerSendPiece:piece atIndex:randomIndex];

        pieceAdded=[self playerPlayedPiece:piece atBoardIndex:randomIndex withPlayer: PlayerTypeLocalPlayer];
        if (!pieceAdded &&[array count]==0) {
            do {
                RightStagePiece.type=(RightStagePiece.type+1)%PiecesTypesMAX;
                
            } while ([[lp_availablePiecesCounts objectAtIndex:RightStagePiece.type] intValue]==0);
            
            
            [rightStage setDisplayFrame:[frameCache spriteFrameByName:[gameController getPieceNameWithPiece:RightStagePiece]]];
            //animate Right Stage:
            [rightStage stopAllActions];
            [gameController animateSprite:rightStage withPiece:RightStagePiece WithAnimationName:PiecesAnimationNameIdle andLoop:YES];
            
            //animate the board
//            [self animateVulnerablePiecesWithPiece:RightStagePiece.type]; 
            
            [gameController multiplayerSendStagePiece:RightStagePiece ];
            
            [array addObjectsFromArray:[NSArray arrayWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:1], [NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4],[NSNumber numberWithInt:5],[NSNumber numberWithInt:6],[NSNumber numberWithInt:7],[NSNumber numberWithInt:8], nil]];
            
            
        }
    } while (!pieceAdded);

}
-(void)animateVulnerablePiecesWithPiece:(PiecesTypes)pieceType andPlayerType:(PlayerTypes)playerType{

    NSArray*indexesArray=[[NSArray alloc]initWithArray:[gameController getVulnerablePiecesIndexesWithPiece:pieceType andPlayerType:playerType]];
    int i=0;
    for (CCSprite* boardSprite in boardSpritesArray) {
    
        if ([indexesArray containsObject:[NSNumber numberWithInt: boardSprite.tag]]) {
            [gameController animateSprite:boardSprite withPiece:[boardPiecesArray objectAtIndex:i] WithAnimationName:PiecesAnimationNameIdle andLoop:YES];
        }
        i++;
    }
}
#pragma mark Controller Delegate Methods

-(void)onDidReceiveData:(NSData*)data fromPlayer:(NSString*)playerID{
    Packet p = *(Packet*)[data bytes] ; 
    if (p.theMessageKind == Player_Added_Piece_Message) {
        GamePacket p=*(GamePacket*)[data bytes];
        GamePiece* piece=[[GamePiece alloc]init] ;
        piece.type=p.pieceType;
        piece.theme=selectedPiecesTheme;
        piece.model=opponentPiecesModel;
        piece.direction=p.pieceDirection;
        piece.animationName=p.pieceAnimationName;
        CCLOG (@"RECIVED New Piece Added:%@ at index: %d",piece,p. boardIndex);
        [self playerPlayedPiece:piece atBoardIndex:p.boardIndex withPlayer:PlayerTypeOpponent];
    }else if(p.theMessageKind == Player_Changed_Stage_Piece_Message){
    
         StagePacket p=*(StagePacket*)[data bytes];
        LeftStagePiece.type=p.pieceType;
        [leftStage setDisplayFrame:[frameCache spriteFrameByName:[gameController getPieceNameWithPiece:LeftStagePiece]]];
//        [[SimpleAudioEngine sharedEngine] playEffect:@"click.mp3"];
        
        //animate Left Stage:
        [leftStage stopAllActions];
        [gameController animateSprite:leftStage withPiece:LeftStagePiece WithAnimationName:PiecesAnimationNameIdle andLoop:YES];
        
    }else if (p.theMessageKind == Disconnected_Message) {
//        if (newGameAlertView!=nil) {
//            [newGameAlertView dismissWithClickedButtonIndex:0 animated:NO];
//        }
    }else if(p.theMessageKind==Player_Send_Who_Start_Piece_Message){
        if (gameController.lp_startPieceType!=PiecesTypeNone) {
            [self showOpponentStartPiece];
        }
    }
}

-(void)onStartNewMultiplayerGame{
    [self unscheduleAllSelectors];
    
//    [waitingTimerLabel removeFromParentAndCleanup:YES];
    [self newGame];
//    [self addWhoStartFirstView];
}


-(void)addOpponentNewPieceWithPieceType:(PiecesTypes)pieceType atIndex:(int)index{

   
//    if (LeftStagePiece.type!=pieceType) {
//        [[SimpleAudioEngine sharedEngine]playEffect:@"click.mp3"];
//    }
    LeftStagePiece.type=pieceType;
    [leftStage setDisplayFrame:[frameCache spriteFrameByName:[gameController getPieceNameWithPiece:LeftStagePiece]]];
    
    //animate Left Stage:
    [leftStage stopAllActions];
    [gameController animateSprite:leftStage withPiece:LeftStagePiece WithAnimationName:PiecesAnimationNameIdle andLoop:YES];
    
    [self performSelector:@selector(addComputerPieceToBoardAtIndex: ) withObject:[NSNumber numberWithInt:index] afterDelay:kCOMPUTER_TURN_DELAY];
    
    

}
-(void)addComputerPieceToBoardAtIndex:(NSNumber*)index{
    PiecesDirections direction=[[MappedDirections objectAtIndex:[index intValue]] intValue];
    GamePiece* piece=[[[GamePiece alloc]init] autorelease];
    piece.theme=selectedPiecesTheme;
    piece.model=opponentPiecesModel;
    piece.animationName=PiecesAnimationNameStatic;
    piece.direction=direction;
    
    piece.type=LeftStagePiece.type;

    [self playerPlayedPiece:piece atBoardIndex:[index intValue] withPlayer: PlayerTypeOpponent];
}
#pragma mark AlertViewDelegate Methods
//-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
//    if (alertView==newGameAlertView) {
//        if (buttonIndex==0) {
//           
//            [self backButtonTouched:nil];
//        
//        }else{
//            if (isMultiplayer) {
//                self.isTouchEnabled=NO;
//                [gameController createMatchNewRequest];
//            }else{
//            
//                [self newGame];
//            }
//          
//        }
//        newGameAlertView=nil;
//    }else if(alertView==whoStartAlert){
//        if (blackOverlaySprite!=nil) {
//            [self unschedule:@selector(decreaseWaitingTime:)];
//            [blackOverlaySprite removeFromParentAndCleanup:YES];
//            blackOverlaySprite=nil;
//            if (isMultiplayer) {
//                waitingTimerLabel=nil;
//                [self addWaitingTimer];
//            }
//           
//            if (!isMultiplayer&&!gameController.isLocalPlayerTurn) {
//                [self setWhoPlay:whoBeats];
//            }
////            if (gameController.isLocalPlayerTurn) {
//               
////            }
//
//        }
//    }else if(alertView.tag==GameSceneTagConfirmationAlert){
//        if (buttonIndex!=0) {
//            
//            [self backButtonTouched:nil];
//            
//        }
//        
//    }
//}
//

#pragma -

-(void)onExit{
    [[CCTouchDispatcher sharedDispatcher]removeDelegate:self];
    [super onExit];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [Points release];
    [Rects release];
    [boardSpritesArray release];
    [boardPiecesArray release];
    [lp_availablePiecesCounts release];
    [lp_Available_Pieces release];
    [opp_Available_Pieces release];
    [opp_availablePiecesCounts release];
    [LeftStagePiece release];
    [RightStagePiece release];
    
    [MappedDirections release];
    
//    gkHelper.delegate=nil;
	// don't forget to call "super dealloc"
	[super dealloc];
}


#pragma Log Flurry Events
- (void)logGameStart
{
    gameStarted = YES;
    if (isMultiplayer) {
        [StatisticsCollector logEvent:@"Multi-player" timed:YES];
    }else {
        switch (gameDifficulty) {
            case GameDifficultyEasy:
                [StatisticsCollector logEvent:@"Single-player_Easy" timed:YES];
                break;
            case GameDifficultyMedium:
                [StatisticsCollector logEvent:@"Single-player_Medium" timed:YES];
                break;
            case GameDifficultyHard:
                [StatisticsCollector logEvent:@"Single-player_Hard" timed:YES];
                break;
                
            default:
                break;
        }
    }
}
- (void)logGameEnd
{
    if (!gameStarted) {
        return;
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"Exit" forKey:@"Result"];
    if (isMultiplayer) {
        [StatisticsCollector endTimedEvent:@"Multi-player" withParameters:params];
    }else {
        switch (gameDifficulty) {
            case GameDifficultyEasy:
                [StatisticsCollector endTimedEvent:@"Single-player_Easy" withParameters:params];
                break;
            case GameDifficultyMedium:
                [StatisticsCollector endTimedEvent:@"Single-player_Medium" withParameters:params];
                break;
            case GameDifficultyHard:
                [StatisticsCollector endTimedEvent:@"Single-player_Hard" withParameters:params];
                break;
                
            default:
                break;
        }
    }
}
- (void)logGameWin
{
    gameStarted = NO;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"Win" forKey:@"Result"];
    if (isMultiplayer) {
        [StatisticsCollector endTimedEvent:@"Multi-player" withParameters:params];
    }else {
        switch (gameDifficulty) {
            case GameDifficultyEasy:
                [StatisticsCollector endTimedEvent:@"Single-player_Easy" withParameters:params];
                break;
            case GameDifficultyMedium:
                [StatisticsCollector endTimedEvent:@"Single-player_Medium" withParameters:params];
                break;
            case GameDifficultyHard:
                [StatisticsCollector endTimedEvent:@"Single-player_Hard" withParameters:params];
                break;
                
            default:
                break;
        }
    }
}
- (void)logGameLose
{
    gameStarted = NO;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"Lose" forKey:@"Result"];
    if (isMultiplayer) {
        [StatisticsCollector endTimedEvent:@"Multi-player" withParameters:params];
    }else {
        switch (gameDifficulty) {
            case GameDifficultyEasy:
                [StatisticsCollector endTimedEvent:@"Single-player_Easy" withParameters:params];
                break;
            case GameDifficultyMedium:
                [StatisticsCollector endTimedEvent:@"Single-player_Medium" withParameters:params];
                break;
            case GameDifficultyHard:
                [StatisticsCollector endTimedEvent:@"Single-player_Hard" withParameters:params];
                break;
                
            default:
                break;
        }
    }
}
@end
