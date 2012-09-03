//
//  ShareClass.m
//  TextTwistGame
//
//  Created by Log n Labs on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShareClass.h"
#import "AppDelegate.h"
#import "FBConnect.h"


#import <Accounts/Accounts.h>

#import "FBViewController.h"

#import "GameConfig.h"


@implementation ShareClass

+(void)tweet{
    NSString *finalMsg=[NSLocalizedString(@"Definitely a unique twist on tic tac toe and rock paper scissors... I like it! :", @"Definitely a unique twist on tic tac toe and rock paper scissors... I like it! :")  stringByAppendingString:kSHORT_APP_URL];
    
    NSLog(@"string size %d",[finalMsg length]);
           
    if (NSClassFromString(@"TWTweetComposeViewController")) {
        if([TWTweetComposeViewController canSendTweet]) {
            
            TWTweetComposeViewController *controller = [[TWTweetComposeViewController alloc] init];
            
            [controller setInitialText:finalMsg];
            //[controller addURL:[NSURL URLWithString:@"http://bit.ly/vJGj42"]];
            
            [controller addImage:[UIImage imageNamed:@"Icon-Small.png"]];
            
            controller.completionHandler = ^(TWTweetComposeViewControllerResult result)  {
                
                [kAPP_DELEGATE.window.rootViewController dismissModalViewControllerAnimated:YES];
                UIAlertView* alert;
                switch (result) {
                    case TWTweetComposeViewControllerResultCancelled: 
//                        alert=[[UIAlertView alloc ]initWithTitle:@"Cancelled" message:@"Action Cancelled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                        [alert show];
//                        [alert release];
                        break;
                        
                    case TWTweetComposeViewControllerResultDone:
                        alert=[[UIAlertView alloc ]initWithTitle:NSLocalizedString(@"Success", @"Success")  message:NSLocalizedString(@"Your Tweet was sent successfully", @"Your Tweet was sent successfully") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles: nil];
                        [alert show];
                        [alert release];
//                        
//                        [StatisticsCollector logEvent:@"Post On Twitter"];
                        break;
                        
                    default:
                        break;
                }
            };
            
            [kAPP_DELEGATE.window.rootViewController presentModalViewController:controller animated:YES];
            
        }else{
            
            TwitterRushViewController* twitterController=[[TwitterRushViewController alloc]initWithMessage:finalMsg];
            [kAPP_DELEGATE.window.rootViewController presentModalViewController:twitterController animated:YES];
            [twitterController release];
            
        }
    }else{

        TwitterRushViewController* twitterController=[[TwitterRushViewController alloc]initWithMessage:finalMsg];
        [kAPP_DELEGATE.window.rootViewController presentModalViewController:twitterController animated:YES];
        [twitterController release];
    }
 
}
+(void) shareOnFacebook //FaceBook
{
    
    NSString* msg=[NSLocalizedString(@"Definitely a unique twist on tic tac toe and rock paper scissors... I like it! :", @"Definitely a unique twist on tic tac toe and rock paper scissors... I like it! :")  stringByAppendingString:kSHORT_APP_URL];
       
    FBViewController* fbController=[[FBViewController alloc ]initWithMsg:msg];
    
    [kAPP_DELEGATE.window.rootViewController presentModalViewController:fbController animated:YES];
    
    [FBViewController release];

}


-(void)dealloc{
    
    [super dealloc];
}



@end
