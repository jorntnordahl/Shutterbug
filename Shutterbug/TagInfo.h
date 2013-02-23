//
//  TagInfo.h
//  Shutterbug
//
//  Created by Jorn Nordahl on 2/22/13.
//  Copyright (c) 2013 Jorn Nordahl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagInfo : NSObject

@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) NSMutableArray *photoIDs;

@end
