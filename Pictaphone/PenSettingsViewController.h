//
//  PenSettingsViewController.h
//  Pictaphone
//
//  Created by Kelly Hutchison on 11/22/14.
//  Copyright (c) 2014 Kelly Hutchison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PenSettingsViewController : UIViewController
@property (nonatomic,strong) UIColor *pageColor;
@property (nonatomic,assign) CGFloat drawWidth;
@property (nonatomic,strong) CompletionBlock completionBlock;
@property (nonatomic,strong) FloatCompletionBlock drawWidthCompletionBlock;
@end
