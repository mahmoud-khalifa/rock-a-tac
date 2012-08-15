#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol RevMobAdsDelegate <NSObject>

@optional

# pragma mark Ad Callbacks (Fullscreen, Banner and Popup)

/*! @function revmobAdDidReceive
 @discussion: Fired by Fullscreen, banner and popup. Called when the communication with the server is finished with success.
 */
- (void)revmobAdDidReceive;

/*! @function revmobAdDidFailWithError:
 @param error: contains error information.
 @discussion: Fired by Fullscreen, banner and popup. Called when the communication with the server is finished with error.
 */
- (void)revmobAdDidFailWithError:(NSError *)error;

/*! @function revmobAdDisplayed
 @discussion: Fired by Fullscreen, banner and popup. Called when the Ad is displayed in the screen.
 */
- (void)revmobAdDisplayed;

/*! @function revmobUserClickedInTheAd
 @discussion: Fired by Fullscreen, banner and popup.
 */
- (void)revmobUserClickedInTheAd;

/*! @function revmobUserClosedTheAd
 @discussion: Fired by Fullscreen and popup.
 */
- (void)revmobUserClosedTheAd;

# pragma mark Advertiser Callbacks

/*! @function installDidReceive
 @discussion: Called if install is successfully registered
 */
- (void)installDidReceive;

/*! @function installDidFail
 @discussion: Called if install couldn't be registered
 */
- (void)installDidFail;

@end
