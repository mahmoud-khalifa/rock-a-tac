//
//  CCAnimationHelper.h
//  SpriteBatches
//
//  Created by Steffen Itterheim on 06.08.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCAnimation (Helper)

+(CCAnimation*) animationWithFrame:(NSString*)frame frameCount:(int)frameCount delay:(float)delay startFrom:(int)start;

@end
