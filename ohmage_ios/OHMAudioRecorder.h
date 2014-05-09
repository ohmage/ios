//
//  OHMAudioRecorder.h
//  ohmage_ios
//
//  Created by Charles Forkish on 5/8/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OHMAudioRecorderDelegate;

@interface OHMAudioRecorder : NSObject

@property (nonatomic, weak) id<OHMAudioRecorderDelegate> delegate;
@property (nonatomic) NSTimeInterval maxDuration;
@property (nonatomic, readonly) BOOL isRecording;
@property (nonatomic, readonly) BOOL isPlaying;
@property (nonatomic, readonly) BOOL hasMicrophoneAccess;

- (instancetype)initWithDelegate:(id<OHMAudioRecorderDelegate>)delegate;

- (BOOL)startRecording;
- (void)stopRecording;

- (BOOL)playFileAtURL:(NSURL *)url;
- (void)stopPlaying;

@end

@protocol OHMAudioRecorderDelegate <NSObject>

- (void)OHMAudioRecorder:(OHMAudioRecorder *)recorder didFinishRecordingToURL:(NSURL *)recordingURL;
- (void)OHMAudioRecorderDidFinishPlaying:(OHMAudioRecorder *)recorder;

- (void)OHMAudioRecorderFailed:(OHMAudioRecorder *)recorder;
- (void)OHMAudioRecorderMicrophoneAccessDenied:(OHMAudioRecorder *)recorder;


@end