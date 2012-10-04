//
//  GameConfig.h
//  TicTacToe
//
//  Created by Log n Labs on 1/31/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#ifndef __GAME_CONFIG_H
#define __GAME_CONFIG_H

//
// Supported Autorotations:
//		None,
//		UIViewController,
//		CCDirector
//
#define kGameAutorotationNone 0
#define kGameAutorotationCCDirector 1
#define kGameAutorotationUIViewController 2

#define MOPUB_BANNER_SIZE_SMALL	CGSizeMake(320, 50)
//
// Define here the type of autorotation that you want for your game
//

// 3rd generation and newer devices: Rotate using UIViewController. Rotation should be supported on iPad apps.
// TIP:
// To improve the performance, you should set this value to "kGameAutorotationNone" or "kGameAutorotationCCDirector"
#if defined(__ARM_NEON__) || TARGET_IPHONE_SIMULATOR
#define GAME_AUTOROTATION kGameAutorotationUIViewController

// ARMv6 (1st and 2nd generation devices): Don't rotate. It is very expensive
#elif __arm__
#define GAME_AUTOROTATION kGameAutorotationNone


// Ignore this value on Mac
#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)

#else
#error(unknown architecture)
#endif

#endif // __GAME_CONFIG_H


#ifdef ARABIC_VERSION

#define TAPJOY_PLIST_URL @"http://www.stariosgames.com/resources/rockatac_arabic/settings.plist"

#define kMOPUB_ID @"agltb3B1Yi1pbmNyDQsSBFNpdGUYgqX7FAw"

#define kREVMOB_ID @"5032d4050be3830800000028"

#define kTAPJOY_APP_ID @"7d3b5e03-764d-4895-8266-7eb2e24e2c47"
#define kTAPJOY_APP_SECRET_KEY @"fN9I6fDx7Htav8fm6rct"

#define kFLURRY_APP_KEY @"6QS2XZDY9BZNNSGTZWVZ"

#define kCHARTBOOST_APP_ID @"5032c8e117ba47d85800003b"
#define kCHARTBOOST_APP_SIGNATURE @"55267d7aa26990af7344ec60acc0545256402a2c"

#define K_ITUNES_RATE_LINK @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=554834149&onlyLatestVersion=false&type=Purple+Software"
#define kFULL_APP_LINK @"http://itunes.apple.com/us/app/rock-a-tac-arabic/id554834149?ls=1&mt=8"
#define kLITE_APP_LINK @"http://itunes.apple.com/us/app/rock-a-tac-arabic/id554834149?ls=1&mt=8"

#define kSHORT_APP_URL @"http://bit.ly/rockatacTFsig"

#else

#define TAPJOY_PLIST_URL @"http://www.stariosgames.com/resources/rockatac/settings.plist"
//#define TAPJOY_PLIST_URL @"http://enderval.cerebr.info/ios/private/com.stariosgames.rockatac/settings.plist"
#define kMOPUB_ID @"agltb3B1Yi1pbmNyDQsSBFNpdGUY2cbHEgw"

#define kREVMOB_ID @"4fd138459398a2000c000078"
//#define kREVMOB_ID @"5032d4050be3830800000028"

#define kTAPJOY_APP_ID @"21a0bcc9-58da-457b-a298-8e451a123fd6"
#define kTAPJOY_APP_SECRET_KEY @"qmdo042RRQ8JGU0HOISV"

#define kFLURRY_APP_KEY @"6J96897HXRFFT7TPDCML"

#define kCHARTBOOST_APP_ID @"4f79ee00f77659914b000091"
#define kCHARTBOOST_APP_SIGNATURE @"07edd5c74516f10f5342287a60c6e98430edab58"

#define K_ITUNES_RATE_LINK @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=508473418&onlyLatestVersion=false&type=Purple+Software"
#define kFULL_APP_LINK @"http://itunes.apple.com/us/app/rock-a-tac/id500565230?ls=1&mt=8"
#define kLITE_APP_LINK @"http://itunes.apple.com/us/app/rock-a-tac-free/id508473418?ls=1&mt=8"

#define kSHORT_APP_URL @"http://bit.ly/rockatacTFsig"

#endif


//#define kMOPUB_ID @"agltb3B1Yi1pbmNyDQsSBFNpdGUY3Yj6FAw"

//#define kPLAY_HAVEN_TOKEN @"99f5862a36044adbab543e4b31a48a0f"
//#define kPLAY_HAVEN_SECRET @"1e787957034b49c5944ec50fe33791d6"

//#define TAPJOY_PLIST_URL @"http://localhost:8888/rocatac_ServerList.plist"

