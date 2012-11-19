//
//  IKPownedViewController.m
//  igotcha
//
//  Created by Igor Kantor on 11/11/12.
//  Copyright (c) 2012 Igor Kantor. All rights reserved.
//

#import "IKPownedViewController.h"
#import "SMImageView.h"
#import "IKGotchaApi.h"
#import "IKUserModel.h"

@interface IKPownedViewController ()

@end

@implementation IKPownedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];
//        label.text = @"You just got GOT";
//        label.font = [UIFont systemFontOfSize:32];
//        [self.view addSubview:label];
        
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        backgroundImageView.image = [UIImage imageNamed:@"DoneBeenGotBg.png"];
        [self.view addSubview:backgroundImageView];
        
        [[IKUserModel sharedUserModel] updateFromServer];
        NSString * elimImageUrl = [[IKUserModel sharedUserModel].profileInfo objectForKey:@"EliminationImage" ];
        NSString *fullImageUrl = [NSString stringWithFormat:@"http://igotchaapp.com%@", elimImageUrl];
        
        
        NSURL *url = [[NSURL alloc] initWithString:fullImageUrl];
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:url];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(35, 50, 244.8, 326.4)];
        imageView.image = [[UIImage alloc] initWithData:imageData];
        [self.view addSubview:imageView];
        
        UIImageView *gotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(150, 250, 160, 128)];
        gotImageView.image = [UIImage imageNamed:@"DoneBeenGot.png"];
        [self.view addSubview:gotImageView];

        UIButton *confirm = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        confirm.frame = CGRectMake(25, 390, 130, 60);
        [confirm setTitle:@"You got me" forState:UIControlStateNormal];
        [confirm addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:confirm];
        
        UIButton *deny = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        deny.frame = CGRectMake(165, 390, 130, 60);
        [deny addTarget:self action:@selector(deny) forControlEvents:UIControlEventTouchDown];
        [deny setTitle:@"NOT ME!" forState:UIControlStateNormal];
        [self.view addSubview:deny];
    }
    return self;
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

- (void) confirm
{
    [IKGotchaApi confirmEliminationForUser:[IKUserModel sharedUserModel].profileId];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) deny
{
    [IKGotchaApi denyEliminationForUser:[IKUserModel sharedUserModel].profileId];
    [[self parentViewController].tabBarController dismissViewControllerAnimated:YES completion:nil];
}

@end
