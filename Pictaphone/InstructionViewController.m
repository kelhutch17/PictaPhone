//
//  InstructionViewController.m
//  Pictaphone
//
//  Created by Kelly Hutchison on 11/22/14.
//  Copyright (c) 2014 Kelly Hutchison. All rights reserved.
//

#import "InstructionViewController.h"
#import "model.h"

#define iPadLabelFontSize 41.0
#define iPhoneLabelFontSize 18.0

#define iPhoneInstructionsFontSize 15.0
#define iPadInstructionsFontSize 26.5

#define xCoordinateOffset 10.0

#define iPhoneYCoordinateOffset 5.0
#define iPadYCoordinateOffset 7.0

#define iPhoneLabelHeightOffset 10.0
#define iPadLabelHeightOffset 15.0

#define titleSpacing 6.0
#define iPhoneLineSpacing 3.0
#define iPadLineSpacing 2.75

#define widthOffset 20.0
#define spacing 5.0

@interface InstructionViewController ()
@property (nonatomic,strong) model *model;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic,assign) NSInteger postItNoteXOffset;
@property (nonatomic,assign) NSInteger postItNoteYOffset;
@end

@implementation InstructionViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
         _model = [model sharedInstance];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    // Do any additional setup after loading the view.
    [self initializeScrollView];
    [self loadScrollViewPages];
    
    self.view.opaque = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.postItNoteXOffset = self.scrollView.frame.origin.x;
    self.postItNoteYOffset = self.scrollView.frame.origin.y;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeScrollView
{
    self.scrollView.delegate = self;
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.pagingEnabled = YES;
    
    NSInteger instructionCount = [self.model instructionPageCount];
    CGSize contentSize = CGSizeMake(self.scrollView.bounds.size.width * instructionCount, self.scrollView.frame.size.height);
    self.scrollView.contentSize =  contentSize;
    
    self.pageControl.numberOfPages = instructionCount;
    self.pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
}

- (void)loadScrollViewPages
{
    for(int i=0; i < [self.model instructionPageCount]; i++)
    {
        [self loadPostItNoteImages:i];
        [self loadInstructionLabels:i];
    }
}

- (void)loadPostItNoteImages:(int) pageNumber
{
    UIImage *image = [UIImage imageNamed:@"post_it_two.png"];
    UIImageView *postItNote = [[UIImageView alloc] initWithImage:image];
    
    CGRect frame = self.scrollView.frame;
    frame.origin = CGPointMake((frame.size.width * pageNumber), self.postItNoteYOffset);
    
    postItNote.frame = frame;
    postItNote.contentMode = UIViewContentModeScaleAspectFit;
    postItNote.hidden = NO;
    
    [self.scrollView addSubview:postItNote];
}

- (void)loadInstructionLabels:(int) pageNumber
{
    // Determine font size of labels based on device
    float titleFontSize;
    float textViewFontSize;
    float yCoordinateOffset;
    float heightOffset;
    float lineSpacing;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        titleFontSize = iPhoneLabelFontSize;
        textViewFontSize = iPhoneInstructionsFontSize;
        yCoordinateOffset = iPhoneYCoordinateOffset;
        heightOffset = iPhoneLabelHeightOffset;
        lineSpacing = iPhoneLineSpacing;
    }
    else
    {
        titleFontSize = iPadLabelFontSize;
        textViewFontSize = iPadInstructionsFontSize;
        yCoordinateOffset = iPadYCoordinateOffset;
        heightOffset = iPadLabelHeightOffset;
        lineSpacing = iPadLineSpacing;
    }
    
    // Title
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(self.scrollView.frame.size.width * pageNumber, self.scrollView.bounds.origin.y + yCoordinateOffset, self.scrollView.frame.size.width, self.scrollView.frame.size.height/6);
    title.hidden = NO;
    title.userInteractionEnabled = NO;
    [title setTextAlignment:NSTextAlignmentCenter];
    title.font = [UIFont fontWithName:@"Noteworthy-Bold" size:titleFontSize];
    title.text = [self.model instructionTitleForPage:pageNumber];
    [self.scrollView addSubview:title];
    
    
    // Line One
    UITextView *lineOne = [[UITextView alloc] init];
    lineOne.backgroundColor = [UIColor clearColor];
    lineOne.frame = CGRectMake((self.scrollView.frame.size.width * pageNumber) + xCoordinateOffset, self.scrollView.bounds.origin.y + title.bounds.size.height, self.scrollView.frame.size.width-widthOffset, (self.scrollView.frame.size.height/lineSpacing)-heightOffset);
    lineOne.hidden = NO;
    lineOne.userInteractionEnabled = NO;
    [lineOne setTextAlignment:NSTextAlignmentCenter];
    lineOne.font = [UIFont fontWithName:@"Noteworthy" size:textViewFontSize];
    lineOne.text = [self.model instructionLineOneForPage:pageNumber];
    [self.scrollView addSubview:lineOne];
    
    
    // Line Two
    UITextView *lineTwo = [[UITextView alloc] init];
    lineTwo.backgroundColor = [UIColor clearColor];
    lineTwo.frame = CGRectMake((self.scrollView.frame.size.width * pageNumber) + xCoordinateOffset, self.scrollView.bounds.origin.y + title.bounds.size.height + lineOne.frame.size.height - spacing, self.scrollView.frame.size.width-widthOffset, (self.scrollView.frame.size.height/lineSpacing)+(2*spacing));
    lineTwo.hidden = NO;
    lineTwo.userInteractionEnabled = NO;
    [lineTwo setTextAlignment:NSTextAlignmentCenter];
    lineTwo.font = [UIFont fontWithName:@"Noteworthy" size:textViewFontSize];
    lineTwo.text = [self.model instructionLineTwoForPage:pageNumber];
    [self.scrollView addSubview:lineTwo];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - Scroll View Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Get the current instruction page number
    NSInteger currentPage = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    
    // Set the page control to reflect the current page
    self.pageControl.currentPage = currentPage;
    

}


@end
