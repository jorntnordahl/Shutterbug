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
    if (!cell.imageView.image)
    {
        // create empty image for cell so the cell doesn't move in when image appears:
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(36, 36), NO, 0.0);
        UIImage *blank = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cell.imageView.image = blank;
        
        [self thumbNailForRow:indexPath forCell:cell];
    }
    return cell;
}
 
-(void) thumbNailForRow:(NSIndexPath *) indexPath forCell:(UITableViewCell *) cell
{
    dispatch_queue_t downloadQueue = dispatch_queue_create("image square downloader", NULL);
    dispatch_async(downloadQueue, ^{
    
        NSURL *url = [FlickrFetcher urlForPhoto:self.photos[indexPath.row] format:FlickrPhotoFormatSquare];
        
        [[NetworkActivityUtil class] setNetworkActivityIndicatorVisible:YES];
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:url];
        [[NetworkActivityUtil class] setNetworkActivityIndicatorVisible:NO];
        
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        if (image)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image)
                {
                    {
                        cell.imageView.image = image;
                        NSArray* rowsToReload = [NSArray arrayWithObjects:indexPath, nil];
                        [self.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
                    }
                }
            });
        }
    });
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
