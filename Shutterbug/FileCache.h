//
//  FileCache.h
//  Shutterbug
//
//  Created by Jorn Nordahl on 2/28/13.
//  Copyright (c) 2013 Jorn Nordahl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileCache : NSObject


+(BOOL)storeFile:(NSData*)file withName:(NSString*)name atDirectory:(NSString*)dir;
+(BOOL) deleteFileFromCache:(NSData *) file atDirector:(NSString *) dir;
+(BOOL) isFileInCache:(NSString *) file atDirectory:(NSString *) dir;
+(NSData *) getFileFromCache:(NSString *) name atDirectory:(NSString *) dir;

@end
