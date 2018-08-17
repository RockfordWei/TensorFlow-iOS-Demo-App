//
//  ViewController.m
//  Mealscan
//
//  Created by Rocky Wei on 2018-08-13.
//  Copyright © 2018 Rocky Wei. All rights reserved.
//

#import "ViewController.h"
#import "TFLib.h"

#import <CoreImage/CoreImage.h>
#import <ImageIO/ImageIO.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.picker = [[UIImagePickerController alloc] init];
  self.picker.delegate = (id)self;
  self.picker.allowsEditing = NO;
  self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (IBAction)clickScan:(id)sender {
  dispatch_async(dispatch_get_main_queue(), ^{
    CGImageRef image_ref = CGImageCreateCopy( [self.preview.image CGImage] );
    int width = (int)CGImageGetWidth(image_ref);
    int height = (int)CGImageGetHeight(image_ref);
    CGDataProviderRef provider = CGImageGetDataProvider(image_ref);
    CFDataRef data_ref = CGDataProviderCopyData(provider);
    NSData * data = (__bridge_transfer NSData*)data_ref;
    NSDataAsset * frozen = [[NSDataAsset alloc] initWithName:@"FrozenPB"];
    char display[1024] = "";
    greetings(display, frozen.data.bytes,
              (int)frozen.data.length, [data bytes],
              (int)[data length], width, height);
    self.textStatus.text = [NSString stringWithUTF8String:display] ;
  });
}

- (void)imagePickerController:(UIImagePickerController *) picker
  didFinishPickingMediaWithInfo:(NSDictionary *)info {
  [picker dismissViewControllerAnimated:YES completion:^{
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    if (chosenImage) {
      self.preview.image = chosenImage;
      self.textStatus.text = @"Picture Loaded" ;
    }
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
@end
