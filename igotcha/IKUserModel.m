//
//  IKUserModel.m
//  igotcha
//
//  Created by Igor Kantor on 11/10/12.
//  Copyright (c) 2012 Igor Kantor. All rights reserved.
//

#import "IKUserModel.h"
#import "IKGotchaApi.h"

@implementation IKUserModel

static IKUserModel *sharedUserModel = nil;
@synthesize targetViewController;

+ (IKUserModel *)sharedUserModel {
    if (!sharedUserModel) {
        sharedUserModel = [[IKUserModel alloc] init];
    }
    return sharedUserModel;
}

@synthesize profileId;
@synthesize profileInfo;

-(void)updateFromServer
{
    NSDictionary *dict = [IKGotchaApi getPlayerInfoForUser:sharedUserModel.profileId];
    NSDictionary *playerDict = [dict objectForKey:@"Player"];
    
    if(profileInfo == nil)
    {
        profileInfo = [[NSMutableDictionary alloc] init];
    }
    
    [profileInfo setValue:[playerDict objectForKey:@"Status"] forKey:@"Status"];
    [profileInfo setValue:[playerDict objectForKey:@"EliminationImage"] forKey:@"EliminationImage"];
    
    NSNumber* gameStatus = [profileInfo objectForKey:@"Status"];
    
    if([gameStatus intValue] == 3)
    {
        NSDictionary *targetDict = [playerDict objectForKey:@"Target"];
        
        [profileInfo setValue:[targetDict objectForKey:@"ProfileImage"] forKey:@"TargetProfileImage"];
        [profileInfo setValue:[targetDict objectForKey:@"FacebookId"] forKey:@"TargetProfileId"];
        [profileInfo setValue:[targetDict objectForKey:@"FirstName"] forKey:@"TargetFirstName"];
        [profileInfo setValue:[targetDict objectForKey:@"LastName"] forKey:@"TargetLastName"];
        [profileInfo setValue:[targetDict objectForKey:@"NickName"] forKey:@"TargetNickName"];
        
        [profileInfo setValue:[targetDict objectForKey:@"LastKnownLocation"] forKey:@"TargetLastKnownLocation"];
    }
    [targetViewController reloadData];
}

@end
