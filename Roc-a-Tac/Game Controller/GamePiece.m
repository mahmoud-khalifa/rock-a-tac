//
//  GamePiece.m
//  Roc-a-Tac
//
//  Created by Log n Labs on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GamePiece.h"

@implementation GamePiece

@synthesize theme;
@synthesize type;
@synthesize model;
@synthesize animationName;
@synthesize direction;
@synthesize imageName;
@synthesize tag;

-(id)initWithPiece:(GamePiece*)piece{

    if ((self=[super init])) {
        theme=piece.theme;
        type=piece.type;
        model=piece.model;
        animationName=piece.animationName;
        direction=piece.direction;
        if (piece.imageName!=nil) {
             imageName=[[NSString alloc]initWithString:piece.imageName];
        }
        tag=0;
    }
    return self;
}
-(id)init{
    
    if ((self=[super init])) {
       
    }
    return self;
}

@end
