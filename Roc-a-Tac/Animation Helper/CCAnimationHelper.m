//
//  CCAnimationHelper.m
//  SpriteBatches
//
//  Created by Steffen Itterheim on 06.08.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "CCAnimationHelper.h"

@implementation CCAnimation (Helper)

// Creates an animation from sprite frames.
+(CCAnimation*) animationWithFrame:(NSString*)frame frameCount:(int)frameCount delay:(float)delay startFrom:(int)start
{
    
	// load the ship's animation frames as textures and create a sprite frame
	NSMutableArray* frames = [NSMutableArray arrayWithCapacity:frameCount];
	for (int i = 0+start; i < (2*frameCount)+start; i+=2)
	{
		NSString* file = [NSString stringWithFormat:@"%@.%02d.png", frame, i];
		CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
		CCSpriteFrame* frame = [frameCache spriteFrameByName:file];
		[frames addObject:frame];
	}
	
	// return an animation object from all the sprite animation frames
    return [CCAnimation animationWithFrames:frames delay:delay];
}



@end
