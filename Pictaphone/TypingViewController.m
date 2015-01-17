//
//  TypingViewController.m
//  Pictaphone
//
//  Created by Kelly Hutchison on 11/22/14.
//  Copyright (c) 2014 Kelly Hutchison. All rights reserved.
//

#import "TypingViewController.h"
#import "ViewLastTurnViewController.h"
#import "model.h"

@interface TypingViewController ()
@property (nonatomic,strong) model *model;

@property (weak, nonatomic) IBOutlet UIButton *doneButton;
- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)endOfGameButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *endOfGameDoneButton;
@property (weak, nonatomic) IBOutlet UILabel *roundLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerLabel;
@property (weak, nonatomic) IBOutlet UIButton *viewLastTurnButton;
- (IBAction)viewLastTurnPressed:(id)sender;

@property (nonatomic, assign) UIImage *lastRoundImage;

@property (weak, nonatomic) IBOutlet UILabel *clickHereLabel;
@property (weak, nonatomic) IBOutlet UIImageView *clickHereArrow;

@property (weak, nonatomic) IBOutlet UITextView *typingTextView;
@end

@implementation TypingViewController

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
    self.view.backgroundColor = [UIColor colorWithWhite:5.0 alpha:0.95];
    
    self.typingTextView.layer.borderWidth = 5.0f;
    self.typingTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    
    self.typingTextView.delegate = self;
    [self.typingTextView resignFirstResponder];
    
    [self initializeGameSettings];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewShouldBeginEditing:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewShouldReturn:) name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)textViewShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    
    if (![[touch view] isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self     action:@selector(editButtonPressed:)];
        self.navigationItem.rightBarButtonItem = editButton;
    }
    else
    {
        // Change bar button item
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self     action:@selector(doneEditingButtonPressed:)];
        self.navigationItem.rightBarButtonItem = doneButton;
        [self setEditing:YES animated:YES];
    }
    [super touchesBegan:touches withEvent:event];
}

// It is important for you to hide keyboard
- (BOOL)textViewShouldReturn:(UITextField *)textField
{
    [self.typingTextView resignFirstResponder];
    return YES;
}


-(void)initializeGameSettings
{
    [self initializeLastRoundButton];
    
    // Check if this is the last turn
    NSInteger turnsRemaining = [self.model turnsRemaining];
    if(turnsRemaining == 1)
    {
        self.doneButton.hidden = YES;
        self.endOfGameDoneButton.hidden = NO;
    }
    
    NSInteger currentRound = [self.model currentRound];
    [self.roundLabel setText:[NSString stringWithFormat:@"%@%ld", @"Round: ", (long)currentRound]];
    
    NSInteger currentPlayer = [self.model currentPlayer];
    [self.playerLabel setText:[NSString stringWithFormat:@"%@%ld", @"Player: ", (long)currentPlayer]];
    
    // Show/Hide the click here label during first round
    if(currentRound == 1) {
        if([self.model currentTurn]== 1 && !self.autoGenerate) {
            self.clickHereArrow.hidden = YES;
            self.clickHereLabel.hidden = YES;
        } else {
            self.clickHereArrow.hidden = NO;
            self.clickHereLabel.hidden = NO;
        }
    } else {
        self.clickHereArrow.hidden = YES;
        self.clickHereLabel.hidden = YES;
    }
}


-(void)initializeLastRoundButton
{
    // Check if first image is auto generated
    // Check if this is first round/auto generate
    if([self.model currentTurn]== 1) {
        if(self.autoGenerate) {
            self.viewLastTurnButton.hidden = NO;
            self.viewLastTurnButton.userInteractionEnabled = YES;
            
            // Set random icon image
            self.lastRoundImage = self.randomImage;
            [self.viewLastTurnButton setImage:self.lastRoundImage forState:UIControlStateNormal];
        }
        else {
            self.viewLastTurnButton.hidden = YES;
        }
    }
    else {
        self.viewLastTurnButton.hidden = NO;
        self.viewLastTurnButton.userInteractionEnabled = YES;
        
        // Set random icon image
        NSInteger lastIndex = [self.model contentsArrayCount]-1;
        self.lastRoundImage = [self.model valueOfContentsArrayAtIndex:lastIndex];
        [self.viewLastTurnButton setImage:self.lastRoundImage forState:UIControlStateNormal];
    }
    
    self.self.viewLastTurnButton.layer.borderWidth = 5.0f;
    self.self.viewLastTurnButton.layer.borderColor = [[UIColor grayColor] CGColor];
    [self.viewLastTurnButton setContentMode:UIViewContentModeRedraw];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"lastTurn"])
    {
        ViewLastTurnViewController *lastTurnVC = segue.destinationViewController;
        lastTurnVC.drawing = self.lastRoundImage;
        lastTurnVC.contentToDisplay = @"drawing";
    }
}

- (IBAction)doneButtonPressed:(id)sender {
    [self.model trackFinishedTurn];
    
    NSString *phrase = self.typingTextView.text;
    [self.model populateContentsArrayWithPhrase:phrase];
}

- (IBAction)endOfGameButtonPressed:(id)sender {
    [self.model trackFinishedTurn];
    
    NSString *phrase = self.typingTextView.text;
    [self.model populateContentsArrayWithPhrase:phrase];
}
- (IBAction)viewLastTurnPressed:(id)sender {
}

// Done Button Pressed
-(void)doneEditingButtonPressed:(id)sender
{
    // Set editing mode disabled
    [self setEditing:NO animated:YES];
    [self.view endEditing:YES];
    [self.typingTextView resignFirstResponder];
}

- (IBAction)editButtonPressed:(id)sender
{
    // Set editing mode enabled
    [self setEditing:YES animated:YES];
    
    if (self.editing) {
        [self.typingTextView becomeFirstResponder];
    } else {
        [self.typingTextView resignFirstResponder];
    }
}

@end
