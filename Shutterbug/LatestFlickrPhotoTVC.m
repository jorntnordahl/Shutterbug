//
//  LatestFlickrPhotoTVC.m
//  Shutterbug
//
//  Created by Jorn Nordahl on 2/21/13.
//  Copyright (c) 2013 Jorn Nordahl. All rights reserved.
//

#import "LatestFlickrPhotoTVC.h"
#import "FlickrFetcher.h"

@implementation LatestFlickrPhotoTVC

-(void) viewDidLoad
{
    [super viewDidLoad];
    self.photos = [FlickrFetcher latestGeoreferencedPhotos];
}
@end
