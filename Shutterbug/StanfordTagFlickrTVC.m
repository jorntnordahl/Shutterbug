//
//  StanfordTagFlickrTVC.m
//  Shutterbug
//
//  Created by Jorn Nordahl on 2/22/13.
//  Copyright (c) 2013 Jorn Nordahl. All rights reserved.
//

#import "StanfordTagFlickrTVC.h"
#import "FlickrFetcher.h"

@interface StanfordTagFlickrTVC ()

@end

@implementation StanfordTagFlickrTVC


-(void) setTags:(NSMutableDictionary *)tags
{
    NSLog(@"Tags %@", tags);
    _tags = tags;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.photos = [FlickrFetcher stanfordPhotos];
    self.tags = [self processPhotosTags];
}

-(NSDictionary *) processPhotosTags
{
    NSMutableDictionary *photoTags = [[NSMutableDictionary alloc]init];
    
    // here, loop over the photos, extracting each tag from the list.
    // the tag will be the key in the photo tags dictionary and the id of the photo will go into the
    // array in the dictionary value field. Each photo's id can have multiple tags so the photo id will show up in the array more than one
    // time...
    
    return photoTags;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    /*
    NSInteger numberOfPhotos = [self.photos count];
    NSLog(@"Number %d", numberOfPhotos);
    return numberOfPhotos;*/
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FlickrTag";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self titleForRow:indexPath.row];
    cell.detailTextLabel.text = [self subtitleForRow:indexPath.row];
    
    return cell;
}

-(NSString *) titleForRow:(NSUInteger) row
{
    return @"1";
    //return [self.tags[row][FLICKR_PHOTO_TITLE] description];
}

-(NSString *) subtitleForRow:(NSUInteger) row
{
    return @"2";
    //return [self.tags[row][FLICKR_PHOTO_OWNER] description];
}


@end
