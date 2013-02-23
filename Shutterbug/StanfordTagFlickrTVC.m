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


/*-(void) setTags:(NSDictionary *)tags
{
    NSLog(@"Tags %@", tags);
    _tags = tags;
}*/

-(NSArray *)tags
{
    if (!_tags)
    {
        _tags = [self processPhotosTags];
    }
    return _tags;
}

/*-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"View will appear");
    //self.tags = [self processPhotosTags];
}*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    //NSLog(@"View did load");
    self.photos = [FlickrFetcher stanfordPhotos];
}

-(NSArray *) processPhotosTags
{
    NSMutableDictionary *photoTags = [[NSMutableDictionary alloc]init];
    
    // if we have photos to use:
    if (self.photos)
    {
        for (NSDictionary *photoInfo in self.photos)
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
            NSLog(@"Transforming: %@", key);
            NSLog(@"IDs: %@", obj.photoIDs);
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
        // TODO: Need to uppercase the first character
        return tagInfo.tag;
    }
    return @"?";
}

-(NSString *) subtitleForRow:(NSUInteger) row
{
    TagInfo *tagInfo = (TagInfo *)[self.tags objectAtIndex:row];
    if (tagInfo)
    {
        // TODO: Need to uppercase the first character
        NSArray *photoIDs = tagInfo.photoIDs;
        NSLog(@"IDs: %@", photoIDs);
        return [NSString stringWithFormat:@"%d", [tagInfo.photoIDs count]];
    }
    return @"?";
}


@end
