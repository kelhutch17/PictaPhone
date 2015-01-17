//
//  KMHCustomUnwindSegue.m
//  Pictaphone
//
//  Created by Kelly Hutchison on 11/22/14.
//  Copyright (c) 2014 Kelly Hutchison. All rights reserved.
//

#import "KMHCustomUnwindSegue.h"

@implementation KMHCustomUnwindSegue

- (instancetype)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination
{
    self = [super initWithIdentifier:identifier source:source destination:destination];
    if (self) {
        
    }
    return self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}


// ABCustomUnwindSegue.m
- (void)perform
{
    UIView *sv = ((UIViewController *)self.sourceViewController).view;
    UIView *dv = ((UIViewController *)self.destinationViewController).view;
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    dv.center = CGPointMake(sv.center.x - sv.frame.size.width, dv.center.y);
    [window insertSubview:dv belowSubview:sv];
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         dv.center = CGPointMake(sv.center.x,
                                                 dv.center.y);
                         sv.center = CGPointMake(sv.center.x + sv.frame.size.width,
                                                 dv.center.y);
                     }
                     completion:^(BOOL finished){
                         [[self destinationViewController]
                          dismissViewControllerAnimated:NO completion:nil];
                     }];
}

@end
