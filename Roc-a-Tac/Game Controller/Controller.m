//
//  Controller.m
//  TextTwistGame
//
//  Created by Log n Labs on 6/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Controller.h"
#import <UIKit/UITextChecker.h>
#import "GameScene.h"
#import "CCAnimationHelper.h"
#import "computerplayer.h"
@implementation Controller
@synthesize bgTheme,pieceModel,isLocalPlayerTurn;
@synthesize delegate;
@synthesize boardArray;
@synthesize gkHelper;
@synthesize opp_startPieceType,lp_startPieceType;
@synthesize winningPlaces;
static Controller *instanceOfController;

NSString * const PiecesThemesString[] = {
    @"A"
};

NSString * const PiecesTypesString[] = {
    
    @"Stone",
    @"Scissor",
    @"Paper"
    
};

NSString * const PiecesModelsString[] = {
    
    @"Good",
    @"Devil",
    @"Gold"
};

NSString * const PiecesAnimationNamesString[] = {
    @"static",
    @"bringToLife",
    @"idle",
    @"victory"
};

-(void)dealloc{
    
    [instanceOfController release];
	instanceOfController = nil;
    
    [boardArray release];
    
    gkHelper=nil;
    [super dealloc];
}
-(id)init{
    self=[super init];
    if (self) {

        //Game Center:
        gkHelper = [GameKitHelper sharedGameKitHelper];
        gkHelper.delegate = self;
        
        boardArray=[[NSMutableArray alloc]initWithCapacity:kBOARD_OBJECTS_COUNT];
        [self resetBoardArray];
        
        winningPlaces=[[NSMutableArray alloc]initWithCapacity:3];
        
//        opp_startPieceType=PiecesTypeNone;
        
    }
    return self;
}
#pragma mark Singleton stuff
+(id) alloc
{
	@synchronized(self)	
	{
		NSAssert(instanceOfController == nil, @"Attempted to allocate a second instance of the singleton: Game Controller");
		instanceOfController = [[super alloc] retain];
        
		return instanceOfController;
	}
	// to avoid compiler warning
	return nil;
}

+(Controller*) sharedController
{
	@synchronized(self)
	{
		if (instanceOfController == nil)
		{
			[[Controller alloc] init];
		}
        return instanceOfController;
	}
	// to avoid compiler warning
	return nil;
}

-(void)resetBoardArray{
    [boardArray removeAllObjects];
    BoardObject *obj=[[BoardObject alloc]init];
    [boardArray addObjectsFromArray:[NSArray arrayWithObjects:obj,obj,obj,obj,obj,obj,obj,obj,obj, nil]];
    [obj autorelease];
    
    boardFull=NO;
    [winningPlaces removeAllObjects];
}

-(NSString*)getPieceNameWithPiece:(GamePiece*)piece{
    CCSpriteFrameCache*frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    [frameCache  addSpriteFramesWithFile:[NSString stringWithFormat:@"CH_%@_%@_%@_%@.plist",PiecesTypesString[piece.type],PiecesThemesString[piece.theme],PiecesModelsString[piece.model],PiecesAnimationNamesString[piece.animationName]]];
    
    piece.imageName=[NSString stringWithFormat:@"CH_%@_%@_%@_%@_%d.00.png",PiecesTypesString[piece.type],PiecesThemesString[piece.theme],PiecesModelsString[piece.model],PiecesAnimationNamesString[piece.animationName],piece.direction];

    return piece.imageName;
}

-(PlayerTypes)addPiece:(GamePiece*)piece atBoardIndex:(int)index withPlayer:(PlayerTypes)player{
    BoardObject *obj=[[BoardObject alloc]init];
    obj.pieceType=piece.type;
    obj.playerType=player;
    [boardArray replaceObjectAtIndex:index withObject:obj ];
    PlayerTypes whoWins=[self checkWinnerForPlayer:player];

    return whoWins;
}

