//
//  GameModeViewController.m
//  Pictaphone
//
//  Created by Kelly Hutchison on 11/22/14.
//  Copyright (c) 2014 Kelly Hutchison. All rights reserved.
//

#import "GameModeViewController.h"
#import "GameSetupViewController.h"
#import "model.h"

#define iPadSegmentedCtrlFontSize 25.0

@interface GameModeViewController ()
@property (nonatomic,strong) model *model;
@property (nonatomic,strong) NSString *device;
@property (nonatomic,assign) NSInteger gameModeDescriptionFontSize;

@property (weak, nonatomic) IBOutlet UISegmentedControl *deviceModeSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *deviceModeLabel;
@property (weak, nonatomic) IBOutlet UITextView *deviceModeDescription;
@property (weak, nonatomic) IBOutlet UIImageView *singleDeviceModeImage;
@property (weak, nonatomic) IBOutlet UIImageView *multiDeviceModeImage;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;


@end

@implementation GameModeViewController

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
    // Do any additional setup after loading the view.
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        self.device = @"iPhone";
    }
    else
    {
        self.device = @"iPad";
    }
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.view.opaque = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Define a custom green
    // TODO: globally declare the custom colors so that we can use them everywhere programmatically
    
    // TODO: Replace constants
    UIColor *green1 = [UIColor colorWithRed:(80.0/255.0) green:(140.0/255.0) blue:(40.0/255.0) alpha:1.0];
    UIColor *green2 = [UIColor colorWithRed:(111.0/255.0) green:(178.0/255.0) blue:(31.0/255.0) alpha:1.0];
    
    // Format the buttons in a uniform way
    // Apply borders to the buttons using quartz
    self.btnNext.layer.borderWidth=3.0f;
    self.btnNext.layer.borderColor=[green1 CGColor];
    self.btnNext.layer.backgroundColor=[green2 CGColor];
    self.btnNext.layer.cornerRadius=5;
    self.btnNext.titleLabel.font=[UIFont fontWithName:@"Helvetica Bold" size:20.0];
    
    [self setupSegmentedControl];
    [self initializeGameModeAssets];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeGameModeAssets
{
    self.singleDeviceModeImage.hidden = NO;
    self.multiDeviceModeImage.hidden = YES;
    
    self.deviceModeLabel.text = [self.model titleForGameMode:@"single"];
    self.deviceModeDescription.text = [self.model descriptionForGameMode:@"single"];
    [self.deviceModeDescription setTextAlignment:NSTextAlignmentCenter];
    
    // set the font type and size
    if([self.device isEqual: @"iPhone"]) {
        self.gameModeDescriptionFontSize = 16.0;
    }
    else {
        self.gameModeDescriptionFontSize = 24.0;
    }
    self.deviceModeDescription.font = [UIFont fontWithName:@"Tamil Sangam MN" size:self.gameModeDescriptionFontSize];
    
    self.deviceModeLabel.userInteractionEnabled = NO;
    self.deviceModeDescription.userInteractionEnabled = NO;
}

- (void)setupSegmentedControl
{
    // Only change the size of the segmented control font if we are running on an iPad
    if([self.device isEqual: @"iPad"])
    {
        UIFont *font = [UIFont boldSystemFontOfSize:iPadSegmentedCtrlFontSize];
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
        [self.deviceModeSegmentedControl setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
    }
    
    [self.deviceModeSegmentedControl addTarget:self
                                        action:@selector(deviceModeChanged:)
               forControlEvents:UIControlEventValueChanged];
}



#pragma mark - Segmented Control Event Handling

- (void)deviceModeChanged:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl*) sender;
    NSInteger segmentClicked = segmentedControl.selectedSegmentIndex;
    
    // Single Device Mode
    if(segmentClicked == 0)
    {
        self.singleDeviceModeImage.hidden = NO;
        self.multiDeviceModeImage.hidden = YES;
        
        self.deviceModeLabel.text = [self.model titleForGameMode:@"single"];
        self.deviceModeDescription.text = [self.model descriptionForGameMode:@"single"];
    }
    // Multi-Device Mode
    else
    {
        self.singleDeviceModeImage.hidden = YES;
        self.multiDeviceModeImage.hidden = NO;
        
        self.deviceModeLabel.text = [self.model titleForGameMode:@"multi"];
        self.deviceModeDescription.text = [self.model descriptionForGameMode:@"multi"];
    }
    
    // Apply these settings if either segmented control is clicked
    self.deviceModeDescription.font = [UIFont fontWithName:@"Tamil Sangam MN" size:self.gameModeDescriptionFontSize];
    [self.deviceModeDescription setTextAlignment:NSTextAlignmentCenter];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"pushSegue"]) {
        GameSetupViewController *setupViewController = segue.destinationViewController;
        
        if([self.deviceModeLabel.text isEqual:@"Single Device Mode"])
        {
            setupViewController.gameMode = @"single";
        }
        else if([self.deviceModeLabel.text isEqual:@"Multi-Device Mode"])
        {
            setupViewController.gameMode = @"multi";
        }

    }
}


@end
