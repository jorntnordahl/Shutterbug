//
//  RecentInfo.h
//  Shutterbug
//
//  Created by Jorn Nordahl on 2/23/13.
//  Copyright (c) 2013 Jorn Nordahl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentInfo : NSObject

+(void) addToRecent:(NSDictionary *)photo;
+ (NSArray *)getRecentPhotos;

@end
