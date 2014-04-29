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

- (NSString *)imagePathForKey:(NSString *)key;

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

#pragma mark - Images

- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
    self.imageDictionary[key] = image;
    
    // Create full path for image
    NSString *imagePath = [self imagePathForKey:key];
    
    // Turn image into JPEG data
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    
    // Write it to full path
    [data writeToFile:imagePath atomically:YES];
}

- (UIImage *)imageForKey:(NSString *)key
{
    // If possible, get it from the dictionary
    UIImage *result = self.imageDictionary[key];
    
    if (!result) {
        NSString *imagePath = [self imagePathForKey:key];
        
        // Create UIImage object from file
        result = [UIImage imageWithContentsOfFile:imagePath];
        
        // If we found an image on the file system, place it into the cache
        if (result) {
            self.imageDictionary[key] = result;
        }
        else {
            NSLog(@"Error: unable to find %@", [self imagePathForKey:key]);
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
    
    NSString *imagePath = [self imagePathForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath
                                               error:nil];
}

- (NSString *)imagePathForKey:(NSString *)key
{
    NSArray *documentDirectories =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    
    NSString *documentDirectory = [documentDirectories firstObject];
    NSString *imagesDirectory = [documentDirectory stringByAppendingPathComponent:@"images"];
    
    return [imagesDirectory stringByAppendingPathComponent:key];
}


#pragma mark - Videos

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
    NSArray *documentDirectories =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    
    NSString *documentDirectory = [documentDirectories firstObject];
    NSString *videosDirectory = [documentDirectory stringByAppendingPathComponent:@"videos"];
    
    return [NSURL URLWithString:[videosDirectory stringByAppendingPathComponent:key]];
}

- (void)deleteVideoForKey:(NSString *)key
{
    if (!key) {
        return;
    }
    
    NSURL *videoURL = [self videoURLForKey:key];
    [[NSFileManager defaultManager] removeItemAtURL:videoURL error:nil];
}

- (void)clearCache:(NSNotification *)note
{
    NSLog(@"flushing %ld images out of the cache", [self.imageDictionary count]);
    [self.imageDictionary removeAllObjects];
}

@end
