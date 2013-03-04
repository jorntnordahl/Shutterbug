//
//  FileCache.m
//  Shutterbug
//
//  Created by Jorn Nordahl on 2/28/13.
//  Copyright (c) 2013 Jorn Nordahl. All rights reserved.
//

#import "FileCache.h"

@implementation FileCache

#define MAX_CACHE_SIZE 5

+(NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+(NSData *) getFileFromCache:(NSString *) name atDirectory:(NSString *) dir
{
    NSString *docsDir = [FileCache applicationDocumentsDirectory];
    NSString *fileName = [[docsDir stringByAppendingPathComponent:dir] stringByAppendingPathComponent:name];
    return [[NSData alloc] initWithContentsOfFile:fileName];
}

+(BOOL)storeFile:(NSData*)file withName:(NSString*)name atDirectory:(NSString*)dir{
    
    NSFileManager *filemgr =[NSFileManager defaultManager];
    NSString *docsDir = [FileCache applicationDocumentsDirectory];
    NSString *newDir= [docsDir stringByAppendingPathComponent:dir];

    BOOL create=NO;
    
    if(![filemgr fileExistsAtPath:newDir]){
        if([filemgr createDirectoryAtPath:newDir withIntermediateDirectories:NO attributes:nil  error:nil]){
            create=YES;
        }
    }else
        create=YES;
    
    NSString *fileName = [newDir stringByAppendingPathComponent:name];
    
    if(create){
        if(![filemgr createFileAtPath:fileName contents:file attributes:nil]){
            return YES;
        }
    }
    
    [self purgeOldFiles:dir];
    
    
    return NO;
}

+(void) purgeOldFiles:(NSString *) dir
{
    NSString *docsDir = [[FileCache applicationDocumentsDirectory] stringByAppendingPathComponent:dir];
    NSArray *sortedFiles = [self filesByModDate:docsDir];
    
    if (sortedFiles)
    {
        if ([sortedFiles count] > MAX_CACHE_SIZE)
        {
            
            // For each file in the directory, create full path and delete the file
            int deleteCount = ([sortedFiles count] - MAX_CACHE_SIZE);
            for (NSDictionary *fileProps in sortedFiles)
            {
                NSString *file = [fileProps valueForKey:@"path"];
                NSLog(@"File : %@", file);
                
                BOOL fileDeleted = [self deleteFileFromCache:file atDirectory:docsDir];
                if (fileDeleted)
                {
                    NSLog(@"File Deleted");
                }
                else
                {
                    NSLog(@"File not deleted..");
                }
                
                deleteCount--;
                
                if (deleteCount == 0)
                {
                    break;
                }
            }
        }
    }
}

/*NSInteger lastModifiedSort(id path1, id path2, void* context)
{
    int comp = [[path1 objectForKey:@"lastModDate"] compare:
                [path2 objectForKey:@"lastModDate"]];
    return comp;
}*/

+(NSArray *)filesByModDate:(NSString*) path{
    
    NSError* error = nil;
    
    NSArray* filesArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path
                                                                              error:&error];
    if(error == nil)
    {
        NSMutableArray* filesAndProperties = [NSMutableArray arrayWithCapacity:[filesArray count]];
        
        for(NSString* imgName in filesArray)
        {
            
            NSString *imgPath = [NSString stringWithFormat:@"%@/%@",path,imgName];
            NSDictionary* properties = [[NSFileManager defaultManager]
                                        attributesOfItemAtPath:imgPath
                                        error:&error];
            
            NSDate* modDate = [properties objectForKey:NSFileModificationDate];
            
            if(error == nil)
            {
                [filesAndProperties addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                               imgName, @"path",
                                               modDate, @"lastModDate",
                                               nil]];
            }else{
                NSLog(@"%@",[error description]);
            }
        }
        //NSArray* sortedFiles = [filesAndProperties sortedArrayUsingFunction:&lastModifiedSort context:nil];
        
        NSArray *sortedFiles;
        sortedFiles = [filesAndProperties sortedArrayUsingComparator:^NSComparisonResult(id path1, id path2) {
            
            int comp = [[path1 objectForKey:@"lastModDate"] compare:
                        [path2 objectForKey:@"lastModDate"]];
            return comp;
            
            
            //NSDate *first = [(Person*)a birthDate];
            //NSDate *second = [(Person*)b birthDate];
            //return [first compare:second];
        }];
        
        NSLog(@"sortedFiles: %@", sortedFiles);
        return sortedFiles;
    }
    else
    {
        NSLog(@"Encountered error while accessing contents of %@: %@", path, error);
    }
    
    return filesArray;
}

+(BOOL) deleteFileFromCache:(NSString *) fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:fileName error:NULL];
}

+(BOOL) deleteFileFromCache:(NSString *) name atDirectory:(NSString *) dir
{
    //NSString *docsDir = [FileCache applicationDocumentsDirectory];
    NSString *fileName = [dir stringByAppendingPathComponent:name];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:fileName error:NULL];
}

+(BOOL) isFileInCache:(NSString *) name atDirectory:(NSString *) dir
{
    NSString *docsDir = [FileCache applicationDocumentsDirectory];
    NSString* fileName = [[docsDir stringByAppendingPathComponent:dir]stringByAppendingPathComponent:name];
    return [[NSFileManager defaultManager] fileExistsAtPath:fileName];
}

@end
