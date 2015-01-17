//
//  PenSettingsViewController.m
//  Pictaphone
//
//  Created by Kelly Hutchison on 11/22/14.
//  Copyright (c) 2014 Kelly Hutchison. All rights reserved.
//

#import "PenSettingsViewController.h"
#import "HRColorPickerView.h"
#import "HRBrightnessSlider.h"
#import "model.h"

#define THIN 5
#define MEDIUM 13
#define THICK 20

@interface PenSettingsViewController ()

@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (strong, nonatomic) HRColorPickerView *colorPickerView;


- (IBAction)cancelPressed:(id)sender;
- (IBAction)donePressed:(id)sender;

@property (weak, nonatomic) IBOutlet UISegmentedControl *thicknessSegmentOutlet;
- (IBAction)thicknessChanged:(id)sender;


@property (nonatomic,strong) model *model;

@end

@implementation PenSettingsViewController

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
    
    [self initializeView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self initializePenSettings];
}

-(void)initializeView {
    self.view.opaque = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"PenSettings";
    self.colorView.hidden = YES;
    
    // Get color components and initialize slider values and label values
    if (!self.pageColor){
        self.pageColor = [UIColor blackColor];
    }
    
    // Set default thickness amount
    self.thicknessSegmentOutlet.selectedSegmentIndex = 0;
    
}

-(void)initializePenSettings {
    // Color Picker
    CGRect frame = self.colorView.frame;
    self.colorPickerView = [[HRColorPickerView alloc] initWithFrame:frame];
    self.colorPickerView.color = self.pageColor;
    self.colorPickerView.brightnessSlider.brightnessLowerLimit = @0.0;
    [self.colorPickerView addTarget:self
                             action:@selector(colorChanged)
                   forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.colorPickerView];
    
    // Pen Width
    NSInteger width = self.drawWidth;
    switch (width) {
        case THIN:
            self.thicknessSegmentOutlet.selectedSegmentIndex = 0;
            break;         case 13:
            self.thicknessSegmentOutlet.selectedSegmentIndex = 1;
            break;
        case THICK:
            self.thicknessSegmentOutlet.selectedSegmentIndex = 2;
            break;
        default:
            break;
            
            //test
            
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)donePressed:(id)sender {
    self.drawWidthCompletionBlock(self.drawWidth);
     self.completionBlock(@{@"color":self.pageColor});
}

- (void)colorChanged {
    self.pageColor = self.colorPickerView.color;
}

- (IBAction)thicknessChanged:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl*) sender;
    NSInteger segmentClicked = segmentedControl.selectedSegmentIndex;
    
    if (segmentClicked == 0) {
        self.drawWidth = THIN;
    }
    else if (segmentClicked == 1) {
        self.drawWidth = MEDIUM;
    }
    else {
        self.drawWidth = THICK;
    }
}

@end
