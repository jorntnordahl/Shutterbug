//
//  RecentInfo.m
//  Shutterbug
//
//  Created by Jorn Nordahl on 2/23/13.
//  Copyright (c) 2013 Jorn Nordahl. All rights reserved.
//

#import "RecentInfo.h"
#import "FlickrFetcher.h"

@implementation RecentInfo

#define RECENTS_LENGTH 50

+(void) addToRecent:(NSDictionary *)photo
{
    NSDictionary *recentPhoto = [[NSMutableDictionary alloc]
                                 initWithDictionary:@{
                                 FLICKR_PHOTO_TITLE: photo[FLICKR_PHOTO_TITLE],
                                 FLICKR_PHOTO_ID : photo[FLICKR_PHOTO_ID],
                                 FLICKR_PHOTO_OWNER : photo[FLICKR_PHOTO_OWNER],
                                 @"url" : [[FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatLarge] absoluteString],
                                 @"description" : photo[@"description"][@"_content"]}];

    NSMutableArray *recents = [[RecentInfo getRecentPhotos] mutableCopy];
    for (NSDictionary *photo in recents) {
        if ([photo[FLICKR_PHOTO_ID] isEqualToString:recentPhoto[FLICKR_PHOTO_ID]]) {
            NSUInteger index = [recents indexOfObject:photo];
            [recents removeObjectAtIndex:index];
            break;
        }
    }
    [recents insertObject:recentPhoto atIndex:0];
    if ([recents count] > RECENTS_LENGTH) {
        [recents removeObjectAtIndex:RECENTS_LENGTH];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[recents copy] forKey:@"Recents"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
}

+ (NSArray *)getRecentPhotos
{
    NSArray *recents = [[NSUserDefaults standardUserDefaults] arrayForKey:@"Recents"];
    if (!recents) {
        recents = [[NSArray alloc] init];
    }
    return recents;
}


@end
