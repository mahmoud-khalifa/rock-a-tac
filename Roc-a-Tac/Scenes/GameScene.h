//
//  GameScene.h
//  TicTacToe
//
//  Created by Log n Labs on 1/31/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Controller.h"
//#import "GameKitHelper.h"

#import "BlockAlertView.h"

typedef enum
{
    GameSceneTagBlinkAction=100,
    GameSceneTagConfirmationAlert,
    
    
} GameSceneTags;
typedef enum
{
    TutorialA,
    TutorialB,    
    
} TutorialTypes;

@interface GameScene : CCLayer <ControllerProtocol>{//,UIAlertViewDelegate>{
    Controller*gameController;
    
    NSMutableArray* boardSpritesArray;
    NSMutableArray* boardPiecesArray;
    
    float scale;
    
    NSArray* Points;
    NSArray* Rects;
    NSArray* zOrders;
    
    NSArray* MappedDirections;
    
    PiecesThemes selectedPiecesTheme;
    PiecesModels localPlayerPiecesModel;
    PiecesModels opponentPiecesModel;
    
    CCSprite* rightStage;
    CCSprite* leftStage;
    
    GamePiece* RightStagePiece;
    GamePiece* LeftStagePiece;
    
//    int lp_AvailableScissors;
//    int lp_AvailableStones;
//    int lp_AvailablePapers;
//    
//    int opp_AvailableScissors;
//    int opp_AvailableStones;
//    int opp_AvailablePapers;
    
    NSMutableArray* lp_availablePiecesCounts;
    
    NSMutableArray* lp_Available_Pieces;
    
    NSMutableArray* opp_availablePiecesCounts;
    
    NSMutableArray* opp_Available_Pieces;
    
    BOOL isSwapping;
    
    bool isMultiplayer;
    
//    GameKitHelper* gkHelper;
    
    int lp_score;
    int opp_score;
    
    CCLabelBMFont * scoreLable;
    
    bool isFirstGame;
    
//    UIAlertView* newGameAlertView;
    
    CCSprite* blackOverlaySprite;
    
    CCSprite* lp_selectedPiece;
    CCSprite* opp_selectedPiece;

    
    CCMenu * whoFisrtMenu;
    
    CCLabelBMFont* waitingTimerLabel;
    float waitingTime;
    int myWaitingTime;
    
//    UIAlertView* whoStartAlert;
    BlockAlertView* whoStartAlert;
    
    bool isFirstPlay;
    
    CCSprite* grid;
    GameDifficulties gameDifficulty;
    
    PlayerTypes whoBeats;
    
    int playerWinsBefore;
    
    CCSprite* tutorialSprite;
    
    int piecesAddedCount;
    
    NSUserDefaults* defaults;
    CCSpriteFrameCache*frameCache;
    
    bool oldTouchEnabledState;
    
    CCSprite* winnerAllert;
    
    BOOL gameStarted;
    
    bool isLocalPlayerTurn;
    
    bool isPieceSelected;
    
    bool isTutorialShown;
}
+(CCScene *) scene;
-(id) initWithBackgroundTheme:(BackgroundThemes)selectedTheme andPieceModel:(PiecesModels)selectedPieceModel andIsMultiPlayer:(bool )multiplayer andDifficulty:(GameDifficulties)difficulty;
@end
