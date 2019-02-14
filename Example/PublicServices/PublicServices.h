//
//  PublicServices.h
//  PublicServices
//
//  Created by huluobo on 2019/2/13.
//  Copyright © 2019 huluobo. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for PublicServices.
FOUNDATION_EXPORT double PublicServicesVersionNumber;

//! Project version string for PublicServices.
FOUNDATION_EXPORT const unsigned char PublicServicesVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <PublicServices/PublicHeader.h>

@protocol TestService <NSObject>

- (void)test;

@end
