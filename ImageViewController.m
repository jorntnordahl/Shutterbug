//
//  ImageViewController.m
//  Shutterbug
//
//  Created by Jorn Nordahl on 2/21/13.
//  Copyright (c) 2013 Jorn Nordahl. All rights reserved.
//


#import "ImageViewController.h"


@interface ImageViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@end


@implementation ImageViewController


#define MAX_ZOOM_SCALE 2.0


-(void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    [self resetImage];
}


-(void)resetImage
{
    if (self.scrollView) {
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        
        
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:self.imageURL];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        if (image){
            self.scrollView.contentSize = image.size;
            self.imageView.image = image;
            self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        }
    }
}


- (UIImageView *) imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    return _imageView;
}


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
    self.scrollView.minimumZoomScale = 0.1;
    self.scrollView.maximumZoomScale = MAX_ZOOM_SCALE;
    self.scrollView.delegate = self;
    [self resetImage];
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    
    //We need to find the lesser minimum that still shows the whole picture
    float heightZoomMin = self.scrollView.bounds.size.height / self.imageView.image.size.height;
    float widthZoomMin  = self.scrollView.bounds.size.width  / self.imageView.image.size.width;
    //Zoom to the lesser level to see the whole picture
    self.scrollView.zoomScale = (widthZoomMin > heightZoomMin) ? heightZoomMin : widthZoomMin;
    //Also set the minimum to the lesser level, so there is only background visible on the botom or side but never both
    self.scrollView.minimumZoomScale = self.scrollView.zoomScale;
    
    
    //Just in case we get an image with less pixels than our view area, set the minZoom to 1.0
    if (self.scrollView.minimumZoomScale > MAX_ZOOM_SCALE ) {
        self.scrollView.minimumZoomScale = 1;
    }
    
    
    //Log out the important paramaters
    NSLog(@"viewDidLayoutSubviews - Width: %d, Height: %d, Min Zoom Scale: %f",
          (int)self.imageView.image.size.width,
          (int)self.imageView.image.size.height,
          self.scrollView.minimumZoomScale);
}


@end