//
//  StanfordTagFlickrTVC.m
//  Shutterbug
//
//  Created by Jorn Nordahl on 2/22/13.
//  Copyright (c) 2013 Jorn Nordahl. All rights reserved.
//

#import "StanfordTagFlickrTVC.h"
#import "FlickrFetcher.h"
#import "TagInfo.h"
#import "PhotoInfo.h"
#import "SpotUtil.h"


@interface StanfordTagFlickrTVC ()

@end

@implementation StanfordTagFlickrTVC

-(void) setTags:(NSArray *)tags
{
    _tags = tags;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath)
        {
            if ([segue.identifier isEqualToString:@"Show Images for Tag"])
            {
                if ([segue.destinationViewController respondsToSelector:@selector(setPhotos:)])
                {
                    TagInfo *tagInfo = self.tags[indexPath.row];
                
                    NSArray *photoList = [self fetchPhotosForTag:tagInfo];
                    
                    [segue.destinationViewController performSelector:@selector(setPhotos:) withObject:photoList];
                    [segue.destinationViewController setTitle:[self titleForRow:indexPath.row]];
                }
            }
        }
    }
}

-(NSArray *) fetchPhotosForTag: (TagInfo *) tagInfo
{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    
    // loop on all the photos and return all the photos that exist in the list:
    NSString *tag = tagInfo.tag;
    for (NSDictionary *photoInfo in self.allPhotos)
    {
        NSString *tags = [photoInfo valueForKey:FLICKR_TAGS];
        
        if ([tags rangeOfString:tag].location == NSNotFound) {
            // not found
        } else {
            [result addObject:photoInfo];
        }
    }
    
    return result;
}

-(void) setAllPhotos:(NSArray *)photos
{
    _allPhotos = photos;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.refreshControl addTarget:self
                            action:@selector(refreshTablePulled)
                  forControlEvents:UIControlEventValueChanged];
    [self fetchImages];
}

-(void) fetchImages
{
    [self.refreshControl beginRefreshing];
   
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("stanford downloader", NULL);
    dispatch_async(downloadQueue, ^{
        
        [[SpotUtil class] setNetworkActivityIndicatorVisible:YES];
        self.allPhotos = [FlickrFetcher stanfordPhotos];
        [[SpotUtil class] setNetworkActivityIndicatorVisible:NO];
        
        self.tags = [self processPhotosTags];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
            
            [self.refreshControl endRefreshing];
        });
    });

    
}

-(NSArray *) hiddenTags
{
    return @[@"cs193pspot", @"portrait", @"landscape"];
}

-(NSArray *) processPhotosTags
{
    NSMutableDictionary *photoTags = [[NSMutableDictionary alloc]init];
    
    // if we have photos to use:
    if (self.allPhotos)
    {
        for (NSDictionary *photoInfo in self.allPhotos)
        {
            NSString *photoID = [photoInfo valueForKey:FLICKR_PHOTO_ID];
            NSString *tags = [photoInfo valueForKey:FLICKR_TAGS];
            NSArray *tagList = [tags componentsSeparatedByString:@" "];
            
            for (NSString *tag in tagList)
            {
                if ([[self hiddenTags] containsObject:tag])
                {
                    // this is a tag we should hide per the homework
                    continue;
                }
                
                if ([photoTags objectForKey:tag] == nil)
                {
                    TagInfo *tagInfo = [[TagInfo alloc] init];
                    tagInfo.tag = tag;
                    [tagInfo.photoIDs addObject:photoID];
                    
                    // now add the list to dictionary:
                    [photoTags setValue:tagInfo forKey:tag];
                }
                else
                {
                    // this tag is already in the list, so just get the array out, and add this photo id to that tag
                    TagInfo *tagInfo = [photoTags valueForKey:tag];
                    [tagInfo.photoIDs addObject:photoID];
                }
            }
        }
    }

    return [self transformToArray:photoTags];
}

-(NSArray *) transformToArray:(NSDictionary *)sender
{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    if (sender)
    {
        [sender enumerateKeysAndObjectsUsingBlock:^(NSString *key, TagInfo *obj, BOOL *stop) {
            [result addObject:obj];
        }];
    }
    
    NSArray *sortedArray;
    sortedArray = [result sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(TagInfo*)a tag];
        NSString *second = [(TagInfo*)b tag];
        return [first compare:second];
    }];
    
    return sortedArray;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tags count];
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
    TagInfo *tagInfo = (TagInfo *)[self.tags objectAtIndex:row];
    if (tagInfo)
    {
        return [tagInfo.tag capitalizedString];
    }
    return @"?";
}

-(NSString *) subtitleForRow:(NSUInteger) row
{
    TagInfo *tagInfo = (TagInfo *)[self.tags objectAtIndex:row];
    if (tagInfo)
    {
        return [NSString stringWithFormat:@"%d photo%@", [tagInfo.photoIDs count], ([tagInfo.photoIDs count] == 1 ? @"": @"s")];
    }
    return @"?";
}

- (void)refreshTablePulled
{
    [self fetchImages];
}

/*- (void)setNetworkActivityIndicatorVisible:(BOOL)setVisible {
    static NSInteger NumberOfCallsToSetVisible = 0;
    if (setVisible)
        NumberOfCallsToSetVisible++;
    else
        NumberOfCallsToSetVisible--;
    
    // The assertion helps to find programmer errors in activity indicator management.
    // Since a negative NumberOfCallsToSetVisible is not a fatal error,
    // it should probably be removed from production code.
    NSAssert(NumberOfCallsToSetVisible >= 0, @"Network Activity Indicator was asked to hide more often than shown");
    
    // Display the indicator as long as our static counter is > 0.
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:(NumberOfCallsToSetVisible > 0)];
}*/

@end
