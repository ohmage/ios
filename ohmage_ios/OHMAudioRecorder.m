//
//  OHMAudioRecorder.m
//  ohmage_ios
//
//  Created by Charles Forkish on 5/8/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMAudioRecorder.h"
#import <AVFoundation/AVFoundation.h>

@interface OHMAudioRecorder () <AVAudioPlayerDelegate, AVAudioRecorderDelegate>
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@end

@implementation OHMAudioRecorder

- (instancetype)initWithDelegate:(id<OHMAudioRecorderDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        
        /* Ask for permission to see if we can record audio */
        AVAudioSession *session = [AVAudioSession sharedInstance];
        
        NSError *error = nil;
        [session setCategory:AVAudioSessionCategoryPlayAndRecord
                 withOptions:AVAudioSessionCategoryOptionDuckOthers
                       error:&error];
        if (error) {
            NSLog(@"error setting audio session category: %@", error);
        }
        
        [session requestRecordPermission:^(BOOL granted) {
            _hasMicrophoneAccess = granted;
            [self.delegate OHMAudioRecorderMicrophoneAccessChanged:self];

        }];
    }
    return self;
}

- (BOOL)isRecording
{
    return (self.audioRecorder != nil);
}

- (BOOL)isPlaying
{
    return (self.audioPlayer != nil);
}

- (BOOL)startRecording
{
    
    NSError *error = nil;
    
    NSURL *audioRecordingURL = [self audioRecordingPath];
    
    self.audioRecorder = [[AVAudioRecorder alloc]
                          initWithURL:audioRecordingURL
                          settings:[self audioRecordingSettings]
                          error:&error];
    
    BOOL success = NO;
    
    if (self.audioRecorder != nil){
        
        self.audioRecorder.delegate = self;
        /* Prepare the recorder and then start the recording */
        
        if ([self.audioRecorder prepareToRecord]) {
            if (self.maxDuration > 0 &&
                [self.audioRecorder recordForDuration:self.maxDuration]) {
                success = YES;
            }
            else if ([self.audioRecorder record]) {
                success = YES;
            }
        }
    }
    
    if (success) {
        NSLog(@"Successfully started to record with max duration: %f", self.maxDuration);
    }
    else {
        NSLog(@"failed to start recording");
        self.audioRecorder = nil;
    }
    
    return success;
}

- (void)stopRecording
{
    /* Just stop the audio recorder here */
    [self.audioRecorder stop];
    
}

- (BOOL)playFileAtURL:(NSURL *)url
{
    if (url == nil) return NO;
    
    /* Let's try to retrieve the data for the recorded file */
    NSError *playbackError = nil;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url
                                                              error:&playbackError];
    
//    NSError *readingError = nil;
//    NSData  *fileData =
//    [NSData dataWithContentsOfURL:[self audioRecordingPath]
//                          options:NSDataReadingMapped
//                            error:&readingError];
    
    /* Form an audio player and make it play the recorded data */
//    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:fileData
//                                                     error:&playbackError];
    
    BOOL success = NO;
    
    /* Could we instantiate the audio player? */
    if (self.audioPlayer != nil){
        self.audioPlayer.delegate = self;
        
        /* Prepare to play and start playing */
        if ([self.audioPlayer prepareToPlay] &&
            [self.audioPlayer play]){
            NSLog(@"Started playing the recorded audio.");
            success = YES;
        } else {
            NSLog(@"Could not play the audio.");
        }
        
    } else {
        NSLog(@"Failed to create an audio player.");
    }
    
    return success;
}

- (void)stopPlaying
{
    NSLog(@"stop, isplaying: %d", self.audioPlayer.isPlaying);
    [self.audioPlayer stop];
    self.audioPlayer = nil;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                       successfully:(BOOL)flag{
    
    self.audioPlayer = nil;
    
    if (flag){
        NSLog(@"Audio player stopped correctly.");
        [self.delegate OHMAudioRecorderDidFinishPlaying:self];
    } else {
        NSLog(@"Audio player did not stop correctly.");
        [self.delegate OHMAudioRecorderFailed:self];
    }
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder
                           successfully:(BOOL)flag{
    
    self.audioRecorder = nil;
    
    if (flag){
        
        NSLog(@"Successfully stopped the audio recording process.");
        [self.delegate OHMAudioRecorder:self didFinishRecordingToURL:recorder.url];
        
    } else {
        NSLog(@"Stopping the audio recording failed.");
        [self.delegate OHMAudioRecorderFailed:self];
    }
    
}


- (NSDictionary *)audioRecordingSettings
{
    
    /* Let's prepare the audio recorder options in the dictionary.
     Later we will use this dictionary to instantiate an audio
     recorder of type AVAudioRecorder */
    
    return @{
             AVFormatIDKey : @(kAudioFormatAppleLossless),
             AVSampleRateKey : @(44100.0f),
             AVNumberOfChannelsKey : @1,
             AVEncoderAudioQualityKey : @(AVAudioQualityMedium),
             };
    
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    
    /* The audio session has been deactivated here */
    
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
                       withOptions:(NSUInteger)flags{
    
    if (flags == AVAudioSessionInterruptionOptionShouldResume){
        [player play];
    }
    
}



- (NSURL *)audioRecordingPath
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSURL *cachesFolderUrl =
    [fileManager URLForDirectory:NSCachesDirectory
                        inDomain:NSUserDomainMask
               appropriateForURL:nil
                          create:NO
                           error:nil];
    
    return [cachesFolderUrl
            URLByAppendingPathComponent:@"tempAudio.m4a"];
    
}

@end
