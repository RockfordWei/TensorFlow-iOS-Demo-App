//
//  ViewController.h
//  Mealscan
//
//  Created by Rocky Wei on 2018-08-13.
//  Copyright © 2018 Rocky Wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *textStatus;
@property (weak, nonatomic) IBOutlet UIImageView *preview;

- (IBAction)click:(id)sender;

@end

