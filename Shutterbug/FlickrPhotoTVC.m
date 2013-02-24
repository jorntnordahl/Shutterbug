//
//  FlickrPhotoTVCViewController.m
//  Shutterbug
//
//  Created by Jorn Nordahl on 2/21/13.
//  Copyright (c) 2013 Jorn Nordahl. All rights reserved.
//

#import "FlickrPhotoTVC.h"
#import "FlickrFetcher.h"
#import "RecentInfo.h"

@interface FlickrPhotoTVC ()

@end

@implementation FlickrPhotoTVC


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath)
        {
            if ([segue.identifier isEqualToString:@"Show Image"])
            {
                if ([segue.destinationViewController respondsToSelector:@selector(setImageURL:)])
                {
                    NSURL *url = [FlickrFetcher urlForPhoto:self.photos[indexPath.row] format:FlickrPhotoFormatLarge];
                    
                    [segue.destinationViewController performSelector:@selector(setImageURL:) withObject: url];
                    [segue.destinationViewController setTitle:[self titleForRow:indexPath.row]];
                    
                    NSDictionary *photoDictionary = self.photos[indexPath.row];
                    [[RecentInfo class]addToRecent:photoDictionary];
                }
            }
        }
    }
}

-(void) setPhotos:(NSArray *)photos
{
    NSArray *sortedArray;
    sortedArray = [photos sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = ((NSDictionary *)a)[FLICKR_PHOTO_TITLE];
        NSString *second = ((NSDictionary *)b)[FLICKR_PHOTO_TITLE];
        return [first compare:second];
    }];
    
    _photos = sortedArray;
    [self.tableView reloadData];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfPhotos = [self.photos count];
    return numberOfPhotos;
}

-(NSString *) titleForRow:(NSUInteger) row
{
    return [self.photos[row][FLICKR_PHOTO_TITLE] description];
}

-(NSString *) subtitleForRow:(NSUInteger) row
{
    return [self.photos[row][FLICKR_PHOTO_OWNER] description];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // abstract ....
    
    static NSString *CellIdentifier = @"FlickrPhoto";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self titleForRow:indexPath.row];
    cell.detailTextLabel.text = [self subtitleForRow:indexPath.row];
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
