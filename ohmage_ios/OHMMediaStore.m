//
//  OHMImageStore.m
//  ohmage_ios
//
//  Created by Charles Forkish on 4/27/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMMediaStore.h"

@interface OHMMediaStore ()

@property (nonatomic, strong) NSMutableDictionary *imageDictionary;
@property (nonatomic, strong) NSMutableDictionary *audioDictionary;

@end

@implementation OHMMediaStore

+ (instancetype)sharedStore
{
    static OHMMediaStore *sharedStore = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    return sharedStore;
}

// No one should call init
- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[OHMImageStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

// Secret designated initializer
- (instancetype)initPrivate
{
    self = [super init];
    
    if (self) {
        self.imageDictionary = [[NSMutableDictionary alloc] init];
        self.audioDictionary = [[NSMutableDictionary alloc] init];
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(clearCache:)
                   name:UIApplicationDidReceiveMemoryWarningNotification
                 object:nil];
    }
    
    return self;
}

- (void)clearCache:(NSNotification *)note
{
    NSLog(@"flushing %ld images out of the cache", (unsigned long)[self.imageDictionary count]);
    [self.imageDictionary removeAllObjects];
}

#pragma mark - Images

- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
    self.imageDictionary[key] = image;
    
    // Create full path for image
    NSString *imagePath = [[self imageURLForKey:key] path];
    
    // Turn image into JPEG data
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    
    // Write it to full path
    BOOL success = [data writeToFile:imagePath atomically:YES];
    NSLog(@"write image to path: %@, success: %d", imagePath, success);
}

- (UIImage *)imageForKey:(NSString *)key
{
    // If possible, get it from the dictionary
    UIImage *result = self.imageDictionary[key];
    
    if (!result) {
        NSString *imagePath = [[self imageURLForKey:key] path];
        
        
        // Create UIImage object from file
        result = [UIImage imageWithContentsOfFile:imagePath];
        
        // If we found an image on the file system, place it into the cache
        if (result) {
            self.imageDictionary[key] = result;
        }
        else {
            NSLog(@"Error: unable to find %@", imagePath);
        }
    }
    return result;
}

- (void)deleteImageForKey:(NSString *)key
{
    if (!key) {
        return;
    }
    [self.imageDictionary removeObjectForKey:key];
    
    NSURL *imageURL = [self imageURLForKey:key];
    [[NSFileManager defaultManager] removeItemAtURL:imageURL error:nil];
}

- (NSURL *)imageURLForKey:(NSString *)key
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSURL *documentsFolderUrl =
    [fileManager URLForDirectory:NSDocumentDirectory
                        inDomain:NSUserDomainMask
               appropriateForURL:nil
                          create:NO
                           error:nil];
    
    NSURL *imagesFolderUrl = [documentsFolderUrl URLByAppendingPathComponent:@"images" isDirectory:YES];
    BOOL success = [fileManager createDirectoryAtURL:imagesFolderUrl withIntermediateDirectories:YES attributes:nil error:nil];
    if (!success) {
        NSLog(@"Error creating audio directory");
        return nil;
    }
    
    NSString *fileName = [key stringByAppendingPathExtension:@"mp4"];
    return [imagesFolderUrl URLByAppendingPathComponent:fileName];
}


#pragma mark - Video

- (void)setVideoWithURL:(NSURL *)tempVideoURL forKey:(NSString *)key
{
    // Create full path for video
    NSURL *storeVideoURL = [self videoURLForKey:key];
    
    NSError *error = NULL;
    [[NSFileManager defaultManager] moveItemAtURL:tempVideoURL toURL:storeVideoURL error:&error];
    if (error != nil) {
        NSLog(@"Error moving video to media store. Temp URL: %@, store URL: %@, error: %@", tempVideoURL, storeVideoURL, [error localizedDescription]);
    }
}

- (NSURL *)videoURLForKey:(NSString *)key
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSURL *documentsFolderUrl =
    [fileManager URLForDirectory:NSDocumentDirectory
                        inDomain:NSUserDomainMask
               appropriateForURL:nil
                          create:NO
                           error:nil];
    
    NSURL *videoFolderUrl = [documentsFolderUrl URLByAppendingPathComponent:@"videos" isDirectory:YES];
    BOOL success = [fileManager createDirectoryAtURL:videoFolderUrl withIntermediateDirectories:YES attributes:nil error:nil];
    if (!success) {
        NSLog(@"Error creating audio directory");
        return nil;
    }
    
    NSString *fileName = [key stringByAppendingPathExtension:@"mp4"];
    return [videoFolderUrl URLByAppendingPathComponent:fileName];
}

- (void)deleteVideoForKey:(NSString *)key
{
    if (!key) {
        return;
    }
    
    NSURL *videoURL = [self videoURLForKey:key];
    [[NSFileManager defaultManager] removeItemAtURL:videoURL error:nil];
}


#pragma mark - Audio

- (void)setAudioWithURL:(NSURL *)tempAudioURL forKey:(NSString *)key
{
    // Create full path for audio
    NSURL *storeAudioURL = [self audioURLForKey:key];
    
    NSError *error = NULL;
    [[NSFileManager defaultManager] moveItemAtURL:tempAudioURL toURL:storeAudioURL error:&error];
    if (error != nil) {
        NSLog(@"Error moving audio to media store. Temp URL: %@, store URL: %@, error: %@", tempAudioURL, storeAudioURL, [error localizedDescription]);
    }
}

- (NSURL *)audioURLForKey:(NSString *)key
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSURL *documentsFolderUrl =
    [fileManager URLForDirectory:NSDocumentDirectory
                        inDomain:NSUserDomainMask
               appropriateForURL:nil
                          create:NO
                           error:nil];
    
    NSURL *audioFolderUrl = [documentsFolderUrl URLByAppendingPathComponent:@"audio" isDirectory:YES];
    BOOL success = [fileManager createDirectoryAtURL:audioFolderUrl withIntermediateDirectories:YES attributes:nil error:nil];
    if (!success) {
        NSLog(@"Error creating audio directory");
        return nil;
    }
    
    NSString *fileName = [key stringByAppendingPathExtension:@"m4a"];
    return [audioFolderUrl URLByAppendingPathComponent:fileName];
}

- (void)deleteAudioForKey:(NSString *)key
{
    if (!key) {
        return;
    }
    
    NSURL *audioURL = [self audioURLForKey:key];
    [[NSFileManager defaultManager] removeItemAtURL:audioURL error:nil];
}

@end
