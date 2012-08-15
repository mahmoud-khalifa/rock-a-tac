#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RevMobAdsDelegate.h"


@interface RevMobAds : NSObject

#pragma mark Fullscreen

/*! @function showFullscreenAdWithAppID:
    @seealso: showFullscreenAdWithAppID:withDelegate:withSpecificOrientations:, ... 
 */
+ (void) showFullscreenAdWithAppID:(NSString *)appID;


/*! @function showFullscreenAdWithAppID:withDelegate:
    @seealso: showFullscreenAdWithAppID:withDelegate:withSpecificOrientations:, ...
 */
+ (void) showFullscreenAdWithAppID:(NSString *)appID withDelegate:(NSObject<RevMobAdsDelegate> *)delegate;


/*! @function showFullscreenAdWithAppID:withDelegate:withSpecificOrientations:, ...
 @param appID: You can collect your App ID at http://revmob.com by looking up your apps.
 @param delegate: You can receive notifications when the Ad is or is not loaded, when the user click in the close button or in the Ad. It may be nil.
 @param orientations: You can define to which orientations the fullscreen will rotate. It may be nil.
 @discussion
 
 Example of Usage:
 ---------------------------------------------
 
 [RevMobAds showFullscreenAdWithAppID:REVMOB_ID withDelegate:nil withSpecificOrientations:nil];
 
 
 Example of Usage using specific orientations:
 ---------------------------------------------
 
 [RevMobAds showFullscreenAdWithAppID:REVMOB_ID withDelegate:nil withSpecificOrientations:UIInterfaceOrientationPortrait, UIInterfaceOrientationLandscapeLeft, nil];
 

 Example of Usage using delegate:
 --------------------------------
 
 ** MyRevMobAdsDelegate.h
 
 #import <Foundation/Foundation.h>
 #import "RevMobAdsDelegate.h"
 
 @interface MyRevMobAdsDelegate : NSObject<RevMobAdsDelegate>
 @end
 
 
 ** MyRevMobAdsDelegate.m
 
 @implementation MyRevMobAdsDelegate
 
 - (void) revmobAdDidReceive {
     NSLog(@"[RevMob Sample App] Ad loaded.");
 }
 
 - (void) revmobAdDidFailWithError:(NSError *)error {
     NSLog(@"[RevMob Sample App] Ad failed.");
 }
 
 - (void) revmobUserClickedInTheCloseButton {
     NSLog(@"[RevMob Sample App] User clicked in the close button");
 }
 
 - (void) revmobUserClickedInTheAd {
     NSLog(@"[RevMob Sample App] User clicked in the Ad");
 }
 @end
 
 
 ** MyViewController.m
 
 #import "RevMobAds.h"
 #import "RevMobAdsDelegate.h"
 
 @implementation MyViewController
 
 - (void)someMethod {
     NSString *REVMOB_ID = @"4f342dc09dcb890003003a7a";
     MyRevMobAdsDelegate *delegate = [[MyRevMobAdsDelegate alloc] init];
     [RevMobAds showFullscreenAdWithAppID:REVMOB_ID withDelegate:delegate withSpecificOrientations:nil];
     [delegate release];
 }
 
 */
+ (void) showFullscreenAdWithAppID:(NSString *)appID withDelegate:(NSObject<RevMobAdsDelegate> *)delegate withSpecificOrientations:(UIInterfaceOrientation)orientations, ...;


/*! @function showFullscreenAdWithAppID:withSpecificOrientations:withDelegate:
 @discussion: You can use this method if you rather to use NSArray instead of Variable argument list.
 @seealso: showFullscreenAdWithAppID:withDelegate:withSpecificOrientations:, ...
 */
+ (void) showFullscreenAdWithAppID:(NSString *)appID withSpecificOrientations:(NSArray *)orientations withDelegate:(NSObject<RevMobAdsDelegate> *)delegate;


#pragma mark Fullscreen with pre-load

/*! @function loadFullscreenAdWithAppID:
    @seealso: loadFullscreenAdWithAppID:withDelegate:withSpecificOrientations:, ...
 */
+ (void) loadFullscreenAdWithAppID:(NSString *)appID;


/*! @function loadFullscreenAdWithAppID:withDelegate:
    @seealso: loadFullscreenAdWithAppID:withDelegate:withSpecificOrientations:, ...
 */
+ (void) loadFullscreenAdWithAppID:(NSString *)appID withDelegate:(NSObject<RevMobAdsDelegate> *)delegate;


