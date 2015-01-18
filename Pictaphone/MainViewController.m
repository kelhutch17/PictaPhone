//
//  MainViewController.m
//  Pictaphone
//
//  Created by Kelly Hutchison on 11/5/14.
//  Copyright (c) 2014 Kelly Hutchison. All rights reserved.
//

#import "MainViewController.h"
#import "model.h"
#import <QuartzCore/QuartzCore.h>


@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UITextView *lblDescriptionText;
@property (weak, nonatomic) IBOutlet UIImageView *imgPencilLogo;
@property (weak, nonatomic) IBOutlet UIButton *btnInstructions;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (nonatomic,strong) model *model;
@end

@implementation MainViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        _model = [model sharedInstance];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // TODO: move all the graphical setup to a function
    
    // Rotate the text in the sticky note by 3 degrees to make it look pretty
    self.lblDescriptionText.transform = CGAffineTransformMakeRotation(357 * M_PI / 180.0);
    
    // Hide the navigation bar
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    // Apply a nice background to the view
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"random_grey_variations.png"]]];
    
    // Define a custom green
    // TODO: globally declare the custom colors so that we can use them everywhere programmatically
    
    // TODO: Replace constants
    UIColor *green1 = [UIColor colorWithRed:(80.0/255.0) green:(140.0/255.0) blue:(40.0/255.0) alpha:1.0];
    
    // Apply borders to the buttons using quartz
    self.btnPlay.layer.borderWidth=3.0f;
    self.btnPlay.layer.borderColor=[green1 CGColor];
    self.btnPlay.layer.cornerRadius=5;
    self.btnPlay.titleLabel.font=[UIFont fontWithName:@"Helvetica Bold" size:20.0];
    
    self.btnInstructions.layer.borderWidth=3.0f;
    self.btnInstructions.layer.borderColor=[green1 CGColor];
    self.btnInstructions.layer.cornerRadius=5;
    self.btnInstructions.titleLabel.font=[UIFont fontWithName:@"Helvetica Bold" size:20.0];
}

-(void) viewDidAppear:(BOOL)animated
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [self.model initializeGameSettings];
}


@end
