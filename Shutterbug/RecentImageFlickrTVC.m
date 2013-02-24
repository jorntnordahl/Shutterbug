//
//  RecentImageFlickrTVC.m
//  Shutterbug
//
//  Created by Jorn Nordahl on 2/23/13.
//  Copyright (c) 2013 Jorn Nordahl. All rights reserved.
//

#import "RecentImageFlickrTVC.h"
#import "FlickrFetcher.h"
#import "RecentInfo.h"

@interface RecentImageFlickrTVC ()

@end

@implementation RecentImageFlickrTVC


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath)
        {
            if ([segue.identifier isEqualToString:@"Show Recent Image"])
            {
                if ([segue.destinationViewController respondsToSelector:@selector(setImageURL:)])
                {
                    NSString *urlAsString = self.recentPhotos[indexPath.row][@"url"];
                    NSURL *url = [NSURL URLWithString:urlAsString];
                      
                    [segue.destinationViewController performSelector:@selector(setImageURL:) withObject: url];
                    [segue.destinationViewController setTitle:[self titleForRow:indexPath.row]];
                }
            }
        }
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	self.recentPhotos = [[RecentInfo class] getRecentPhotos];
}

-(void) setRecentPhotos:(NSArray *)recentPhotos
{
    _recentPhotos = recentPhotos;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfPhotos = [self.recentPhotos count];
    return numberOfPhotos;
}

-(NSString *) titleForRow:(NSUInteger) row
{
    return [self.recentPhotos[row][FLICKR_PHOTO_TITLE] description];
}

-(NSString *) subtitleForRow:(NSUInteger) row
{
    return [self.recentPhotos[row][@"description"] description];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RecentPhoto";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self titleForRow:indexPath.row];
    cell.detailTextLabel.text = [self subtitleForRow:indexPath.row];
    
    return cell;
}

@end
