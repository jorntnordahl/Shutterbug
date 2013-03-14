//
//  StanfordFlickrTVC.m
//  Shutterbug
//
//  Created by Jorn Nordahl on 2/22/13.
//  Copyright (c) 2013 Jorn Nordahl. All rights reserved.
//

#import "StanfordImageFlickrTVC.h"
#import "FlickrFetcher.h"

@interface StanfordImageFlickrTVC ()

@end

@implementation StanfordImageFlickrTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FlickrPhoto";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self titleForRow:indexPath.row];
    cell.detailTextLabel.text = [self subtitleForRow:indexPath.row];
    cell.imageView.image = [self thumbNailForRow:indexPath.row];
    return cell;
}

-(UIImage *) thumbNailForRow:(NSUInteger) row
{
    NSURL *url = [FlickrFetcher urlForPhoto:self.photos[row] format:FlickrPhotoFormatSquare];
    
    //[[NetworkActivityUtil class] setNetworkActivityIndicatorVisible:YES];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:url];
    //[[NetworkActivityUtil class] setNetworkActivityIndicatorVisible:NO];
    
    UIImage *image = [[UIImage alloc] initWithData:imageData];    
    return image;
}

-(NSString *) titleForRow:(NSUInteger) row
{
    return [self.photos[row][FLICKR_PHOTO_TITLE] description];
}

-(NSString *) subtitleForRow:(NSUInteger) row
{
    return self.photos[row][@"description"][@"_content"];
}


@end
