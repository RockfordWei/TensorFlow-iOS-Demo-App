//
//  ViewController.m
//  Mealscan
//
//  Created by Rocky Wei on 2018-08-13.
//  Copyright © 2018 Rocky Wei. All rights reserved.
//

#import "ViewController.h"
#import "TFLib.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (IBAction)click:(id)sender {
  dispatch_async(dispatch_get_main_queue(), ^(void){
    NSDataAsset * frozen = [[NSDataAsset alloc] initWithName:@"FrozenPB"];
    char display[1024] = "";
    greetings(display, frozen.data.bytes, (int)frozen.data.length);
    self->_textStatus.text = [NSString stringWithUTF8String:display] ;
  });
}

@end
