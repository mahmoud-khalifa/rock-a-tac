//
//  Controller.h
//  TextTwistGame
//
//  Created by Log n Labs on 6/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GamePiece.h"
#import "BoardObject.h"
#import "GameKitHelper.h"
#import "MPPacket.h"


#import <SystemConfiguration/SystemConfiguration.h>

//#ifndef LITE_VERSION
#import "MKStoreManager.h"
//#endif

#import "BlockAlertView.h"

#define kBOARD_OBJECTS_COUNT 9


#define kPIECE_ANIMATION_DELAY 0.1
typedef enum
{
    BackgroundThemeEgypt=0,
    BackgroundThemeForest,
    BackgroundThemeKingdom,
    BackgroundThemeMAX,
    
} BackgroundThemes;



typedef enum
{
    PlaceStateEmpty=0,
    PlaceStateCanReplace,
    PlaceStateCanNotReplace,
    
} PlaceStates;

typedef enum
{
    GameDifficultyNone=-1,
    GameDifficultyEasy=0,
    GameDifficultyMedium,
    GameDifficultyHard,
    
} GameDifficulties;

@protocol ControllerProtocol
@optional
-(void)onDidReceiveData:(NSData*)data fromPlayer:(NSString*)playerID;
-(void)onStartNewMultiplayerGame;
-(void)addOpponentNewPieceWithPieceType:(PiecesTypes)pieceType atIndex:(int)index;
-(void)onPurchaseFeatureCompleted:(NSString*)featureId;
@end
@interface Controller : NSObject<GameKitHelperProtocol>{//,UIAlertViewDelegate> {

    id<ControllerProtocol> delegate;
	
    
    NSMutableArray* boardArray;
    
    bool boardFull;
    
    GameKitHelper* gkHelper;
    bool isOpponentLeftGame;
    
    BackgroundThemes bgTheme;
    PiecesModels pieceModel;
    bool isLocalPlayerTurn;
    
    PiecesTypes opp_startPieceType;
    PiecesTypes lp_startPieceType;
    
    BlockAlertView *loadingView;
//       UIAlertView *loadingView;
//    UIAlertView *loadingView2;
    BlockAlertView*loadingView2;
    
    NSMutableArray* winningPlaces;
}
@property (nonatomic,assign)id<ControllerProtocol> delegate;

@property(nonatomic,readonly)NSMutableArray* boardArray;
@property(nonatomic, assign)GameKitHelper* gkHelper;

@property BackgroundThemes bgTheme;
@property PiecesModels pieceModel;
@property bool isLocalPlayerTurn;

@property PiecesTypes opp_startPieceType;
@property PiecesTypes lp_startPieceType;


@property(nonatomic,retain) NSMutableArray* winningPlaces;

+(Controller*) sharedController;
-(void)authenticateLocalPlayer;
-(void)showLeaderBoardWithCategory:(NSString*)category;
-(void) submitScore:(int64_t)score category:(NSString*)category;
-(void)resetBoardArray;
-(NSString*)getPieceNameWithPiece:(GamePiece*)piece;
-(PlayerTypes)addPiece:(GamePiece*)piece atBoardIndex:(int)index withPlayer:(PlayerTypes)player;

-(PlaceStates)checkIfPlaceAvailableWithBoardObject:(BoardObject*)boardObject atIndex:(int)index;
-(bool) isBoardFull;
-(PlayerTypes)checkWhoBeatsWithNewBoardObject:(BoardObject*)newObject andCurrentBoardObject:(BoardObject*)currentObject;

-(PlayerTypes)checkWinnerForPlayer:(PlayerTypes)player;


-(void) createMatchNewRequest;
-(void) multiPlayerSendDisconnected;
-(void) multiplayerSendPiece:(GamePiece* )piece atIndex:(int)index;

-(void) multiplayerSendStagePiece:(GamePiece*)piece;

-(void) multiplayerSendWhoStartPiece:(PiecesTypes)type;

-(PlayerTypes)checkWhoStarts;
-(void) showLoadingIndicator;
-(void) hideLoadingIndicator;

-(void)animateSprite:(CCSprite*)sprite withPiece:(GamePiece*)piece WithAnimationName:(PiecesAnimationNames)animationName andLoop:(BOOL)loop;

-(NSMutableArray*)getVulnerablePiecesIndexesWithPiece:(PiecesTypes)pieceType andPlayerType:(PlayerTypes)playerType;

-(void)singlePlayerStartNewGameWithDifficulty:(GameDifficulties)gameDifficulty andWhoFirst:(PlayerTypes)player;
-(void)singlePlayerPlayedPiece:(GamePiece*)piece atBoardIndex:(int)index;
-(void)singlePlayerComputerTurn;

//#ifndef LITE_VERSION
-(void)buyFeature:(NSString*)featureId;
-(bool )isFeaturePurchased:(NSString*)featureId;
//#endif




-(BOOL)connectedToWeb;

@end
