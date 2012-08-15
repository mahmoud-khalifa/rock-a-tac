//
//  MPConstants.h
//  MoPub
//
//  Created by Nafis Jamal on 2/9/11.
//  Copyright 2011 MoPub, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MP_DEBUG_MODE				1

#define HOSTNAME					@"ads.mopub.com"
#define DEFAULT_PUB_ID				@"agltb3B1Yi1pbmNyDAsSBFNpdGUYkaoMDA"
#define MP_SDK_VERSION              @"1.7.0.0"

// Sizing constants.
#define MOPUB_BANNER_SIZE_IPHONE			CGSizeMake(320, 50)
#define MOPUB_BANNER_SIZE_IPHONE_R			CGSizeMake(640, 100)
#define MOPUB_BANNER_SIZE_IPAD			CGSizeMake(768, 90)
//#define MOPUB_BANNER_SIZE_IPAD_R			CGSizeMake(320, 50)

#define MOPUB_MEDIUM_RECT_SIZE		CGSizeMake(300, 250)
#define MOPUB_LEADERBOARD_SIZE		CGSizeMake(728, 90) 
#define MOPUB_WIDE_SKYSCRAPER_SIZE	CGSizeMake(160, 600)

// Miscellaneous constants.
#define MINIMUM_REFRESH_INTERVAL	5.0

// In-app purchase constants.
#define STORE_RECEIPT_SUFFIX		@"/m/purchase"

// Device identifier constants.
#define MOPUB_USE_OPENUDID                  0
#define MOPUB_IDENTIFIER_DEFAULTS_KEY       @"MOPUB_IDENTIFIER"

