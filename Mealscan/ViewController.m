//
//  ViewController.m
//  Mealscan
//
//  Created by Rocky Wei on 2018-08-13.
//  Copyright © 2018 Rocky Wei. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.picker = [[UIImagePickerController alloc] init];
  self.picker.delegate = (id)self;
  self.picker.allowsEditing = NO;
  self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

  self.tesseract = [[G8Tesseract alloc] initWithLanguage:@"eng"];
  [self.tesseract setDelegate:(id)self];
  //[self.tesseract setRect:CGRectMake(0, 0, 512, 512)];
  [self.tesseract setCharWhitelist:@"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ=+-*/:."];
  //[self.tesseract setMaximumRecognitionTime:2.0];
  [self.progressor setHidden:TRUE];

}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}


- (IBAction)clickScan:(id)sender {
  [self.tesseract setImage:self.preview.image];
  [self.progressor setHidden:FALSE];
  dispatch_queue_t que = dispatch_queue_create("meal_scanner", NULL);
  dispatch_async(que, ^{
    [self.tesseract recognize];
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.textStatus setText:[self.tesseract recognizedText]];
      [self.progressor setHidden:TRUE];
    });
  });
}

- (void)imagePickerController:(UIImagePickerController *) picker
  didFinishPickingMediaWithInfo:(NSDictionary *)info {
  [picker dismissViewControllerAnimated:YES completion:^{
    dispatch_async(dispatch_get_main_queue(), ^{
      UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
      if (chosenImage) {
        [self.progressor setProgress:0];
        [self.textStatus setText:@"Photo loaded"];
        [self.preview setImage:chosenImage];
      }
    });
  }];
}

- (IBAction)clickLoad:(id)sender {
  [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
    if (status == PHAuthorizationStatusAuthorized) {
      [self presentViewController:self.picker animated:YES completion:NULL];
    }
  }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)progressImageRecognitionForTesseract:(G8Tesseract *)tesseract {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.progressor setProgress:tesseract.progress/100.0 animated:YES];
  });
}

- (BOOL)shouldCancelImageRecognitionForTesseract:(G8Tesseract *)tesseract {
  return NO;  // return YES, if you need to interrupt tesseract before it finishes
}
@end
