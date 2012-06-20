//
//  BoardObject.h
//  Roc-a-Tac
//
//  Created by Log n Labs on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GamePiece.h"
typedef enum
{
    PlayerTypeNone=-1,
    PlayerTypeLocalPlayer,
    PlayerTypeOpponent,
    PlayerTypeMax,
    
} PlayerTypes;

@interface BoardObject : NSObject{
    PiecesTypes pieceType;
    PlayerTypes playerType;
}

@property PiecesTypes pieceType;
@property PlayerTypes playerType;
@end
