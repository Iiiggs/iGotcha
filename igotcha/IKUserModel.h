//
//  IKUserModel.h
//  igotcha
//
//  Created by Igor Kantor on 11/10/12.
//  Copyright (c) 2012 Igor Kantor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IKTargetViewController.h"

@interface IKUserModel : NSObject
+(IKUserModel*)sharedUserModel;
- (void)updateFromServer;
@property (nonatomic,retain) NSString* profileId;
@property (nonatomic,retain) NSMutableDictionary* profileInfo;

@property (nonatomic,retain) IKTargetViewController* targetViewController;

@end
