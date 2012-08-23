//
//  OptionsScene.h
//  TicTacToe
//
//  Created by Log n Labs on 1/31/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"
#import "GameConfig.h"

#import "Controller.h"

@interface OptionsScene : CCLayer <ControllerProtocol>{
    CCSprite* forestSprite;
    CCSprite* egyptSprite;
    CCSprite* kingdomSprite;
    
    CCSprite* heroTeamSprite;
    CCSprite* villainTeamSprite;
    CCSprite* goldenTeamSprite;
    
    
    PiecesThemes pieceTheme;
    BackgroundThemes bgTheme;
    
    NSMutableDictionary * settingDict;
    
    CCSprite* lockSprite;
    
    CCSprite* alertSprite;
    CCSprite* btnSelector;
    
    CCSpriteFrameCache*frameCache;
    
    CCSprite* removeAds;
    CCSprite* news;
    
    CCSprite* buttonSelector;
    
    Controller* gameController;
}
+(CCScene *) scene;
@end
