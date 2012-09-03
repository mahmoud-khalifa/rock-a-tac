//
//  MKStoreKitConfigs.h
//  MKStoreKit (Version 4.0)
//
//  Created by Mugunth Kumar on 17-Nov-2010.
//  Version 4.0
//  Copyright 2010 Steinlogic. All rights reserved.
//	File created using Singleton XCode Template by Mugunth Kumar (http://mugunthkumar.com
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above
//  Read my blog post at http://mk.sg/1m on how to use this code

//  Licensing (Zlib)
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//  3. This notice may not be removed or altered from any source distribution.

//  As a side note on using this code, you might consider giving some credit to me by
//	1) linking my website from your app's website 
//	2) or crediting me inside the app's credits page 
//	3) or a tweet mentioning @mugunthkumar
//	4) A paypal donation to mugunth.kumar@gmail.com


// To avoid making mistakes map plist entries to macros on this page.
// when you include MKStoreManager in your clss, these macros get defined there

#ifdef ARABIC_VERSION

//#define kConsumableBaseFeatureId @"com.stariosgames.rockatac."
//#define kUNLOCK_GOLDEN_TEAM_ID @"com.stariosgames.rockatac.unlockgoldenteam1"
//#define kREMOVE_ADS_ID @"com.stariosgames.rockatac.removeads1"

#define kConsumableBaseFeatureId @"com.stariosgames.rockatacarabic."
#define kUNLOCK_GOLDEN_TEAM_ID @"com.stariosgames.rockatacarabic.unlockgoldenteam1"
#define kREMOVE_ADS_ID @"com.stariosgames.rockatacarabic.removeads1"

#else

//#define kConsumableBaseFeatureId @"com.stariosgames.rockatacfree."
//#define kUNLOCK_GOLDEN_TEAM_ID @"com.stariosgames.rockatacfree.unlockgoldenteam"
//#define kREMOVE_ADS_ID @"com.stariosgames.rockatacfree.removeads"

#define kConsumableBaseFeatureId @"com.stariosgames.rockatac."
#define kUNLOCK_GOLDEN_TEAM_ID @"com.stariosgames.rockatac.unlockgoldenteam1"
#define kREMOVE_ADS_ID @"com.stariosgames.rockatac.removeads1"

#endif


#define SERVER_PRODUCT_MODEL 0
#define OWN_SERVER nil
#define REVIEW_ALLOWED 0//1

//#warning Shared Secret Missing Ignore this warning if you don't use auto-renewable subscriptions
#define kSharedSecret @"<FILL IN YOUR SHARED SECRET HERE>"
