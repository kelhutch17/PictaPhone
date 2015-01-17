//
//  KMHCustomSegue.m
//  Pictaphone
//
//  Created by Kelly Hutchison on 11/22/14.
//  Copyright (c) 2014 Kelly Hutchison. All rights reserved.
//

#import "KMHCustomSegue.h"
#import "DrawingViewController.h"
#import "TypingViewController.h"
#import "GameSetupViewController.h"


@implementation KMHCustomSegue

- (instancetype)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination
{
    self = [super initWithIdentifier:identifier source:source destination:destination];
    if (self) {
        
        }
    return self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // startGameSegue
    
}

- (void)perform
{
    // Add your own animation code here.
    UIView *sv = ((UIViewController *)self.sourceViewController).view;
    UIView *dv = ((UIViewController *)self.destinationViewController).view;
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    dv.center = CGPointMake(sv.center.x + sv.frame.size.width,
                            dv.center.y);
    [window insertSubview:dv aboveSubview:sv];
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         dv.center = CGPointMake(sv.center.x,
                                                 dv.center.y);
                         sv.center = CGPointMake(0 - sv.center.x,
                                                 dv.center.y);
                     }
                     completion:^(BOOL finished){
                         [[self sourceViewController] presentViewController:
                          [self destinationViewController] animated:NO completion:nil];
                     }];
}

@end
