//
//  NagScreenViewController.m
//  MultiMatch_the_game
//
//  Created by Nik Rudenko on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NagScreenViewController.h"
#import "AppDelegate.h"

@implementation NagScreenViewController
@synthesize link;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
          }
    return self;
}

-(void)setResource:(NSString*)resource isHTML:(BOOL)_isHTML{
    
    isHTML = _isHTML;
    
    if (isHTML) {
        
    }
    else{
//        NSString *resource_updated = [NSString stringWithString:resource];
//        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//            resource_updated = [[resource stringByDeletingPathExtension] stringByAppendingString:@"_hi.jpg"];       
//        }
//        else{
//            resource_updated = [NSString stringWithString:resource];
//        }
        
        //            imageView = [[UIImageView alloc] initWithFrame:CGRectNull];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *writableFilePath = [documentsDirectory stringByAppendingPathComponent: [resource lastPathComponent] ];   
        UIImage *image = [UIImage imageWithContentsOfFile:writableFilePath];
        
        if (!image){            
            NSData *data;
            data = [NSData dataWithContentsOfURL:[NSURL URLWithString:resource]];
            [data writeToFile:writableFilePath atomically:YES];
            image = [UIImage imageWithData:data];
        }
        
        imageView.image = image;
//        imageView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.height, self.view.frame.size.width);
  
//        [self.view addSubview:imageView];
//        imageView.contentMode = UIViewContentModeScaleAspectFill;
//        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | 
//        UIViewAutoresizingFlexibleHeight;
              
//        [loading removeFromSuperview];
        
        UIButton *clickButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.height, self.view.frame.size.width)];
        clickButton.backgroundColor = [UIColor clearColor];
        clickButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [clickButton addTarget:self action:@selector(clickButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:clickButton];
        
        [self.view bringSubviewToFront:button];
    }        

}

-(void)clickButtonAction{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
}

- (void)dealloc
{
    [super dealloc];
}

-(void)addTarget:(id)target selector:(SEL)selector{
    closeTarget = target;
    closeSelector = selector;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(IBAction)close{
//    [self.view removeFromSuperview];
    
    [((AppDelegate*)[UIApplication sharedApplication].delegate).window.rootViewController dismissModalViewControllerAnimated:YES];
    
    if (closeTarget) {
        [closeTarget performSelector:closeSelector];
    }  
}

#pragma delegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [activity startAnimating];
    loading.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [activity stopAnimating];
    loading.hidden = YES;
}

-(void)setLansdcapeMode{
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    webView.scalesPageToFit = YES;
//    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:link]]];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
//    if(self.interfaceOrientation == UIInterfaceOrientationLandscapeRight){
//        imageView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.height, self.view.frame.size.width);
//    }
//    else{
//        imageView.frame = self.view.frame;
//    }
    
    [self.view bringSubviewToFront:button];
    
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
