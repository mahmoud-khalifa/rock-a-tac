//
//  RootViewController.h
//  TicTacToe
//
//  Created by Log n Labs on 1/31/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

//#ifdef LITE_VERSION
#import "TapjoyConnect.h"
//#endif
@interface RootViewController : UIViewController
//#ifdef LITE_VERSION
<TJCAdDelegate> 
//#endif
{
    CGRect adFrame;
//#ifdef LITE_VERSION
    TJCAdView* theAdView;
//#endif
    
//    UIView*imageView;
}

//@property(retain,nonatomic) UIView*imageView;

+(RootViewController*) sharedRootViewController;
//#ifdef LITE_VERSION
-(void)setAdViewFrameAtBottom:(BOOL)inBottom;
-(void)hideAd;
//#endif
@end