//#define TAPJOY_PLIST_URL @"http://www.stariosgames.com/resources/rockatac/settings.plist"//@"http://enderval.cerebr.info/ios/private/com.stariosgames.rockatacfree/settings.plist/"//@"http://www.stariosgames.com/resources/rockatac/GameControllerLite.plist"


/////////////////////////////////////////////////////////////////////

#define screenSize ([[CCDirector sharedDirector]winSize])

#ifdef UI_USER_INTERFACE_IDIOM
#define IS_IPAD() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#else
#define IS_IPAD() (NO)
#endif

#define IS_RETINA() [[CCDirector sharedDirector] enableRetinaDisplay:YES]

/*  NORMAL DETAILS */
#define kScreenHeight       480
#define kScreenWidth        320

/* OFFSETS TO ACCOMMODATE IPAD */
#define kXoffsetiPad        64
#define kYoffsetiPad        32

#define kSMALL_PIECES_SCALE 0.6

#define ADJUST_CCP(__p__)       \
(IS_IPAD() == YES ?             \
ccp( ( __p__.x * 2 ) + kXoffsetiPad, ( __p__.y * 2 ) + kYoffsetiPad ) : \
__p__)

#define REVERSE_CCP(__p__)      \
(IS_IPAD() == YES ?             \
ccp( ( __p__.x - kXoffsetiPad ) / 2, ( __p__.y - kYoffsetiPad ) / 2 ) : \
__p__)

#define ADJUST_XY(__x__, __y__)     \
(IS_IPAD() == YES ?                     \
ccp( ( __x__ * 2 ) + kXoffsetiPad, ( __y__ * 2 ) + kYoffsetiPad ) : \
ccp(__x__, __y__))

//#define ADJUST_XY(__x__, __y__)     \
//(IS_IPAD() == YES ?                     \
//(IS_RETINA() == YES ? ccp(( __x__ * 2 ), ( __y__ * 2 )) : ccp( ( __x__ * 2 ) + kXoffsetiPad, ( __y__ * 2 ) + kYoffsetiPad ) ) : \
//ccp(__x__, __y__))


#define ADJUST_X(__x__)         \
(IS_IPAD() == YES ?             \
( __x__ * 2 ) + kXoffsetiPad :      \
__x__)

#define ADJUST_Y(__y__) (IS_IPAD() == YES ? ( __y__ * 2 ) + kYoffsetiPad : __y__)

#define ADJUST_DOUBLE(__x__) (IS_IPAD() == YES ? ( __x__ * 2 )  : __x__)
#define ADJUST_DOUBLE_XY(__x__,__y__) (IS_IPAD() == YES? ccp( ( __x__ * 2 ) , ( __y__ * 2 ) ) : \
ccp(__x__, __y__))

#define ADJUST_DOUBLE_WITH_IPAD_TRIMMING(__x__) (IS_IPAD() == YES ? ( (__x__ -kYoffsetiPad)* 2 )  : __x__)

//Points
#define PT1  (IS_IPAD() == YES && IS_RETINA() == YES ? ADJUST_XY(43,247):ADJUST_XY(45,246))
#define PT2  (IS_IPAD() == YES && IS_RETINA() == YES ? ADJUST_XY(100,283):ADJUST_XY(102,287)) 
#define PT3  (IS_IPAD() == YES && IS_RETINA() == YES ? ADJUST_XY(160,320):ADJUST_XY(160,328)) 

#define PT4  (IS_IPAD() == YES && IS_RETINA() == YES ? ADJUST_XY(100,210):ADJUST_XY(102,206)) 
#define PT5  (IS_IPAD() == YES && IS_RETINA() == YES ? ADJUST_XY(160,247):ADJUST_XY(160,246))
#define PT6  (IS_IPAD() == YES && IS_RETINA() == YES ? ADJUST_XY(220,283):ADJUST_XY(218,287))

#define PT7  (IS_IPAD() == YES && IS_RETINA() == YES ? ADJUST_XY(160,175):ADJUST_XY(160,165)) 
#define PT8  (IS_IPAD() == YES && IS_RETINA() == YES ? ADJUST_XY(220,210):ADJUST_XY(218,206)) 
#define PT9  (IS_IPAD() == YES && IS_RETINA() == YES ? ADJUST_XY(282,247):ADJUST_XY(276,246)) 

#define RIGHT_STAGE_POS  (IS_IPAD() == YES && IS_RETINA() == YES ? ADJUST_XY(283,163):ADJUST_XY(283,157))
#define LEFT_STAGE_POS  (IS_IPAD() == YES && IS_RETINA() == YES ? ADJUST_XY( (kScreenWidth- 283),163):ADJUST_XY( (kScreenWidth- 283),157))

