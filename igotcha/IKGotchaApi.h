//
//  IKGotchaApi.h
//  igotcha
//
//  Created by Igor Kantor on 11/10/12.
//  Copyright (c) 2012 Igor Kantor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IKGotchaApi : NSObject
+ (void) registerToken:(NSString*)token forUser:(NSString*)user;
+ (void) dropImage:(NSData*) image forUser:(NSString*)user;
+ (NSDictionary*) getPlayerInfoForUser:(NSString*)user;
+ (void) confirmEliminationForUser:(NSString*)user;
+ (void) denyEliminationForUser:(NSString*)user;

@end
