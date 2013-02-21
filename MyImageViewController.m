//
//  MyImageViewController.m
//  Shutterbug
//
//  Created by Jorn Nordahl on 2/21/13.
//  Copyright (c) 2013 Jorn Nordahl. All rights reserved.
//

#import "MyImageViewController.h"

@interface MyImageViewController ()

@end

@implementation MyImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.imageURL = [[NSURL alloc] initWithString:@"http://images.apple.com/v/iphone/gallery/a/images/photo_3.jpg"];
}


@end
