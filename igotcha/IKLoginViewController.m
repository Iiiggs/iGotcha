//
//  IKLoginViewController.m
//  igotcha
//
//  Created by Igor Kantor on 11/10/12.
//  Copyright (c) 2012 Igor Kantor. All rights reserved.
//

#import "IKLoginViewController.h"
#import <FacebookSDK/FBLoginView.h>
#import "IKUserModel.h"
#import "IKAppDelegate.h"

@interface IKLoginViewController ()

@end

@implementation IKLoginViewController

- (id)init
{
    self = [super init];
    if (self) {
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LogOnBg@2x.png"]];
        backgroundView.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
        [self.view addSubview:backgroundView];
        
        FBLoginView *loginview = [[FBLoginView alloc] init];
        loginview.frame = CGRectOffset(loginview.frame, 80, 340);
        loginview.delegate = self;
        [self.view addSubview:loginview];
    }
    return self;
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    NSLog(@"Profile Id: %@", user.id);
    [IKUserModel sharedUserModel].profileId = user.id;
    IKAppDelegate *delegate=(IKAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate showTabBarController];
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
