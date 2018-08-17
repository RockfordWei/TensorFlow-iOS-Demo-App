//
//  ViewController.h
//  Mealscan
//
//  Created by Rocky Wei on 2018-08-13.
//  Copyright © 2018 Rocky Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface ViewController : UIViewController
  <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textStatus;
@property (weak, nonatomic) IBOutlet UIImageView *preview;

@property (strong, nonatomic) UIImagePickerController *picker;

- (IBAction)clickScan:(id)sender;
- (IBAction)clickLoad:(id)sender;

@end