#define SCREEN_SCALE (IS_IPAD() == YES ?1:0.833)

#define CELL_WIDTH ADJUST_DOUBLE((71*SCREEN_SCALE))//ADJUST_DOUBLE((58*SCREEN_SCALE))
#define CELL_HEIGHT ADJUST_DOUBLE((63*SCREEN_SCALE))//ADJUST_DOUBLE((42*SCREEN_SCALE))

//Rects
#define RECT1 CGRectMake(PT1.x-(CELL_WIDTH/2.0f),PT1.y-(CELL_HEIGHT/2.0f),CELL_WIDTH,CELL_HEIGHT)
#define RECT2 CGRectMake(PT2.x-(CELL_WIDTH/2.0f),PT2.y-(CELL_HEIGHT/2.0f),CELL_WIDTH,CELL_HEIGHT)
#define RECT3 CGRectMake(PT3.x-(CELL_WIDTH/2.0f),PT3.y-(CELL_HEIGHT/2.0f),CELL_WIDTH,CELL_HEIGHT)
#define RECT4 CGRectMake(PT4.x-(CELL_WIDTH/2.0f),PT4.y-(CELL_HEIGHT/2.0f),CELL_WIDTH,CELL_HEIGHT)
#define RECT5 CGRectMake(PT5.x-(CELL_WIDTH/2.0f),PT5.y-(CELL_HEIGHT/2.0f),CELL_WIDTH,CELL_HEIGHT)
#define RECT6 CGRectMake(PT6.x-(CELL_WIDTH/2.0f),PT6.y-(CELL_HEIGHT/2.0f),CELL_WIDTH,CELL_HEIGHT)
#define RECT7 CGRectMake(PT7.x-(CELL_WIDTH/2.0f),PT7.y-(CELL_HEIGHT/2.0f),CELL_WIDTH,CELL_HEIGHT)
#define RECT8 CGRectMake(PT8.x-(CELL_WIDTH/2.0f),PT8.y-(CELL_HEIGHT/2.0f),CELL_WIDTH,CELL_HEIGHT)
#define RECT9 CGRectMake(PT9.x-(CELL_WIDTH/2.0f),PT9.y-(CELL_HEIGHT/2.0f),CELL_WIDTH,CELL_HEIGHT)

#define RIGHT_STAGE_RECT CGRectMake(RIGHT_STAGE_POS.x-(CELL_WIDTH/2.0f),RIGHT_STAGE_POS.y-(CELL_HEIGHT/2.0f),CELL_WIDTH,CELL_HEIGHT)

#define LEFT_STAGE_RECT CGRectMake(LEFT_STAGE_POS.x-(CELL_WIDTH/2.0f),LEFT_STAGE_POS.y-(CELL_HEIGHT/2.0f),CELL_WIDTH,CELL_HEIGHT)

#define PIECES_Y_OFFSET 13
#define PIECES_X_OFFSET 17


//Local player pieces:
#define RIGHT_PIECES_STONE_1_POS ADJUST_XY(254,29)
#define RIGHT_PIECES_STONE_2_POS ADJUST_XY((254+PIECES_X_OFFSET),(29-PIECES_Y_OFFSET))
#define RIGHT_PIECES_STONE_3_POS ADJUST_XY((254+PIECES_X_OFFSET*2),(29-PIECES_Y_OFFSET*2))

#define RIGHT_PIECES_PAPER_1_POS ADJUST_XY(276,44)
#define RIGHT_PIECES_PAPER_2_POS ADJUST_XY((276+PIECES_X_OFFSET),(44-PIECES_Y_OFFSET))
#define RIGHT_PIECES_PAPER_3_POS ADJUST_XY((276+PIECES_X_OFFSET*2),(44-PIECES_Y_OFFSET*2))


#define RIGHT_PIECES_SCISSOR_1_POS ADJUST_XY(298,59)
#define RIGHT_PIECES_SCISSOR_2_POS ADJUST_XY((298+PIECES_X_OFFSET),(59-PIECES_Y_OFFSET))
#define RIGHT_PIECES_SCISSOR_3_POS ADJUST_XY(320,74)

//Opponent pieces:
#define LEFT_PIECES_STONE_1_POS ADJUST_XY((kScreenWidth-254),29)
#define LEFT_PIECES_STONE_2_POS ADJUST_XY((kScreenWidth-(254+PIECES_X_OFFSET)),(29-PIECES_Y_OFFSET))
#define LEFT_PIECES_STONE_3_POS ADJUST_XY((kScreenWidth-(254+PIECES_X_OFFSET*2)),(29-PIECES_Y_OFFSET*2))

