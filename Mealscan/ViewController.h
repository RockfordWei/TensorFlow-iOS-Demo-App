//
//  ViewController.h
//  Mealscan
//
//  Created by Rocky Wei on 2018-08-13.
//  Copyright © 2018 Rocky Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>
#import <ImageIO/ImageIO.h>
#import <Photos/Photos.h>
#import <TesseractOCR/TesseractOCR.h>

@interface ViewController : UIViewController
  <UIImagePickerControllerDelegate, UINavigationControllerDelegate,G8TesseractDelegate>

@property (weak, nonatomic) IBOutlet UIProgressView *progressor;
@property (weak, nonatomic) IBOutlet UITextView *textStatus;
@property (weak, nonatomic) IBOutlet UIImageView *preview;
@property (strong, nonatomic) UIImagePickerController *picker;
@property (strong, nonatomic) G8Tesseract *tesseract;

- (IBAction)clickScan:(id)sender;
- (IBAction)clickLoad:(id)sender;

@end

