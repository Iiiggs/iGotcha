//
//  IKCameraViewController.m
//  igotcha
//
//  Created by Igor Kantor on 11/10/12.
//  Copyright (c) 2012 Igor Kantor. All rights reserved.
//

#import "IKCameraViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "IKGotchaApi.h"
#import "IKUserModel.h"


@interface IKCameraViewController ()

@end


@implementation IKCameraViewController

@synthesize cameraUI;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        // Custom initialization
        self.title = @"Get!";
        self.tabBarItem.image = [UIImage imageNamed:@"CameraIcon"];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    if (cameraUI == nil)
    {
        [self startCameraControllerFromViewController: self
                                        usingDelegate: self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    
    
    cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraUI.view.frame = CGRectMake(self.view.bounds.origin.x,
                                     self.view.bounds.origin.y,
                                     self.view.bounds.size.width,
                                     self.view.bounds.size.height);
    
    cameraUI.allowsEditing = NO;

    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    cameraUI.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    
    cameraUI.delegate = delegate;
    
//    [controller presentViewController: cameraUI animated: YES completion:nil];
    [self.view addSubview:cameraUI.view];
    
    return YES;
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
    
    // Handle a still image capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo) {
        
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToSave = editedImage;
        } else {
            imageToSave = originalImage;
        }
        
        // Save the new image (original or edited) to the Camera Roll
//        UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil);
        
        NSData *imageData = UIImageJPEGRepresentation(imageToSave, .25);
        [IKGotchaApi dropImage:imageData forUser:[IKUserModel sharedUserModel].profileId];
        
        [self.tabBarController setSelectedIndex:1];
    }

    
    self.parentViewController.tabBarController.selectedIndex = 1;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.tabBarController setSelectedIndex:1];
}

@end
