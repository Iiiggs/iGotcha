//
//  IKWinnerViewController.m
//  igotcha
//
//  Created by Igor Kantor on 11/11/12.
//  Copyright (c) 2012 Igor Kantor. All rights reserved.
//

#import "IKWinnerViewController.h"

@interface IKWinnerViewController ()

@end

@implementation IKWinnerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, self.view.frame.size.height)];
        backgroundImageView.image = [UIImage imageNamed:@"YouWonBg.png"];
        [self.view addSubview:backgroundImageView];

        UIImageView *gotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(35, 70, 250, 300)];
        NSArray * imageArray  = [[NSArray alloc] initWithObjects:
                                 [UIImage imageNamed:@"YouWon1.png"],
                                 [UIImage imageNamed:@"YouWon2.png"],
                                 [UIImage imageNamed:@"YouWon3.png"],
                                 [UIImage imageNamed:@"YouWon2.png"],
                                 nil];
        gotImageView.animationImages = imageArray;
        gotImageView.animationDuration = .6;
        [self.view addSubview:gotImageView];
        [gotImageView startAnimating];
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

@end