-(PlaceStates)checkIfPlaceAvailableWithBoardObject:(BoardObject*)boardObject atIndex:(int)index{
    BoardObject* currentObj=[boardArray objectAtIndex:index];
    if (currentObj.playerType==PlayerTypeNone) {
        return PlaceStateEmpty;
    }else if(((currentObj.playerType==PlayerTypeOpponent && boardObject.playerType==PlayerTypeLocalPlayer)||(currentObj.playerType==PlayerTypeLocalPlayer && boardObject.playerType==PlayerTypeOpponent)) &&[self isBoardFull]){
        
        PlayerTypes whoBeats=[self checkWhoBeatsWithNewBoardObject:boardObject andCurrentBoardObject:currentObj];
        if (whoBeats==boardObject.playerType) {
            return PlaceStateCanReplace;
        }else{
            return PlaceStateCanNotReplace;
        }
    }
    return PlaceStateCanNotReplace;
}

-(bool) isBoardFull{
    if (!boardFull) {
        for (BoardObject* boardObj in boardArray) {
            if (boardObj.playerType==PlayerTypeNone) {
                return NO;
            }
        }
        boardFull=YES;
    }
    
    return boardFull;
}

-(PlayerTypes)checkWhoBeatsWithNewBoardObject:(BoardObject*)newObject andCurrentBoardObject:(BoardObject*)currentObject{
    int deference=newObject.pieceType-currentObject.pieceType;
    if (deference==-1 || deference==2) {
        return newObject.playerType;
    }else if(deference==-2||deference==1){
        return currentObject.playerType;
    }
    return PlayerTypeNone;
}

-(PlayerTypes)checkWinnerForPlayer:(PlayerTypes)player{
    
    /*the next for loop to check if any player wins by completing a row*/
    for (int i=0; i<kBOARD_OBJECTS_COUNT; i=i+3) {
        BoardObject* obj1=(BoardObject*)[boardArray objectAtIndex:i];
        BoardObject* obj2=(BoardObject*)[boardArray objectAtIndex:i+1];
        BoardObject* obj3=(BoardObject*)[boardArray objectAtIndex:i+2];
        if (((obj1.playerType==obj2.playerType) && (obj1.playerType ==obj3.playerType ))
            &&((obj1.pieceType!=obj2.pieceType) && (obj1.pieceType!=obj3.pieceType)&&(obj2.pieceType!=obj3.pieceType))
            &&(obj1.playerType==player)) {
            
            [winningPlaces addObjectsFromArray:[NSArray arrayWithObjects:[NSNumber numberWithInt:i],[NSNumber numberWithInt:i+1],[NSNumber numberWithInt:i+2], nil]];
            return player;
            
            

        }
    }
    
    /*the next for loop to check if any player wins by completing a diagonal or vertical line */
    for (int i=0; i<3; i++) {
        BoardObject* obj1=(BoardObject*)[boardArray objectAtIndex:i];
        BoardObject* obj2=(BoardObject*)[boardArray objectAtIndex:i+4];
        BoardObject* obj3;
        if (i==0) {
              obj3=(BoardObject*)[boardArray objectAtIndex:i+8];
        }
      
        
        BoardObject* obj4=(BoardObject*)[boardArray objectAtIndex:i+2];
        BoardObject* obj5=(BoardObject*)[boardArray objectAtIndex:i+6];
        BoardObject* obj6=(BoardObject*)[boardArray objectAtIndex:i+3];
        
        //Diagonal:
        if ((i==0)&&
            ((((obj1.playerType==obj2.playerType)&&(obj1.playerType==obj3.playerType))
              &&((obj1.pieceType!=obj2.pieceType) && (obj1.pieceType!=obj3.pieceType)&&(obj2.pieceType!=obj3.pieceType))

              &&(obj1.playerType==player))
             
             ||(((obj4.playerType==obj2.playerType)&&(obj4.playerType==obj5.playerType))
                &&((obj4.pieceType!=obj2.pieceType) && (obj4.pieceType!=obj5.pieceType)&&(obj2.pieceType!=obj5.pieceType))
                
                &&(obj2.playerType==player))
             )) {

                if ((obj1.playerType==obj2.playerType)&&(obj1.playerType==obj3.playerType)) {
                   
                    [winningPlaces addObjectsFromArray:[NSArray arrayWithObjects:[NSNumber numberWithInt:i],[NSNumber numberWithInt:i+4],[NSNumber numberWithInt:i+8], nil]];
                    CCLOG(@"winning places: %@",winningPlaces);
                
                }else{
                    [winningPlaces addObjectsFromArray:[NSArray arrayWithObjects:[NSNumber numberWithInt:i+2],[NSNumber numberWithInt:i+4],[NSNumber numberWithInt:i+6], nil]];
                    
                }
               
                return player;

            }
        //Vertical Line:
        if (((obj1.playerType==obj6.playerType)&&(obj1.playerType==obj5.playerType))
            &&((obj1.pieceType!=obj6.pieceType) && (obj1.pieceType!=obj5.pieceType)&&(obj6.pieceType!=obj5.pieceType))
            
            &&(obj1.playerType==player)) {
                [winningPlaces addObjectsFromArray:[NSArray arrayWithObjects:[NSNumber numberWithInt: i],[NSNumber numberWithInt:i+3],[NSNumber numberWithInt:i+6], nil]];
            return player;

      
        }
    }
        
    
    return PlayerTypeNone;
}


