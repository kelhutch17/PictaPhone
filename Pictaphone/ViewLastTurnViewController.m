//
//  ViewLastTurnViewController.m
//  Pictaphone
//
//  Created by Kelly Hutchison on 12/11/14.
//  Copyright (c) 2014 Kelly Hutchison. All rights reserved.
//

#import "ViewLastTurnViewController.h"
#import "model.h"

@interface ViewLastTurnViewController ()
@property (nonatomic,strong) model *model;
@property (weak, nonatomic) IBOutlet UIImageView *lastImage;
@property (weak, nonatomic) IBOutlet UITextView *lastPhrase;

@property (nonatomic, strong) UIImage *imageToDisplay;
@property (nonatomic, assign) NSString *phraseToDisplay;

- (IBAction)backButtonPressed:(id)sender;

@end

@implementation ViewLastTurnViewController

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
    
    if(self.sentence)
    {
        self.phraseToDisplay = self.sentence;
    }
    else {
        self.phraseToDisplay = @"";
    }
    if(self.drawing)
    {
        self.imageToDisplay = self.drawing;
    }
    else {
        self.imageToDisplay = [[UIImage alloc] init];
    }
    
    if([self.contentToDisplay isEqual:@"drawing"])
    {
        self.lastPhrase.hidden = YES;
        self.lastImage.hidden = NO;
        self.lastImage.image = self.imageToDisplay;
        self.lastImage.userInteractionEnabled = NO;
        self.lastImage.contentMode = UIViewContentModeScaleAspectFit;
        
        self.lastImage.layer.borderWidth = 5.0f;
        self.lastImage.layer.borderColor = [[UIColor grayColor] CGColor];
    }
    else if([self.contentToDisplay isEqual:@"phrase"]) {
        self.lastPhrase.hidden = NO;
        self.lastImage.hidden = YES;
        self.lastPhrase.text = self.phraseToDisplay;
        self.lastPhrase.userInteractionEnabled = NO;
        self.lastPhrase.font = [UIFont fontWithName:@"Tamil Sangam MN" size:22.0];
        
        self.lastPhrase.layer.borderWidth = 5.0f;
        self.lastPhrase.layer.borderColor = [[UIColor grayColor] CGColor];
        
        self.lastPhrase.textAlignment = NSTextAlignmentCenter;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
