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

/*-(void) setPhotos: (NSArray *) photos
{
    self.photos = photos;
}*/

- (void)viewDidLoad
{
    [super viewDidLoad];
	//self.photos = [FlickrFetcher stanfordPhotos];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FlickrPhoto";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self titleForRow:indexPath.row];
    cell.detailTextLabel.text = [self subtitleForRow:indexPath.row];
    
    return cell;
}

-(NSString *) titleForRow:(NSUInteger) row
{
    return [self.photos[row][FLICKR_PHOTO_TITLE] description];
}

-(NSString *) subtitleForRow:(NSUInteger) row
{
    return [self.photos[row][FLICKR_PHOTO_OWNER] description];
}


@end
