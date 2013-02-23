//
//  StanfordTagFlickrTVC.h
//  Shutterbug
//
//  Created by Jorn Nordahl on 2/22/13.
//  Copyright (c) 2013 Jorn Nordahl. All rights reserved.
//

#import "FlickrPhotoTVC.h"

@interface StanfordTagFlickrTVC : FlickrPhotoTVC

@property (nonatomic, strong) NSArray *allPhotos;
@property (nonatomic, strong) NSArray *tags; // of String - Tag, to Array of Photo IDs representing the Photo using that tag.

@end