/*! @function loadFullscreenAdWithAppID:withDelegate:withSpecificOrientations:, ...
  @param appID: You can collect your App ID at http://revmob.com by looking up your apps.
  @param delegate: You can receive notifications when the Ad is or is not loaded, when the user click in the close button or in the Ad. It may be nil.
  @param orientations: You can define to which orientations the fullscreen will rotate. It may be nil.
  @discussion
 
 Load a Fullscreen Ad without showing it. To show the loaded Ad you have to call the showLoadedFullscreenAdWithAppID: method.
 You may call this method in the beginning of the game or level to show the ad in the future.
 
 Example of Usage:
 ---------------------------------------------
 [RevMobAds loadFullscreenAdWithAppID:REVMOB_ID withDelegate:nil withSpecificOrientations:nil];
 
 Example of Usage using specific orientations:
 ---------------------------------------------
 [RevMobAds loadFullscreenAdWithAppID:REVMOB_ID withDelegate:nil withSpecificOrientations:UIInterfaceOrientationPortraitUpsideDown, UIInterfaceOrientationLandscapeRight, nil];
 
  @seealso: showLoadedFullscreenAdWithAppID:
  @seealso: isLoadedFullscreenAdWithAppID:
  @seealso: releaseLoadedFullscreenAdWithAppID:
 */
+ (void) loadFullscreenAdWithAppID:(NSString *)appID withDelegate:(NSObject<RevMobAdsDelegate> *)delegate withSpecificOrientations:(UIInterfaceOrientation)orientations, ...;


/*! @function loadFullscreenAdWithAppID:withSpecificOrientations:withDelegate:
 @discussion: You can use this method if you rather to use NSArray instead of Variable argument list.
 @seealso: loadFullscreenAdWithAppID:withDelegate:withSpecificOrientations:, ...
 */
+ (void) loadFullscreenAdWithAppID:(NSString *)appID withSpecificOrientations:(NSArray *)orientations withDelegate:(NSObject<RevMobAdsDelegate> *)delegate;


/*! @function showLoadedFullscreenAdWithAppID:
  @discussion
 
  This method will show the Ad you ask to load in the past, using the method loadFullscreenAdWithAppID:.		 
  If you did not call the loadFullscreenAdWithAppID: method, nothing will happen.
 
  @seealso: loadFullscreenAdWithAppID:withDelegate:withSpecificOrientations:, ...
  @seealso: isLoadedFullscreenAdWithAppID:
  @seealso: releaseLoadedFullscreenAdWithAppID:
*/
+ (void) showLoadedFullscreenAdWithAppID:(NSString *)appID;


/*! @function isLoadedFullscreenAdWithAppID:
  @discussion
 
  Return YES if the previously loaded Ad (by the method loadFullscreenAdWithAppID:) is loaded. Else return NO.		 
  If you did not call the loadFullscreenAdWithAppID: method, nothing will happen and it will return NO.
 
  @seealso: loadFullscreenAdWithAppID:withDelegate:withSpecificOrientations:, ...
  @seealso: showLoadedFullscreenAdWithAppID:
  @seealso: releaseLoadedFullscreenAdWithAppID:
*/
+ (BOOL) isLoadedFullscreenAdWithAppID:(NSString *)appID;


/*! @function releaseLoadedFullscreenAdWithAppID:
  @discussion
 
  Delete and release the Ad that was previously loaded by the method loadFullscreenAdWithAppID:.
  If you did not call the loadFullscreenAdWithAppID: method, nothing will happen.
 
  @seealso: loadFullscreenAdWithAppID:
  @seealso: isLoadedFullscreenAdWithAppID:
  @seealso: showLoadedFullscreenAdWithAppID:
*/
+ (void) releaseLoadedFullscreenAdWithAppID:(NSString *)appID;


#pragma mark Banner

/*! @function showBannerAdWithAppID:
 @seealso showBannerAdWithAppID:withFrame:withDelegate:withSpecificOrientations:
 */
+ (void) showBannerAdWithAppID:(NSString *)appID;


/*! @function showBannerAdWithAppID:withDelegate:
 @seealso showBannerAdWithAppID:withFrame:withDelegate:withSpecificOrientations:
 */
+ (void) showBannerAdWithAppID:(NSString *)appID withDelegate:(NSObject<RevMobAdsDelegate> *)delegate;


/*! @function showBannerAdWithAppID:withDelegate:withSpecificOrientations:,...
 @seealso showBannerAdWithAppID:withFrame:withDelegate:withSpecificOrientations:
 */
+ (void) showBannerAdWithAppID:(NSString *)appID withDelegate:(NSObject<RevMobAdsDelegate> *)delegate withSpecificOrientations:(UIInterfaceOrientation)orientations, ...;


/*! @function showBannerAdWithAppID:withFrame:withDelegate:
 @seealso showBannerAdWithAppID:withFrame:withDelegate:withSpecificOrientations:
 */