#pragma mark GameCenter Methods
-(void)authenticateLocalPlayer{
    if ([self connectedToWeb]) {
        if ([GKLocalPlayer localPlayer].authenticated==NO) {
            [gkHelper authenticateLocalPlayer];
        }
    }
    
}
-(void)showLeaderBoardWithCategory:(NSString*)category{

    [gkHelper showLeaderboardWithCategory:category];
}

-(void) submitScore:(int64_t)score category:(NSString*)category{

    [gkHelper submitScore:score category:category];
}
-(void)createMatchNewRequest{
    isOpponentLeftGame=NO;
    /*Create a new Match Request*/

	GKMatchRequest *request = [[[GKMatchRequest alloc] init] autorelease]; 
	request.minPlayers = 2; 
	request.maxPlayers = 2;
    
	
	/* get the instance of the singleton class (GameKitHelper) & set the delegate to self */
    //	GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
    //	gkHelper.delegate = self;
    //	
	/* the next two lines to disconnect the current match if exists to be ready to create a new match */
	[gkHelper disconnectCurrentMatch];
	gkHelper.matchStarted=NO;
	[gkHelper showMatchmakerWithRequest:request];
    
    //Prevent the device from sleeping:
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;

}

- (void) multiPlayerSendDisconnected{
	if (gkHelper.currentMatch != nil)
	{
		GamePacket msg;
		msg.theMessageKind = Disconnected_Message;
		[gkHelper sendDataToAllPlayers:&msg length:sizeof(msg)];
        //		gkHelper.delegate=nil;
	}
}

-(void)multiplayerSendPiece:(GamePiece* )piece atIndex:(int)index{
    if (gkHelper.currentMatch != nil)
    {
        GamePacket msg;
        msg.theMessageKind=Player_Added_Piece_Message;
        msg.pieceType=piece.type;
        msg.pieceTheme=piece.theme;
        msg.pieceModel=piece.model;
        msg.pieceDirection=piece.direction;
        msg.pieceAnimationName=piece.animationName;

        msg.boardIndex=index;
        [gkHelper sendDataToAllPlayers:&msg length:sizeof(msg)];
        
    }
    
}

-(void)multiplayerSendStagePiece:(GamePiece*)piece{
    if (gkHelper.currentMatch != nil)
    {
        StagePacket msg;
        msg.theMessageKind=Player_Changed_Stage_Piece_Message;
        msg.pieceType=piece.type;
       
        [gkHelper sendDataToAllPlayers:&msg length:sizeof(msg)];
        
    }
    
}


