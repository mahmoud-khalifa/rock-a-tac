//
//  RootViewController.m
//  TicTacToe
//
//  Created by Log n Labs on 1/31/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

//
// RootViewController + iAd
// If you want to support iAd, use this class as the controller of your iAd
//

#import "cocos2d.h"

#import "RootViewController.h"
#import "GameConfig.h"
#import "Controller.h"
#import "AppDelegate.h"

@implementation RootViewController

static RootViewController *instanceOfRootViewController;

#pragma mark Singleton stuff
+(id) alloc
{
	@synchronized(self)	
	{
		NSAssert(instanceOfRootViewController == nil, @"Attempted to allocate a second instance of the singleton: RootViewController");
		instanceOfRootViewController = [[super alloc] retain];
		return instanceOfRootViewController;
	}
	
	// to avoid compiler warning
	return nil;
}

+(RootViewController*) sharedRootViewController
{
	@synchronized(self)
	{
		if (instanceOfRootViewController == nil)
		{
			[[RootViewController alloc] init];
		}
		
		return instanceOfRootViewController;
	}
	
	// to avoid compiler warning
	return nil;
}

-(id)init{
    self=[super init];
    if (self) {
//#ifdef LITE_VERSION
//        imageView=[[UIView alloc]init];
//        imageView.backgroundColor=[UIColor blackColor];

      //        [self.view bringSubviewToFront:imageView];
        if (![[Controller sharedController] isFeaturePurchased:kREMOVE_ADS_ID]) {
             [self setAdViewFrameAtBottom:NO];
        }else {
            [self hideAd];
        }
       
//#endif
    }
    return self;
}
//#ifdef LITE_VERSION
-(void)setAdViewFrameAtBottom:(BOOL)inBottom{
    //    CGRect frame = _adView.frame;
    //    CGSize size = [_adView adContentViewSize];
    //    if (inBottom) {
    //        
    //        frame.origin.y = self.view.bounds.size.height - size.height;
    //        _adView.frame = frame;
    //        frame.origin.y=screenSize.height-size.height;
    //        self.view.frame=frame;
    //    }else{
    //         frame.origin.y= 0;
    //        _adView.frame = frame;
    //self.view.frame=CGRectMake(0, 0, 320, 50);;
    //    }
    //
    //
    
    float yPos=0;
    float adHeight;
    if (IS_IPAD()) {
        adHeight=90;
        
    }else{
        adHeight=50;
    }
    if (inBottom) {
        yPos=screenSize.height-adHeight;
    }
    
    adFrame=CGRectMake(0, yPos, screenSize.width, adHeight);
//    imageView.frame=adFrame;
    theAdView.frame=adFrame;
}
-(void)hideAd{
    float adHeight;
    if (IS_IPAD()) {
        adHeight=90;
        
    }else{
        adHeight=50;
    }

    adFrame=CGRectMake(0, -adHeight, screenSize.width, adHeight);
//    imageView.frame=adFrame;
    theAdView.frame=adFrame;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate adView].frame = adFrame ;
}
#pragma mark Tapjoy Display Ads Delegate Methods

- (void)didReceiveAd:(TJCAdView*)adView
{
    //CGRect frame=adView.frame;
	adView.frame =adFrame;//= CGRectMake(0, 0, 320, 50);
    theAdView=adView;
}


- (void)didFailWithMessage:(NSString*)msg
{
	NSLog(@"No Tapjoy Display Ads available");
}


- (NSString*)adContentSize
{
    
    if (IS_IPAD()) {
        return TJC_AD_BANNERSIZE_768X90;
    }
	return TJC_AD_BANNERSIZE_320X50;
}


- (BOOL)shouldRefreshAd
{
	return YES;
}


//#endif
- (void)dealloc {
    [super dealloc];
//    [imageView release];
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
	// Custom initialization
	}
	return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
     
    
	[super viewDidLoad];
     
//     imageView=[[UIView alloc]init];
//     imageView.backgroundColor=[UIColor blackColor];
//     
//
//    [self.view addSubview:imageView];
//     [self.view bringSubviewToFront:imageView];
 }

-(void)viewDidAppear:(BOOL)animated{

}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	//
	// There are 2 ways to support auto-rotation:
	//  - The OpenGL / cocos2d way
	//     - Faster, but doesn't rotate the UIKit objects
	//  - The ViewController way
	//    - A bit slower, but the UiKit objects are placed in the right place
	//
	
//#if GAME_AUTOROTATION==kGameAutorotationNone
	//
	// EAGLView won't be autorotated.
	// Since this method should return YES in at least 1 orientation, 
	// we return YES only in the Portrait orientation
	//
	return ( interfaceOrientation == UIInterfaceOrientationPortrait );
	
//#elif GAME_AUTOROTATION==kGameAutorotationCCDirector
//	//
//	// EAGLView will be rotated by cocos2d
//	//
//	// Sample: Autorotate only in landscape mode
//	//
//	if( interfaceOrientation == UIInterfaceOrientationLandscapeLeft ) {
//		[[CCDirector sharedDirector] setDeviceOrientation: kCCDeviceOrientationLandscapeRight];
//	} else if( interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
//		[[CCDirector sharedDirector] setDeviceOrientation: kCCDeviceOrientationLandscapeLeft];
//	}
//	
//	// Since this method should return YES in at least 1 orientation, 
//	// we return YES only in the Portrait orientation
//	return ( interfaceOrientation == UIInterfaceOrientationPortrait );
//	
//#elif GAME_AUTOROTATION == kGameAutorotationUIViewController
//	//
//	// EAGLView will be rotated by the UIViewController
//	//
//	// Sample: Autorotate only in landscpe mode
//	//
//	// return YES for the supported orientations
//	
//	return ( UIInterfaceOrientationIsLandscape( interfaceOrientation ) );
//	
//#else
//#error Unknown value in GAME_AUTOROTATION
//	
//#endif // GAME_AUTOROTATION
//	
//	
//	// Shold not happen
//	return NO;
}

//
// This callback only will be called when GAME_AUTOROTATION == kGameAutorotationUIViewController
//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	//
	// Assuming that the main window has the size of the screen
	// BUG: This won't work if the EAGLView is not fullscreen
	///
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	CGRect rect = CGRectZero;

	
	if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)		
		rect = screenRect;
	
	else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
		rect.size = CGSizeMake( screenRect.size.height, screenRect.size.width );
	
	CCDirector *director = [CCDirector sharedDirector];
	EAGLView *glView = [director openGLView];
	float contentScaleFactor = [director contentScaleFactor];
	
	if( contentScaleFactor != 1 ) {
		rect.size.width *= contentScaleFactor;
		rect.size.height *= contentScaleFactor;
	}
	glView.frame = rect;
}
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end

