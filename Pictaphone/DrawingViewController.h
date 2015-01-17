//
//  DrawingViewController.h
//  Pictaphone
//
//  Created by Kelly Hutchison on 11/22/14.
//  Copyright (c) 2014 Kelly Hutchison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
    Paint = 0,
    Erase = 1,
} ToolType;

@interface DrawingViewController : UIViewController

// Pen Properties
@property (nonatomic, assign) ToolType toolType;
@property (strong, nonatomic) UIColor* drawColor;
@property (nonatomic, assign) CGFloat drawWidth;
@property (nonatomic, assign) CGFloat drawOpacity;

@property (nonatomic, assign) NSString *randomPhrase;

@property (nonatomic, assign) BOOL autoGenerate;

- (void) clearToColor:(UIColor*)color;

- (UIImage*) getSketch;
- (void) setSketch:(UIImage*)sketch;

@end