#define LEFT_PIECES_PAPER_1_POS ADJUST_XY((kScreenWidth-276),44)
#define LEFT_PIECES_PAPER_2_POS ADJUST_XY((kScreenWidth-(276+PIECES_X_OFFSET)),(44-PIECES_Y_OFFSET))
#define LEFT_PIECES_PAPER_3_POS ADJUST_XY((kScreenWidth-(276+PIECES_X_OFFSET*2)),(44-PIECES_Y_OFFSET*2))

#define LEFT_PIECES_SCISSOR_1_POS ADJUST_XY((kScreenWidth-298),59)
#define LEFT_PIECES_SCISSOR_2_POS ADJUST_XY((kScreenWidth-(298+PIECES_X_OFFSET)),(59-PIECES_Y_OFFSET))
#define LEFT_PIECES_SCISSOR_3_POS ADJUST_XY((kScreenWidth-320),74)//((298+PIECES_X_OFFSET*2),(59-PIECES_Y_OFFSET*2))


#define kWAITING_MAX_TIME 31


//Options Scene:
#define kSETTING_BACKGROUND_THEME_KEY @"BackgroundTheme"
#define kSETTING_PIECE_MODEL_KEY @"PieceModel"
#define kSETTING_GOLDEN_TEAM_LOCKED @"GoldenTeamLocked"
#define kSETTING_PLAYER_WINS @"PlayerWins"
#define kSETTING_PLIST_FILE_NAME @"settings"

#define KNUMBER_OF_WINNING_TIMES @"number_of_winning_times"

#define FOREST_RECT  (  IS_IPAD() == YES && IS_RETINA() == YES ? CGRectMake(forestSprite.position.x-forestSprite.contentSize.width,forestSprite.position.y-forestSprite.contentSize.height, forestSprite.contentSize.width*2, forestSprite.contentSize.height*2)  :  CGRectMake(forestSprite.position.x-forestSprite.contentSize.width*0.5,forestSprite.position.y-forestSprite.contentSize.height*0.5 , forestSprite.contentSize.width, forestSprite.contentSize.height)  )

#define EGYPT_RECT (  IS_IPAD() == YES && IS_RETINA() == YES ? CGRectMake(egyptSprite.position.x-egyptSprite.contentSize.width,egyptSprite.position.y-egyptSprite.contentSize.height, egyptSprite.contentSize.width * 2, egyptSprite.contentSize.height * 2)  :  CGRectMake(egyptSprite.position.x-egyptSprite.contentSize.width*0.5,egyptSprite.position.y-egyptSprite.contentSize.height*0.5 , egyptSprite.contentSize.width, egyptSprite.contentSize.height)  )

#define KINGDOM_RECT (  IS_IPAD() == YES && IS_RETINA() == YES ? CGRectMake(kingdomSprite.position.x-kingdomSprite.contentSize.width,kingdomSprite.position.y-kingdomSprite.contentSize.height, kingdomSprite.contentSize.width * 2, kingdomSprite.contentSize.height * 2)  :  CGRectMake(kingdomSprite.position.x-kingdomSprite.contentSize.width*0.5,kingdomSprite.position.y-kingdomSprite.contentSize.height*0.5 , kingdomSprite.contentSize.width, kingdomSprite.contentSize.height)  )

#define HERO_TEAM_RECT (  IS_IPAD() == YES && IS_RETINA() == YES ? CGRectMake(heroTeamSprite.position.x-heroTeamSprite.contentSize.width,heroTeamSprite.position.y-heroTeamSprite.contentSize.height+25, heroTeamSprite.contentSize.width * 2, heroTeamSprite.contentSize.height * 2 - 50)  :  CGRectMake(heroTeamSprite.position.x-heroTeamSprite.contentSize.width*0.5,heroTeamSprite.position.y-heroTeamSprite.contentSize.height*0.5 + 25, heroTeamSprite.contentSize.width, heroTeamSprite.contentSize.height)  )

#define VILLAN_TEAM_RECT (  IS_IPAD() == YES && IS_RETINA() == YES ? CGRectMake(villainTeamSprite.position.x-villainTeamSprite.contentSize.width,villainTeamSprite.position.y-villainTeamSprite.contentSize.height + 25, villainTeamSprite.contentSize.width * 2, villainTeamSprite.contentSize.height * 2 - 50)  :  CGRectMake(villainTeamSprite.position.x-villainTeamSprite.contentSize.width*0.5,villainTeamSprite.position.y-villainTeamSprite.contentSize.height*0.5 + 25, villainTeamSprite.contentSize.width, villainTeamSprite.contentSize.height)  )