-(void) multiplayerSendWhoStartPiece:(PiecesTypes)type{
    if (gkHelper.currentMatch != nil)
    {
    
        StartPiecePacket msg;
        msg.theMessageKind=Player_Send_Who_Start_Piece_Message;
        msg.pieceType=type;
        [gkHelper sendDataToAllPlayers:&msg length:sizeof(msg)];
        
    }
    
}
-(PlayerTypes)checkWhoStarts{
    
    BoardObject * OpponentObject=[[[BoardObject alloc]init] autorelease];
    OpponentObject.pieceType=opp_startPieceType;
    OpponentObject.playerType=PlayerTypeOpponent;
    
    BoardObject * LocalPlayerObject=[[[BoardObject alloc]init] autorelease];
    LocalPlayerObject.pieceType=lp_startPieceType;
    LocalPlayerObject.playerType=PlayerTypeLocalPlayer;
    return ([self checkWhoBeatsWithNewBoardObject:OpponentObject andCurrentBoardObject:LocalPlayerObject]);

    
}
#pragma mark Loading Indicator
-(void) showLoadingIndicator{

    loadingView=[BlockAlertView alertWithTitle:nil message: NSLocalizedString(@"Waiting for the opponent...", @"Waiting for opponent") andLoadingviewEnabled:YES];
    
    [loadingView setCancelButtonWithTitle: NSLocalizedString(@"Cancel", @"Cancel") block:^{
        [[CCDirector sharedDirector]popScene];
         loadingView=nil ;
        
        [self multiPlayerSendDisconnected];
        [self.gkHelper disconnectCurrentMatch];
    }];

      [loadingView show];

    
    
//    loadingView = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
//	
//	UIActivityIndicatorView *actInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//	actInd.frame = CGRectMake(128.0f, 45.0f, 25.0f, 25.0f);
//	[loadingView addSubview:actInd];
//	[actInd startAnimating];
//	[actInd release];	
//    
//    UILabel *l = [[UILabel alloc]init];
//	l.frame = CGRectMake(50, -25, 200, 100);
//   	l.text = @"Waiting for the opponent...";
//
//	l.font = [UIFont fontWithName:@"Helvetica" size:16];	
//	l.textColor = [UIColor whiteColor];
//	l.shadowColor = [UIColor blackColor];
//	l.shadowOffset = CGSizeMake(1.0, 1.0);
//	l.backgroundColor = [UIColor clearColor];
//	[loadingView addSubview:l];		
//	[l release];
//    
//	[loadingView show];
    
}

-(void)hideLoadingIndicator{
    if (loadingView!=nil) {
        [loadingView dismissWithClickedButtonIndex:-1 animated:NO];
        loadingView=nil ;
    }
}

#pragma mark GameKitHelper delegate methods
-(void) onLocalPlayerAuthenticationChanged
{
	GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
	CCLOG(@"LocalPlayer isAuthenticated changed to: %@", localPlayer.authenticated ? @"YES" : @"NO");
	
	if (localPlayer.authenticated)
	{
        //	GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
        //	[gkHelper getLocalPlayerFriends];
		//[gkHelper resetAchievements];
	}	
}

-(void) onScoresSubmitted:(bool)success
{
	CCLOG(@"onScoresSubmitted: %@", success ? @"YES" : @"NO");
}

-(void) onScoresReceived:(NSArray*)scores
{
	CCLOG(@"onScoresReceived: %@", [scores description]);
}

-(void) onLeaderboardViewDismissed
{
	CCLOG(@"onLeaderboardViewDismissed");
}

-(void) onMatchFound:(GKMatch*)match{
    
    //    CCLOG(@"%d",[match.playerIDs count]);
    
}

