//
//  AboutScene.h
//  Roc-a-Tac
//
//  Created by lognlabs on 8/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "GameConfig.h"

#import "Controller.h"

@interface AboutScene : CCLayer {
    CCSprite* buttonSelector;
    
    Controller* gameController;
}
+(CCScene *) scene;
@end
