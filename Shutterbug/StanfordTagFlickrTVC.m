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


@interface StanfordTagFlickrTVC ()

@end

@implementation StanfordTagFlickrTVC

-(NSArray *)tags
{
    if (!_tags)
    {
        _tags = [self processPhotosTags];
    }
    return _tags;
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
    self.allPhotos = [FlickrFetcher stanfordPhotos];
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
    return result;
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
        return [NSString stringWithFormat:@"%d", [tagInfo.photoIDs count]];
    }
    return @"?";
}


@end
