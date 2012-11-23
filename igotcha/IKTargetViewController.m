//
//  IKTargetViewController.m
//  igotcha
//
//  Created by Igor Kantor on 11/10/12.
//  Copyright (c) 2012 Igor Kantor. All rights reserved.
//

#import "IKTargetViewController.h"
#import "SMImageView.h"
#import "IKGotchaApi.h"
#import "IKUserModel.h"
#import "IKPownedViewController.h"
#import "IKWinnerViewController.h"

@interface IKTargetViewController ()


@end

@implementation IKTargetViewController

@synthesize  launchYouGotPownedView;
@synthesize  launchYouAreTheWinnerView;
@synthesize messageLabel;
@synthesize  firstNameLabel;
@synthesize   lastNameLabel;
@synthesize  nicknameLabel;
@synthesize   locationLabel;
@synthesize targetImageView;

- (id)init
{
    self = [super init];
    if (self) {
        
        self.launchYouGotPownedView = NO;
        self.launchYouAreTheWinnerView = NO;
        
        [IKUserModel sharedUserModel].targetViewController = self;
        
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ProfileBg@2x.png"]];
        backgroundView.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
        [self.view addSubview:backgroundView];

        self.title = NSLocalizedString(@"Target", @"Target");
        self.tabBarItem.image = [UIImage imageNamed:@"ProfileIcon"];
        
        messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 200, 300, 100)];
        messageLabel.numberOfLines = 2;
        messageLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:24];
        messageLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:messageLabel];
        
        firstNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 180, 300, 40)];
        
        firstNameLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:24];
        firstNameLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:firstNameLabel];
        
        lastNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 220, 300, 40)];
        
        lastNameLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:24];
        lastNameLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:lastNameLabel];
        
        
        nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 260, 300, 40)];
        
        nicknameLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:24];
        nicknameLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:nicknameLabel];
        
        locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 300, 300, 80)];
        
        locationLabel.numberOfLines = 2;
        
        locationLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:24];
        locationLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:locationLabel];
        
        [self.view addSubview: [[SMImageView alloc]
                                initWithFrame:CGRectMake(185, 45, 100, 100)
                                imageUrlString:@""
                                altImage:nil]];
        
        [[IKUserModel sharedUserModel].profileInfo addObserver:self forKeyPath:@"Status" options:0 context:nil];
        [[IKUserModel sharedUserModel].profileInfo addObserver:self forKeyPath:@"TargetProfileId" options:0 context:nil];
        
        
        [[IKUserModel sharedUserModel] updateFromServer];
        [self reloadData];

        
        //self.view.frame = CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 29);
    }
    return self;
}

//http://placekitten.com/50/50

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

- (void)viewDidAppear:(BOOL)animated
{
    [self presentViewControllers];
}

- (void) presentViewControllers
{
    if(self.launchYouGotPownedView)
    {
        IKPownedViewController *pownedViewController = [[IKPownedViewController alloc] init];
        [self.tabBarController presentViewController:pownedViewController animated:NO completion:nil];
        return;
    }
    else if(self.launchYouAreTheWinnerView)
    {
        IKWinnerViewController *winnerViewController = [[IKWinnerViewController alloc] init];
        [self.tabBarController presentViewController:winnerViewController animated:YES completion:nil];
        return;
    }
//    else
//    {
//        //        UIViewController *presentedViewContorller = [self.parentViewController presentedViewController];
//        [self.tabBarController dismissViewControllerAnimated:YES  completion:nil];
//    }

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"Status"] && object == [IKUserModel sharedUserModel].profileInfo ) {
        NSLog(@"Updated stats");
        [self reloadData];
    }
    if ([keyPath isEqualToString:@"TargetProfileId"] && object == [IKUserModel sharedUserModel].profileInfo ) {
        [self reloadData];
    }
}


-(void)reloadData
{
    NSDictionary *infoDict = [IKUserModel sharedUserModel].profileInfo;
    NSNumber* gameStatus = [infoDict objectForKey:@"Status"];
    
    self.launchYouGotPownedView = NO;
    self.launchYouAreTheWinnerView = NO;
    
    if([gameStatus intValue] == 3)
    {
        NSString *targetProfileUrl = [infoDict objectForKey:@"TargetProfileImage"];
        [self.view addSubview: [[SMImageView alloc]
                                initWithFrame:CGRectMake(185, 45, 100, 100)
                                imageUrlString:targetProfileUrl
                                altImage:nil]];
        
        NSString *lastKnownLocation = [infoDict objectForKey:@"TargetLastKnownLocation"];
        if([lastKnownLocation isEqualToString:@""])
        {
            lastKnownLocation = @"Unknown";
        }
        locationLabel.text = [NSString stringWithFormat:@"Last Known Location: %@", lastKnownLocation];
        nicknameLabel.text = [NSString stringWithFormat:@"AKA: %@", [infoDict objectForKey:@"TargetNickName"] ];
        lastNameLabel.text = [NSString stringWithFormat:@"Last Name: %@", [infoDict objectForKey:@"TargetLastName"] ];
        firstNameLabel.text = [NSString stringWithFormat:@"First Name: %@", [infoDict objectForKey:@"TargetFirstName"] ];
        
        messageLabel.text = @"";
        
    }
    else
    {
        [self.view addSubview: [[SMImageView alloc]
                                initWithFrame:CGRectMake(185, 45, 100, 100)
                                imageUrlString:@""
                                altImage:nil]];
        
        locationLabel.text = @"";
        nicknameLabel.text = @"";
        lastNameLabel.text = @"";
        firstNameLabel.text = @"";
        
    }
    
    
    if([gameStatus intValue] == 0)
    {
        messageLabel.text = @"Not part of a game. You should go start one";
    }
    else if ([gameStatus intValue] == 1)
    {
        messageLabel.text = @"The game you set up has not started yet";
    }
    else if ([gameStatus intValue] == 2)
    {
        messageLabel.text = @"You're all set but your game hasn't started yet";
    }

    else if ([gameStatus intValue] == 4)
    {
        self.launchYouGotPownedView = YES;
    }
    else if ([gameStatus intValue] == 5)
    {
        messageLabel.text = @"You've been eliminted";
        
    }
    else if ([gameStatus intValue] == 6)
    {
        self.launchYouAreTheWinnerView = YES;
    }
    

}


@end
