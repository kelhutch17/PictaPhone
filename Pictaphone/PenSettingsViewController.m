//
//  PenSettingsViewController.m
//  Pictaphone
//
//  Created by Kelly Hutchison on 11/22/14.
//  Copyright (c) 2014 Kelly Hutchison. All rights reserved.
//

#import "PenSettingsViewController.h"
#import "model.h"

#define THIN 5.0f
#define MEDIUM 13.0f
#define THICK 20.0f

@interface PenSettingsViewController ()

@property (weak, nonatomic) IBOutlet UIView *colorView;
- (IBAction)cancelPressed:(id)sender;
- (IBAction)donePressed:(id)sender;

@property CGFloat redValue;
@property CGFloat greenValue;
@property CGFloat blueValue;

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
    // Do any additional setup after loading the view.
    self.view.opaque = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"PenSettings";
    
    // Get color components and initialize slider values and label values
    CGFloat alpha;
    CGFloat red,blue,green;
    [self.pageColor getRed:&red green:&green blue:&blue alpha:&alpha];
    _redValue = red*255.0;
    _greenValue = green*255.0;
    _blueValue = blue*255.0;
    
    // Set default thickness amount
    self.thicknessSegmentOutlet.selectedSegmentIndex = 0;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Set the color wheel to the current value
    
    
    // Set pen width selected segment
    NSInteger width = self.drawWidth;
    switch (width) {
        case 5:
            self.thicknessSegmentOutlet.selectedSegmentIndex = 0;
            break;
        case 13:
            self.thicknessSegmentOutlet.selectedSegmentIndex = 1;
            break;
        case 20:
            self.thicknessSegmentOutlet.selectedSegmentIndex = 2;
            break;
        default:
            break;
    }
}

-(void)viewDidAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// when any slider changes we update the controls & view
-(void)updateLabel:(UILabel*)label withValue:(NSInteger)value {
    label.text = [NSString stringWithFormat:@"%ld", (long)value];
    
    self.pageColor = [UIColor colorWithRed:_redValue/255.0 green:_greenValue/255.0 blue:_blueValue/255.0 alpha:1.0];
}

- (IBAction)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)donePressed:(id)sender {
    self.drawWidthCompletionBlock(self.drawWidth);
     self.completionBlock(@{@"color":self.pageColor});
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