#define GOLDEN_TEAM_RECT (  IS_IPAD() == YES && IS_RETINA() == YES ? CGRectMake(goldenTeamSprite.position.x-goldenTeamSprite.contentSize.width,goldenTeamSprite.position.y-goldenTeamSprite.contentSize.height + 25, goldenTeamSprite.contentSize.width * 2, goldenTeamSprite.contentSize.height * 2 - 50)  :  CGRectMake(goldenTeamSprite.position.x-goldenTeamSprite.contentSize.width*0.5,goldenTeamSprite.position.y-goldenTeamSprite.contentSize.height*0.5 + 25, goldenTeamSprite.contentSize.width, goldenTeamSprite.contentSize.height)  )

#define REMOVE_ADS_RECT (  IS_IPAD() == YES && IS_RETINA() == YES ? CGRectMake(ADJUST_DOUBLE(12*SCREEN_SCALE), ADJUST_DOUBLE_WITH_IPAD_TRIMMING(115*SCREEN_SCALE), ADJUST_DOUBLE(84*SCREEN_SCALE), ADJUST_DOUBLE(35*SCREEN_SCALE))  :  CGRectMake(ADJUST_DOUBLE(12*SCREEN_SCALE), ADJUST_DOUBLE_WITH_IPAD_TRIMMING(90*SCREEN_SCALE), ADJUST_DOUBLE(84*SCREEN_SCALE), ADJUST_DOUBLE(42*SCREEN_SCALE))  )

#define NEWS_RECT (  IS_IPAD() == YES && IS_RETINA() == YES ? CGRectMake(ADJUST_DOUBLE(12*SCREEN_SCALE), ADJUST_DOUBLE_WITH_IPAD_TRIMMING(70*SCREEN_SCALE), ADJUST_DOUBLE(84*SCREEN_SCALE), ADJUST_DOUBLE(40*SCREEN_SCALE))  :  CGRectMake(ADJUST_DOUBLE(12*SCREEN_SCALE), ADJUST_DOUBLE_WITH_IPAD_TRIMMING(44*SCREEN_SCALE), ADJUST_DOUBLE(84*SCREEN_SCALE), ADJUST_DOUBLE(42*SCREEN_SCALE))  )

#define ABOUT_RECT (  IS_IPAD() == YES && IS_RETINA() == YES ? CGRectMake(ADJUST_DOUBLE (150*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(70*SCREEN_SCALE), ADJUST_DOUBLE(90*SCREEN_SCALE),ADJUST_DOUBLE(40*SCREEN_SCALE))  :  CGRectMake(ADJUST_DOUBLE (150*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(45*SCREEN_SCALE), ADJUST_DOUBLE(90*SCREEN_SCALE),ADJUST_DOUBLE(44*SCREEN_SCALE))  )

#define RESTORE_RECT (  IS_IPAD() == YES && IS_RETINA() == YES ? CGRectMake(ADJUST_DOUBLE(150*SCREEN_SCALE), ADJUST_DOUBLE_WITH_IPAD_TRIMMING(110*SCREEN_SCALE), ADJUST_DOUBLE(90*SCREEN_SCALE), ADJUST_DOUBLE(44*SCREEN_SCALE))  :  CGRectMake(ADJUST_DOUBLE(150*SCREEN_SCALE), ADJUST_DOUBLE_WITH_IPAD_TRIMMING(90*SCREEN_SCALE), ADJUST_DOUBLE(90*SCREEN_SCALE), ADJUST_DOUBLE(44*SCREEN_SCALE))  )

#define CANCEL_RECT (  IS_IPAD() == YES && IS_RETINA() == YES ? CGRectMake(ADJUST_DOUBLE (130*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(80*SCREEN_SCALE), ADJUST_DOUBLE(130*SCREEN_SCALE),ADJUST_DOUBLE(40*SCREEN_SCALE))  :  CGRectMake(ADJUST_DOUBLE (150*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(50*SCREEN_SCALE), ADJUST_DOUBLE(90*SCREEN_SCALE),ADJUST_DOUBLE(40*SCREEN_SCALE))  )


//Main Menu Scene:
#define kMULTI_PLAYER_BTN_RECT  (  IS_IPAD() == YES && IS_RETINA() == YES ? CGRectMake(ADJUST_DOUBLE(102*SCREEN_SCALE), ADJUST_DOUBLE_WITH_IPAD_TRIMMING(250*SCREEN_SCALE), ADJUST_DOUBLE(179*SCREEN_SCALE), ADJUST_DOUBLE(45*SCREEN_SCALE))  :  CGRectMake(ADJUST_DOUBLE(102*SCREEN_SCALE), ADJUST_DOUBLE_WITH_IPAD_TRIMMING(247*SCREEN_SCALE), ADJUST_DOUBLE(179*SCREEN_SCALE), ADJUST_DOUBLE(45*SCREEN_SCALE))  )

