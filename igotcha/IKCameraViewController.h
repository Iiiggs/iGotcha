//
//  IKCameraViewController.h
//  igotcha
//
//  Created by Igor Kantor on 11/10/12.
//  Copyright (c) 2012 Igor Kantor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IKCameraViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property UIImagePickerController *cameraUI;

@end
