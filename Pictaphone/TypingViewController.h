//
//  TypingViewController.h
//  Pictaphone
//
//  Created by Kelly Hutchison on 11/22/14.
//  Copyright (c) 2014 Kelly Hutchison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TypingViewController : UIViewController <UITextViewDelegate>
@property (nonatomic, assign) BOOL autoGenerate;

@property (nonatomic, assign) UIImage *randomImage;
@end