#define kSINGLE_PLAYER_BTN_RECT  (  IS_IPAD() == YES && IS_RETINA() == YES ? CGRectMake(ADJUST_DOUBLE(102*SCREEN_SCALE), ADJUST_DOUBLE_WITH_IPAD_TRIMMING(205*SCREEN_SCALE), ADJUST_DOUBLE(179*SCREEN_SCALE), ADJUST_DOUBLE(45*SCREEN_SCALE))  :  CGRectMake(ADJUST_DOUBLE(102*SCREEN_SCALE), ADJUST_DOUBLE_WITH_IPAD_TRIMMING(198*SCREEN_SCALE), ADJUST_DOUBLE(179*SCREEN_SCALE), ADJUST_DOUBLE(45*SCREEN_SCALE))  )

#define kOPTIONS_BTN_RECT   (  IS_IPAD() == YES && IS_RETINA() == YES ? CGRectMake(ADJUST_DOUBLE(102*SCREEN_SCALE), ADJUST_DOUBLE_WITH_IPAD_TRIMMING(159*SCREEN_SCALE), ADJUST_DOUBLE(179*SCREEN_SCALE), ADJUST_DOUBLE(45*SCREEN_SCALE))  :  CGRectMake(ADJUST_DOUBLE(102*SCREEN_SCALE), ADJUST_DOUBLE_WITH_IPAD_TRIMMING(151*SCREEN_SCALE), ADJUST_DOUBLE(179*SCREEN_SCALE), ADJUST_DOUBLE(45*SCREEN_SCALE))  )

#define kSTATS_BTN_RECT  (  IS_IPAD() == YES && IS_RETINA() == YES ? CGRectMake(ADJUST_DOUBLE(102*SCREEN_SCALE), ADJUST_DOUBLE_WITH_IPAD_TRIMMING(120*SCREEN_SCALE), ADJUST_DOUBLE(179*SCREEN_SCALE), ADJUST_DOUBLE(45*SCREEN_SCALE))  :  CGRectMake(ADJUST_DOUBLE(102*SCREEN_SCALE), ADJUST_DOUBLE_WITH_IPAD_TRIMMING(102*SCREEN_SCALE), ADJUST_DOUBLE(179*SCREEN_SCALE), ADJUST_DOUBLE(45*SCREEN_SCALE))  )

#define kMORE_GAMES_BTN_RECT  (  IS_IPAD() == YES && IS_RETINA() == YES ? CGRectMake(ADJUST_DOUBLE(102*SCREEN_SCALE), ADJUST_DOUBLE_WITH_IPAD_TRIMMING(75*SCREEN_SCALE), ADJUST_DOUBLE(179*SCREEN_SCALE), ADJUST_DOUBLE(45*SCREEN_SCALE))  :  CGRectMake(ADJUST_DOUBLE(102*SCREEN_SCALE), ADJUST_DOUBLE_WITH_IPAD_TRIMMING(53*SCREEN_SCALE), ADJUST_DOUBLE(179*SCREEN_SCALE), ADJUST_DOUBLE(45*SCREEN_SCALE))  )


#define EASY_RECT CGRectMake(ADJUST_DOUBLE(50*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(230*SCREEN_SCALE) , ADJUST_DOUBLE(80*SCREEN_SCALE), ADJUST_DOUBLE(174*SCREEN_SCALE))

#define MEDIUM_RECT CGRectMake(ADJUST_DOUBLE(150*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(230*SCREEN_SCALE)  , ADJUST_DOUBLE(80*SCREEN_SCALE), ADJUST_DOUBLE(174*SCREEN_SCALE))

#define HARD_RECT CGRectMake(ADJUST_DOUBLE(255*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(230*SCREEN_SCALE), ADJUST_DOUBLE(80*SCREEN_SCALE), ADJUST_DOUBLE(174*SCREEN_SCALE))

#define BACK_RECT (  IS_IPAD() == YES && IS_RETINA() == YES ? CGRectMake(ADJUST_DOUBLE(146*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(190*SCREEN_SCALE), ADJUST_DOUBLE(84*SCREEN_SCALE), ADJUST_DOUBLE(35*SCREEN_SCALE))  :  CGRectMake(ADJUST_DOUBLE(146*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(170*SCREEN_SCALE), ADJUST_DOUBLE(84*SCREEN_SCALE), ADJUST_DOUBLE(44*SCREEN_SCALE))  )


