//
//  GamePiece.h
//  Roc-a-Tac
//
//  Created by Log n Labs on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    PiecesThemeA,
    PiecesThemeB,
    PiecesThemeC,
    
}PiecesThemes;

typedef enum
{
    PiecesTypeNone=-1,
    PiecesTypeStone,
    PiecesTypeScissor,
    PiecesTypePaper,
    PiecesTypesMAX,
}PiecesTypes;

typedef enum
{
    PiecesModelGood,
    PiecesModelDevil,
    PiecesModelGold
    
}PiecesModels;

typedef enum
{
    PiecesAnimationNameStatic,
    PiecesAnimationNameBringToLife,
    PiecesAnimationNameIdle,
    PiecesAnimationNameVictory
    
}PiecesAnimationNames;

typedef enum
{
    PiecesDirectionRight=1,
    PiecesDirectionCenter,
    PiecesDirectionLeft,
    
    
}PiecesDirections;

@interface GamePiece : NSObject{
    PiecesThemes theme;
    PiecesTypes type;
    PiecesModels model;
    PiecesAnimationNames animationName;
    PiecesDirections direction;
    NSString* imageName;
    
    int tag;
}
@property PiecesThemes theme;
@property PiecesTypes type;
@property PiecesModels model;
@property PiecesAnimationNames animationName;
@property PiecesDirections direction;
@property (retain,nonatomic) NSString* imageName;

@property int tag;
-(id)initWithPiece:(GamePiece*)piece;
@end
