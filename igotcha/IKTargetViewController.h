//
//  IKTargetViewController.h
//  igotcha
//
//  Created by Igor Kantor on 11/10/12.
//  Copyright (c) 2012 Igor Kantor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMImageView.h"


@interface IKTargetViewController : UIViewController
@property BOOL launchYouGotPownedView;
@property BOOL launchYouAreTheWinnerView;

@property UILabel* messageLabel;
@property UILabel* firstNameLabel;
@property UILabel* lastNameLabel;
@property UILabel* nicknameLabel;
@property UILabel* locationLabel;
@property SMImageView* targetImageView;

-(void)reloadData;

@end
