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


/*-(void) setTags:(NSDictionary *)tags
{
    NSLog(@"Tags %@", tags);
    _tags = tags;
}*/

-(NSDictionary *)tags
{
    if (!_tags)
    {
        _tags = [self processPhotosTags];
    }
    return _tags;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"View will appear");
    //self.tags = [self processPhotosTags];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"View did load");
    self.photos = [FlickrFetcher stanfordPhotos];
}

-(NSDictionary *) processPhotosTags
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
            //NSLog(@"Photo: %@", photoID);
            
            for (NSString *tag in tagList)
            {
                //NSLog(@"Tag %@", tag);
            
                if ([photoTags objectForKey:tag] == nil)
                {
                    // new tag in list, create a new array for the photo id, and add the tag and photo id array to dictionary
                    NSMutableArray *photoIDList = [[NSMutableArray alloc] init];
                    [photoIDList addObject:photoID];
                    
                    // now add the list to dictionary:
                    [photoTags setValue:photoIDList forKey:tag];
                }
                else
                {
                    // this tag is already in the list, so just get the array out, and add this photo id to that tag
                    NSMutableArray *photoIDList = [photoTags valueForKey:tag];
                    [photoIDList addObject:photoID];
                }
            }
        }
    }
    
    NSLog(@"Resulting Dictionary %@", photoTags);
    
    // here, loop over the photos, extracting each tag from the list.
    // the tag will be the key in the photo tags dictionary and the id of the photo will go into the
    // array in the dictionary value field. Each photo's id can have multiple tags so the photo id will show up in the array more than one
    // time...
    
    return photoTags;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [self.tags count];
    
    NSInteger numberofTags = [self.tags count];
    NSLog(@"Number of Tags %d", numberofTags);
    return numberofTags;
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
    
    [self.tags value]
    
    return @"1";
    //return [self.tags[row][FLICKR_PHOTO_TITLE] description];
}

-(NSString *) subtitleForRow:(NSUInteger) row
{
    return @"2";
    //return [self.tags[row][FLICKR_PHOTO_OWNER] description];
}


@end
