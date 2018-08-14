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
  NSDataAsset * frozen = [[NSDataAsset alloc] initWithName:@"FrozenPB"];
  char display[1024] = "";
  greetings(display, frozen.data.bytes, frozen.data.length);
  _textStatus.text = [NSString stringWithUTF8String:display] ;
}

@end
