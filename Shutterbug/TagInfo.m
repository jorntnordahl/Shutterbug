//
//  TagInfo.m
//  Shutterbug
//
//  Created by Jorn Nordahl on 2/22/13.
//  Copyright (c) 2013 Jorn Nordahl. All rights reserved.
//

#import "TagInfo.h"

@implementation TagInfo

-(void) setTag:(NSString *)tag
{
    _tag = tag;
}

-(NSMutableArray *) photoIDs
{
    if (!_photoIDs)
    {
        _photoIDs = [[NSMutableArray alloc] init];
    }
    return _photoIDs;
}

@end
