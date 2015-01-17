//
//  MainViewController.m
//  Pictaphone
//
//  Created by Kelly Hutchison on 11/5/14.
//  Copyright (c) 2014 Kelly Hutchison. All rights reserved.
//

#import "MainViewController.h"
#import "model.h"

@interface MainViewController ()
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
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithRed:255 green:239 blue:100 alpha:0.96]];
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