#define kMULTI_PLAYER_BTN_POS  (IS_IPAD() == YES && IS_RETINA() == YES ? ADJUST_XY(160,227) : ADJUST_XY(160,224))
#define kSINGLE_PLAYER_BTN_POS  (IS_IPAD() == YES && IS_RETINA() == YES ? ADJUST_XY(160,185) : ADJUST_XY(160,176)) 
#define kOPTIONS_BTN_POS  (IS_IPAD() == YES && IS_RETINA() == YES ? ADJUST_XY(160,140) : ADJUST_XY(160,129))
#define kSTATS_BTN_POS  (IS_IPAD() == YES && IS_RETINA() == YES ? ADJUST_XY(160,97) : ADJUST_XY(160,81))
#define kMORE_GAMES_BTN_POS  (IS_IPAD() == YES && IS_RETINA() == YES ? ADJUST_XY(160,55) : ADJUST_XY(160,32))

#define kBLUR_BACKGROUND_TAG 90

#define kCOMPUTER_TURN_DELAY 1.5

#define kOPTIONS_SCENE_OK_BUTTON_RECT (  IS_IPAD() == YES && IS_RETINA() == YES ? CGRectMake(ADJUST_DOUBLE (292*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(60*SCREEN_SCALE), ADJUST_DOUBLE(82*SCREEN_SCALE),ADJUST_DOUBLE(40*SCREEN_SCALE))  :  CGRectMake(ADJUST_DOUBLE (292*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(45*SCREEN_SCALE), ADJUST_DOUBLE(82*SCREEN_SCALE),ADJUST_DOUBLE(44*SCREEN_SCALE))  )

#define kALERT_BACK_BUTTON_RECT CGRectMake(ADJUST_DOUBLE (54*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING (228*SCREEN_SCALE), ADJUST_DOUBLE(129*SCREEN_SCALE),ADJUST_DOUBLE(43*SCREEN_SCALE))

#define kALERT_UNLOCK_BUTTON_RECT CGRectMake(ADJUST_DOUBLE (202*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING (228*SCREEN_SCALE), ADJUST_DOUBLE(129*SCREEN_SCALE),ADJUST_DOUBLE(43*SCREEN_SCALE))



//Rate view:
#define DONE_RECT (  IS_IPAD() == YES && IS_RETINA() == YES ? CGRectMake(ADJUST_DOUBLE(22*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(410*SCREEN_SCALE) , ADJUST_DOUBLE(57*SCREEN_SCALE), ADJUST_DOUBLE(27*SCREEN_SCALE))  :  CGRectMake(ADJUST_DOUBLE(22*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(426*SCREEN_SCALE) , ADJUST_DOUBLE(57*SCREEN_SCALE), ADJUST_DOUBLE(31*SCREEN_SCALE))  )

#define RATE_RECT (  IS_IPAD() == YES && IS_RETINA() == YES ? CGRectMake(ADJUST_DOUBLE(76*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(309*SCREEN_SCALE)  , ADJUST_DOUBLE(240*SCREEN_SCALE), ADJUST_DOUBLE(43*SCREEN_SCALE))  :  CGRectMake(ADJUST_DOUBLE(76*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(309*SCREEN_SCALE)  , ADJUST_DOUBLE(240*SCREEN_SCALE), ADJUST_DOUBLE(43*SCREEN_SCALE))  )

#define PROBLEM_RECT (  IS_IPAD() == YES && IS_RETINA() == YES ? CGRectMake(ADJUST_DOUBLE(76*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(259*SCREEN_SCALE)  , ADJUST_DOUBLE(240*SCREEN_SCALE), ADJUST_DOUBLE(43*SCREEN_SCALE))  :  CGRectMake(ADJUST_DOUBLE(76*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(259*SCREEN_SCALE)  , ADJUST_DOUBLE(240*SCREEN_SCALE), ADJUST_DOUBLE(43*SCREEN_SCALE))  )



//Push notification
#define NO_THANKS_RECT (  IS_IPAD() == YES && IS_RETINA() == YES ? CGRectMake(ADJUST_DOUBLE(52*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(264*SCREEN_SCALE) , ADJUST_DOUBLE(92*SCREEN_SCALE), ADJUST_DOUBLE(34*SCREEN_SCALE))  :  CGRectMake(ADJUST_DOUBLE(52*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(264*SCREEN_SCALE) , ADJUST_DOUBLE(92*SCREEN_SCALE), ADJUST_DOUBLE(34*SCREEN_SCALE))  )

#define OK_RECT (  IS_IPAD() == YES && IS_RETINA() == YES ? CGRectMake(ADJUST_DOUBLE(200*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(258*SCREEN_SCALE)  , ADJUST_DOUBLE(130*SCREEN_SCALE), ADJUST_DOUBLE(44*SCREEN_SCALE))  :  CGRectMake(ADJUST_DOUBLE(200*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(258*SCREEN_SCALE)  , ADJUST_DOUBLE(130*SCREEN_SCALE), ADJUST_DOUBLE(44*SCREEN_SCALE))  )



