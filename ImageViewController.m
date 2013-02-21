//
//  ImageViewController.m
//  Shutterbug
//
//  Created by Jorn Nordahl on 2/21/13.
//  Copyright (c) 2013 Jorn Nordahl. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation ImageViewController


-(void) setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    [self resetImage];
}

-(void) resetImage
{
    if (self.scrollView)
    {
        // clear whatever is thtere
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        
        // go out to the web and get the image:
        
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:self.imageURL];
        
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        if (image)
        {
            self.scrollView.contentSize = image.size;
            self.imageView.image = image;
            self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        }
    }
}

-(UIImageView *) imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _imageView;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.scrollView addSubview:self.imageView];
    [self resetImage];
}



@end
