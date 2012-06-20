//
//  NagScreenViewController.h
//  MultiMatch_the_game
//
//  Created by Nik Rudenko on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NagScreenViewController : UIViewController <UIWebViewDelegate> {

    IBOutlet UIActivityIndicatorView *activity;
    IBOutlet UIView* loading;
    IBOutlet UIButton *button;
    NSString *link;
    BOOL isHTML;
    
    IBOutlet UIImageView*    imageView;
    
    id closeTarget;
    SEL closeSelector;

}

@property (nonatomic, retain) NSString *link;

- (IBAction)close;
-(void)setResource:(NSString*)resource isHTML:(BOOL)_isHTML;
-(void)addTarget:(id)target selector:(SEL)selector;

@end