//statistics:
#define kSTATS_SINGLE_HARD_WIN @"kSTATS_SINGLE_HARD_WIN"
#define kSTATS_SINGLE_HARD_LOSE @"kSTATS_SINGLE_HARD_LOSE"
#define kSTATS_SINGLE_HARD_TOTAL @"kSTATS_SINGLE_HARD_TOTAL"

#define kSTATS_SINGLE_MEDIUM_WIN @"kSTATS_MEDIUM_HARD_WIN"
#define kSTATS_SINGLE_MEDIUM_LOSE @"kSTATS_MEDIUM_HARD_LOSE"
#define kSTATS_SINGLE_MEDIUM_TOTAL @"kSTATS_MEDIUM_HARD_TOTAL"

#define kSTATS_SINGLE_EASY_WIN @"kSTATS_EASY_HARD_WIN"
#define kSTATS_SINGLE_EASY_LOSE @"kSTATS_EASY_HARD_LOSE"
#define kSTATS_SINGLE_EASY_TOTAL @"kSTATS_EASY_HARD_TOTAL"

#define kSTATS_MULTIPLAYER_WIN @"kSTATS_MULTIPLAYER_WIN"
#define kSTATS_MULTIPLAYER_LOSE @"kSTATS_MULTIPLAYER_LOSE"
#define kSTATS_MULTIPLAYER_TOTAL @"kSTATS_MULTIPLAYER_TOTAL"

#define FACEBOOK_RECT (  IS_IPAD() == YES && IS_RETINA() == YES ? CGRectMake(ADJUST_DOUBLE (170*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(70*SCREEN_SCALE), ADJUST_DOUBLE(30*SCREEN_SCALE),ADJUST_DOUBLE(40*SCREEN_SCALE))  :  CGRectMake(ADJUST_DOUBLE (170*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(45*SCREEN_SCALE), ADJUST_DOUBLE(30*SCREEN_SCALE),ADJUST_DOUBLE(40*SCREEN_SCALE))  )

#define TWITTER_RECT (  IS_IPAD() == YES && IS_RETINA() == YES ? CGRectMake(ADJUST_DOUBLE (200*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(70*SCREEN_SCALE), ADJUST_DOUBLE(30*SCREEN_SCALE),ADJUST_DOUBLE(40*SCREEN_SCALE))  :  CGRectMake(ADJUST_DOUBLE (200*SCREEN_SCALE),ADJUST_DOUBLE_WITH_IPAD_TRIMMING(45*SCREEN_SCALE), ADJUST_DOUBLE(30*SCREEN_SCALE),ADJUST_DOUBLE(40*SCREEN_SCALE))  )


#define kAPP_DELEGATE ((AppDelegate*)([UIApplication sharedApplication].delegate))
#define kAPP_RUN_BEFORE_KEY @"App_Run_Before"
#define kNEWS_LINK @"http://www.stariosgames.com/resources/rockatac/news.html"


//Leaderboards:
//#ifdef ARABIC_VERSION
//
//#define kLEADERBOARD_CATEGORY_EASY @"rockatac.easy"
//#define kLEADERBOARD_CATEGORY_MEDIUM @"rockatac.medium"
//#define kLEADERBOARD_CATEGORY_HARD @"rockatac.hard"
//#define kLEADERBOARD_CATEGORY_MULTIPLAYER @"rockatac.multiplayer"
//#define kLEADERBOARD_CATEGORY_COMBINED @"rockatac.highscore"
//
//#else

#define kLEADERBOARD_CATEGORY_EASY @"grp.rockatac.easymode"
#define kLEADERBOARD_CATEGORY_MEDIUM @"grp.rockatac.mediummode"
#define kLEADERBOARD_CATEGORY_HARD @"grp.rockatac.hardmode"
#define kLEADERBOARD_CATEGORY_MULTIPLAYER @"grp.rockatac.multiplayermode"
#define kLEADERBOARD_CATEGORY_COMBINED @"rockatac.highscoremode"

//#endif

//facebook & twitter configuration

#define kFACEBOOK_APP_ID @"323945090998356"
#define kFACEBOOK_APP_SECRET @"7cf09ff6912746ea09441c09e173266f" //Not used


//user defaults keys
#define kBANNER_AD_ENABLED_KEY @"banner_ad_enabled"

#define kTAPJOY_MORE_SCREEN_ENABLED_KEY @"tapjoyMoreScreenEnabled"

#define kCEREBRO_MORE_SCREEN_KEY @"cerebroMoreScreen"

#define kREMOVE_RESTORE_BUTTON @"RestoreButton"
