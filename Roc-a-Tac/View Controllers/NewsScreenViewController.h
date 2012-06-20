//
//  NagScreenViewController.h
//  MultiMatch_the_game
//
//  Created by Nik Rudenko on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewsScreenViewController : UIViewController <UIWebViewDelegate> {

    IBOutlet UIWebView* webView;
    IBOutlet UIActivityIndicatorView *activity;
    IBOutlet UIView* loading;
    NSString *link;
    
}

@property (nonatomic, retain) NSString *link;

-(IBAction)close;

@end