-(void) onMatchmakingViewDismissed{
    
    //allow the device to sleep
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

-(void) onMatchmakingViewError{
    
    //allow the device to sleep
//    [gkHelper dismissModalViewController];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

-(void) onPlayersAddedToMatch:(bool)success{
}

-(void) onReceivedMatchmakingActivity:(NSInteger)activity{
}

-(void) onPlayerConnected:(NSString*)playerID{
//    CCLOG(@"local player ID:%@",[GKLocalPlayer localPlayer].playerID);
//    CCLOG(@"remote player ID:%@",playerID);
    if (!isOpponentLeftGame) {
        
        //check who start first:

        NSString *localPlayerId=[GKLocalPlayer localPlayer].playerID;
        NSString *remotePlayerId=playerID;
        
        NSComparisonResult returnResult = NSOrderedSame;
        
        returnResult = [localPlayerId compare:remotePlayerId]; //Compare the Two IDs
        
        if(returnResult!=NSOrderedAscending) {// if local player has the lowest ID
            isLocalPlayerTurn=YES;
        }else{
            isLocalPlayerTurn=NO;
        }


        if ([[CCDirector sharedDirector].runningScene class]==[GameScene class]) {
            [delegate onStartNewMultiplayerGame];
        }else{
            [[CCDirector sharedDirector]pushScene:(CCScene*)[[[GameScene alloc]initWithBackgroundTheme:bgTheme andPieceModel:pieceModel andIsMultiPlayer:YES andDifficulty:GameDifficultyNone]autorelease]];
        }
        
        
    }
    [gkHelper dismissModalViewController];
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
}

-(void) onPlayerDisconnected:(NSString*)playerID{
    
//    NSLog(@"Disconected");
//    if ([[CCDirector sharedDirector].runningScene class]==[GameScene class]) {
//        [[CCDirector sharedDirector] popScene];
//    }
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Disconnection" message:@"Your opponent has left the game." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
//    [alert release];
    isOpponentLeftGame=YES;
    [self multiPlayerSendDisconnected];
    [gkHelper disconnectCurrentMatch];

//    [gkHelper dismissModalViewController];
    
}

-(void) onStartMatch{
    
}

-(void) onReceivedData:(NSData*)data fromPlayer:(NSString*)playerID{
    
    
    CCLOG (@"[RECIVED DATA] player: %@", playerID);
    
    
    Packet p = *(Packet*)[data bytes]; 
    
	if (p.theMessageKind == Disconnected_Message) {
        
        //must be called before showing the alert view
        [delegate onDidReceiveData:data fromPlayer:playerID];

//        NSLog(@"Disconected");
//        if ([[CCDirector sharedDirector].runningScene class]==[GameScene class]) {
//            [[CCDirector sharedDirector] popScene];
//        }

//		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Disconnection" message:@"Your opponent has left the game." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//		[alert show];
//		[alert release];
        
        BlockAlertView* alert=[BlockAlertView alertWithTitle: NSLocalizedString(@"Disconnection", @"Disconnection message") message: NSLocalizedString(@"Your opponent has left the game.", @"Opponent lef the game message") andLoadingviewEnabled:NO];
        [alert setCancelButtonWithTitle: NSLocalizedString(@"OK", @"OK") block:^{
        
            NSLog(@"Disconected");
            [self hideLoadingIndicator];
            
            if ([[CCDirector sharedDirector].runningScene class]==[GameScene class]) {
                [[CCDirector sharedDirector] popScene];
            }  
            
        }];
        
        [alert show];

        
        isOpponentLeftGame=YES;
        
 
        
	}else if (p.theMessageKind == MessageTypeHostStatus) {// HOST STATUS
        //            PacketHostStatus p = *(PacketHostStatus*)[data bytes];
        //            
        //            CCLOG (@"RECIVED HOST STATUS: %d (local:%d)", p.ishost, (int)sc.matchIsHost);
        //            
        //            if (sc.matchIsHost == NO && p.ishost == 1) {
        //                [self mupltiplayerReady];
        //            } else if (sc.matchIsHost == YES && p.ishost == 0){
        //                [self mupltiplayerReady];
        //            } else {
        //                [self mupltiplayerHostSelect];
        //            }
        
        
    }else if (p.theMessageKind == Player_Added_Piece_Message) {
//        GamePacket p=*(GamePacket*)[data bytes];
//        CCLOG (@"RECIVED New Piece Added:%@ at index: %d",p.piece,p. boardIndex);
    
        [delegate onDidReceiveData:data fromPlayer:playerID];
    }else if(p.theMessageKind == Player_Changed_Stage_Piece_Message){
        [delegate onDidReceiveData:data fromPlayer:playerID];
    }else if(p.theMessageKind==Player_Send_Who_Start_Piece_Message){
    
        StartPiecePacket p=*(StartPiecePacket*)[data bytes];
        opp_startPieceType=p.pieceType;
        
        [self hideLoadingIndicator];
        
        [delegate onDidReceiveData:data fromPlayer:playerID];
    }
    
}

-(void) onFriendListReceived:(NSArray*)friends
{
	CCLOG(@"onFriendListReceived: %@", [friends description]);
}

-(void) onPlayerInfoReceived:(NSArray*)players
{
    CCLOG(@"onPlayerInfoReceived: %@", [players description]);
}


#pragma mark Animation
-(void)animateSprite:(CCSprite*)sprite withPiece:(GamePiece*)piece WithAnimationName:(PiecesAnimationNames)animationName andLoop:(BOOL)loop{
    
//    if(animationName==PiecesAnimationNameBringToLife) 
//        return;
    NSString* animationFrameName=piece.imageName;
//    CCLOG(@"frameName: %@",animationFrameName);
    animationFrameName= [animationFrameName stringByReplacingOccurrencesOfString:@".00.png" withString:@""];
    animationFrameName= [animationFrameName stringByReplacingOccurrencesOfString:PiecesAnimationNamesString[PiecesAnimationNameStatic] withString:PiecesAnimationNamesString[(int)animationName]];
    

    [[CCDirector sharedDirector]purgeCachedData];
//     CCLOG(@"frameName: %@",animationFrameName);
    CCSpriteFrameCache*frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    
   
    [frameCache  addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist",animationFrameName]];

    // Create an animation object from all the sprite animation frames 
    CCAnimation* anim= [CCAnimation animationWithFrame:animationFrameName frameCount:12 delay:kPIECE_ANIMATION_DELAY startFrom:0];
    
    // Run the animation by using the CCAnimate action 
    
    CCAnimate* animate = [CCAnimate actionWithAnimation:anim]; 
    
    if (loop) {
        CCRepeatForever* repeat=[CCRepeatForever actionWithAction:animate];
        repeat.tag=animationName;
        [sprite runAction:repeat ];
    }else{
        [sprite runAction:animate];
    }
}

-(NSMutableArray*)getVulnerablePiecesIndexesWithPiece:(PiecesTypes)pieceType andPlayerType:(PlayerTypes)playerType{
    NSMutableArray*arr=[[NSMutableArray alloc]init];
    if ([self isBoardFull]) {
        
        PiecesTypes vulnerablePiece;
        switch (pieceType) {
            case PiecesTypePaper:
                vulnerablePiece=PiecesTypeStone;
                break;
            case PiecesTypeStone:
                vulnerablePiece=PiecesTypeScissor;
                break;
            case PiecesTypeScissor:
                vulnerablePiece=PiecesTypePaper;
                break;
            default:
                break;
        }
        
        int index=0;
        for (BoardObject* obj in boardArray) {
            if (obj.pieceType==vulnerablePiece && obj.playerType==playerType) {
                [arr addObject:[NSNumber numberWithInt:index]];
            }
            index++;
        }
    }
    return [arr autorelease];

}

#pragma mark SinglePlayer methods

-(void)singlePlayerStartNewGameWithDifficulty:(GameDifficulties)gameDifficulty andWhoFirst:(PlayerTypes)player{
    int playertype;
    switch (player) {
        case PlayerTypeOpponent:
            playertype=0;
            break;
            
        case PlayerTypeLocalPlayer:
            playertype=1;
            break;
        default:
            break;
    }
  start(gameDifficulty, playertype);
}
-(void)singlePlayerPlayedPiece:(GamePiece*)piece atBoardIndex:(int)index{

    CCLOG(@"index:%d",index);
    putmove(index, piece.type);
}
-(void)singlePlayerComputerTurn{
    
    struct move m=getnextmove();
    int index=m.index;
    
    PiecesTypes type=m.type;
    CCLOG(@"index:%d, type:%d",index,type );
    
    
    BoardObject* obj=[[BoardObject alloc]init];
    obj.playerType=PlayerTypeOpponent;
    obj.pieceType=type;
    [delegate addOpponentNewPieceWithPieceType:type atIndex:index];
   // [boardArray replaceObjectAtIndex:index withObject:obj];
    


    
}

//#ifndef LITE_VERSION

#pragma in-App Purchase

-(void)buyFeature:(NSString*)featureId{
    if ([self connectedToWeb]) {
        [[MKStoreManager sharedManager] buyFeature:featureId 
                                        onComplete:^(NSString* purchasedFeature)
         {
             CCLOG(@"Purchased: %@", purchasedFeature);
             
             [loadingView dismissWithClickedButtonIndex:-1 animated:NO];
             
             UIAlertView* alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Success", @"Success mesaage") message:NSLocalizedString(@"Transaction was completed", @"Transaction was completed message") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles: nil];
             [alert show];
             [alert release];
             
             
//             BlockAlertView* alert=[BlockAlertView alertWithTitle: NSLocalizedString(@"Success", @"Success mesaage") message: NSLocalizedString(@"Transaction was completed", @"Transaction was completed message") andLoadingviewEnabled:NO];
//             [alert setCancelButtonWithTitle: NSLocalizedString(@"OK", @"OK") block:^{
//                 CCLOG(@"OK");
//             }];
//             
//             [alert show];
             
             [delegate onPurchaseFeatureCompleted:featureId];
             
             [[NSUserDefaults standardUserDefaults]setBool:YES forKey:featureId];
         }
                                       onCancelled:^
         {
             CCLOG(@"User Cancelled Transaction");
             
             
             [loadingView dismissWithClickedButtonIndex:-1 animated:NO];
             //         [delegate onPurchaseFeatureCompleted:featureId];
             
             UIAlertView* alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Operation Cancelled", @"Operation cancelled message") message:@"" delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", @"Close") otherButtonTitles: nil];
             [alert show];
             [alert release];
             
//             BlockAlertView* alert=[BlockAlertView alertWithTitle: NSLocalizedString(@"Operation Cancelled", @"Operation cancelled message") message:@"" andLoadingviewEnabled:NO];
//             [alert setCancelButtonWithTitle:NSLocalizedString(@"Close", @"Close") block:^{
//                 CCLOG(@"Close");
//             }];
//             
//             [alert show];
             
             
         }];
        
        //    loadingView2 = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        //	
        //	UIActivityIndicatorView *actInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        //	actInd.frame = CGRectMake(128.0f, 45.0f, 25.0f, 25.0f);
        //	[loadingView2 addSubview:actInd];
        //	[actInd startAnimating];
        //	[actInd release];	
        //    
        //    UILabel *l = [[UILabel alloc]init];
        //	l.frame = CGRectMake(100, -25, 210, 100);
        //	l.text = @"Please wait...";
        //	l.font = [UIFont fontWithName:@"Helvetica" size:16];	
        //	l.textColor = [UIColor whiteColor];
        //	l.shadowColor = [UIColor blackColor];
        //	l.shadowOffset = CGSizeMake(1.0, 1.0);
        //	l.backgroundColor = [UIColor clearColor];
        //	[loadingView2 addSubview:l];		
        //	[l release];
        //    
        //	[loadingView2 show];
        //    
        
        loadingView=[BlockAlertView alertWithTitle:nil message: NSLocalizedString(@"Please wait...", @"Please wait") andLoadingviewEnabled:YES];
        
        //    [loadingView setCancelButtonWithTitle:@"Cancel" block:^{
        //        CCLOG(@"User Cancelled Transaction");
        //        
        //        
        //        [loadingView dismissWithClickedButtonIndex:-1 animated:NO];
        //        //         [delegate onPurchaseFeatureCompleted:featureId];
        //        
        //        //         UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"Operation Cancelled" message:@"Transaction was cancelled" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
        //        //         [alert show];
        //        //         [alert release];
        //        
        //       
        //
        //    }];
        
        [loadingView show];

    }else {
        BlockAlertView* alert=[BlockAlertView alertWithTitle: NSLocalizedString(@"No Internet Connection", @"No internet connection") message: NSLocalizedString(@"Please Connect to the Internet then try again", @"Please Connect to the Internet then try again") andLoadingviewEnabled:NO];
        [alert setCancelButtonWithTitle:NSLocalizedString(@"OK", @"OK") block:nil];
        
        [alert show];

    }
}

-(bool )isFeaturePurchased:(NSString*)featureId{
    if ([self connectedToWeb]) {
        bool isFeaturePurchasedBefore=[MKStoreManager  isFeaturePurchased:featureId];
        [[NSUserDefaults standardUserDefaults] setBool:isFeaturePurchasedBefore forKey:featureId];
         return [MKStoreManager  isFeaturePurchased:featureId];
    }else {
        return  [[NSUserDefaults standardUserDefaults]boolForKey:featureId];
    }
   
}


-(BOOL)connectedToWeb {
	BOOL connected;
	const char *host = "www.google.com";
	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host);
	SCNetworkReachabilityFlags flags;
	connected = SCNetworkReachabilityGetFlags(reachability, &flags);
	BOOL isConnected = connected && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
	CFRelease(reachability);
	return isConnected;
}
//#endif
@end
