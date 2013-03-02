//
//  FileCache.m
//  Shutterbug
//
//  Created by Jorn Nordahl on 2/28/13.
//  Copyright (c) 2013 Jorn Nordahl. All rights reserved.
//

#import "FileCache.h"

@implementation FileCache

+(NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+(NSData *) getFileFromCache:(NSString *) name atDirectory:(NSString *) dir
{
    //NSFileManager *filemgr =[NSFileManager defaultManager];
    NSString *docsDir = [FileCache applicationDocumentsDirectory];
    NSString *fileName = [[docsDir stringByAppendingPathComponent:dir] stringByAppendingPathComponent:name];
    NSLog(@"Reading file: %@", fileName);

    NSData *imageData = [[NSData alloc] initWithContentsOfFile:fileName];
    NSLog(@"File Data? %s", (imageData ? "YES" : "NO"));
    
    return imageData;
}

+(BOOL)storeFile:(NSData*)file withName:(NSString*)name atDirectory:(NSString*)dir{
    
    NSFileManager *filemgr =[NSFileManager defaultManager];
    NSString *docsDir = [FileCache applicationDocumentsDirectory];
    NSString *newDir;
    BOOL create=NO;
    
    
    newDir = [docsDir stringByAppendingPathComponent:dir];
    
    if(![filemgr fileExistsAtPath:newDir]){
        if([filemgr createDirectoryAtPath:newDir withIntermediateDirectories:NO attributes:nil  error:nil]){
            create=YES;
        }
    }else
        create=YES;
    
    NSString *fileName = [newDir stringByAppendingPathComponent:name];
    
    if(create){
        if(![filemgr createFileAtPath:fileName contents:file attributes:nil]){
            //[filemgr release];
            return YES;
        }
    }
    
    //[filemgr release];
    return NO;
}


+(BOOL) deleteFileFromCache:(NSString *) name atDirector:(NSString *) dir
{
    NSString *docsDir = [FileCache applicationDocumentsDirectory];
    
    NSString *fileName = [[docsDir stringByAppendingPathComponent:dir] stringByAppendingPathComponent:name];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileRemoved = [fileManager removeItemAtPath:fileName error:NULL];
    
    return fileRemoved;
}
+(BOOL) isFileInCache:(NSString *) name atDirectory:(NSString *) dir
{
    NSString *docsDir = [FileCache applicationDocumentsDirectory];
    
    NSString* fileName = [[docsDir stringByAppendingPathComponent:dir]stringByAppendingPathComponent:name];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fileName];
    
    return fileExists;
    
    /*
     for (int i = 0; i < numberHere; ++i){
     NSFileManager* fileMgr = [NSFileManager defaultManager];
     NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
     NSString* imageName = [NSString stringWithFormat:@"image-%@.png", i];
     NSString* currentFile = [documentsDirectory stringByAppendingPathComponent:imageName];
     BOOL fileExists = [fileMgr fileExistsAtPath:currentFile];
     if (fileExists == NO){
     cout << "DOESNT Exist!" << endl;
     } else {
     cout << "DOES Exist!" << endl;
     }
     */
    
    
}
/*-(void) createDirectory:(NSString *) directory
{
    
}*/

@end
