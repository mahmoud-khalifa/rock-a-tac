//
//  BoardObject.m
//  Roc-a-Tac
//
//  Created by Log n Labs on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BoardObject.h"

@implementation BoardObject
@synthesize pieceType;
@synthesize playerType;

-(id)init{

    self=[super init];
    if (self) {
        self.pieceType=PiecesTypeNone;
        self.playerType=PlayerTypeNone;
    }
    return self;
    
}
@end