+ (void) showBannerAdWithAppID:(NSString *)appID withFrame:(CGRect)frame withDelegate:(NSObject<RevMobAdsDelegate> *)delegate;


/*! @function showBannerAdWithAppID:withFrame:withDelegate:withSpecificOrientations:
 @param appID: You can collect your App ID at http://revmob.com by looking up your apps.
 @param frame: A CGRect that will be used to draw the banner. The 0,0 point of the coordinate system will be always in the top-left corner.  It may be CGRectNull.
 @param delegate: You can receive notifications when the Ad is or is not loaded. It may be nil.
 @param orientations: You can define to which orientations the banner will rotate. It may be nil.
 @discussion
 
 If frame is nil, the banner will be stucked to the bottom, with width 100% and height 50 points, no matter the orientation.
 Else, you can customize the location and size of the banner, but the minimum accepted size is 320,50. In this case, the developer has the 
 responsibility to adjust the banner frame on rotation.
 
 Example of Usage:
 -----------------
 [RevMobAds showBannerAdWithAppID:REVMOB_ID withFrame:CGRectNull withDelegate:nil withSpecificOrientations:nil];
 
 Example of Usage using custom frame:
 ------------------------------------
 [RevMobAds showBannerAdWithAppID:REVMOB_ID withFrame:CGRectMake(0, 0, 320, 50) withDelegate:nil withSpecificOrientations:nil];
 
 Example of Usage using specific orientations:
 ---------------------------------------------
 [RevMobAds showBannerAdWithAppID:REVMOB_ID withFrame:CGRectNull withDelegate:nil withSpecificOrientations:UIInterfaceOrientationPortraitUpsideDown, UIInterfaceOrientationLandscapeRight, nil];
 
 @seealso: hideBannerAdWithAppID:
 */
+ (void) showBannerAdWithAppID:(NSString *)appID withFrame:(CGRect)frame withDelegate:(NSObject<RevMobAdsDelegate> *)delegate withSpecificOrientations:(UIInterfaceOrientation)orientations, ...;


/*! @function showBannerAdWithAppID:withFrame:withSpecificOrientations:withDelegate:
 @discussion: You can use this method if you rather to use NSArray instead of Variable argument list.
 @seealso: showBannerAdWithAppID:withFrame:withDelegate:withSpecificOrientations:
 */
+ (void) showBannerAdWithAppID:(NSString *)appID withFrame:(CGRect)frame withSpecificOrientations:(NSArray *)orientations withDelegate:(NSObject<RevMobAdsDelegate> *)delegate;


/*! @function hideBannerAdWithAppID:
 @param appID: You can collect your App ID at http://revmob.com by looking up your apps.
 @discussion
 
 Hide a banner.
 
 @seealso showBannerAdWithAppID:withFrame:withDelegate:withSpecificOrientations:
 */
+ (void) hideBannerAdWithAppID:(NSString *)appID;

#pragma mark Ad Link

/*! @function openAdLinkWithAppID
 @param appID: You can collect your App ID at http://revmob.com by looking up your apps.
 @discussion
 
 Open an Ad link in the iTunes store. You can call this method, for example, when the user clicks in a button "Get More Free Games".
 
 */
+ (void) openAdLinkWithAppID:(NSString *)appID;

#pragma mark Popup

/*! @function showPopupWithAppID:
 @seealso showPopupWithAppID:withDelegate:
 */
+ (void) showPopupWithAppID:(NSString *)appID;


/*! @function showPopupWithAppID:withDelegate:
 @param appID: You can collect your App ID at http://revmob.com by looking up your apps.
 @param delegate: You can receive notifications when the Ad is or is not loaded. It may be nil.
 @discussion
 
 This will show a popup ad unit.
 
 You can call this on: Delegate, UIViewController or any other type of object.
 Performance: You will be paid primarily by the number of installs your app generates and 
 sometimes by the number of clicks on the popups. Impressions shouldn't provide revenue.
 Deactivation: Not necessary.
 When: Best to show when app opens, but can be shown whenever you want.
 
 Example:
 
 - (void)applicationDidBecomeActive:(UIApplication *)application {
    [RevMobAds showPopupWithAppID:REVMOB_ID withDelegate:nil];
 }
 
 - (void)viewDidLoad {
    [super viewDidLoad];
    [RevMobAds showPopupWithAppID:REVMOB_ID withDelegate:nil];
 }
 
 *** any other object or method will work
 */
+ (void) showPopupWithAppID:(NSString *)appID withDelegate:(NSObject<RevMobAdsDelegate> *)delegate;

@end
