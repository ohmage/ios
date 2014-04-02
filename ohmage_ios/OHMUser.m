//
//  OHMUser.m
//  ohmage_ios
//
//  Created by Charles Forkish on 4/1/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMUser.h"
#import "OHMHTTPClient.h"
#import "OHMOhmlet.h"

@interface OHMUser () <OHMHTTPClientDelegate>

@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *authToken;
@property (nonatomic, copy) NSString *refreshToken;
@property (nonatomic, copy) NSString *fullName;

@property (nonatomic, strong) OHMOhmlet *ohmlet;

@end

@implementation OHMUser

+ (NSString *)userArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"user.archive"];
}

+ (OHMUser*)sharedUser
{
    static OHMUser *_sharedUser = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // first check for archive
        NSString *path = [self userArchivePath];
        _sharedUser = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        if (!_sharedUser) {
            _sharedUser = [[self alloc] initPrivate];
        }
    });
    
    return _sharedUser;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[OHMUser sharedUser]"
                                 userInfo:nil];
    return nil;
}

// Secret designated initializer
- (instancetype)initPrivate
{
    self = [super init];
    
    if (self) {
        self.email = @"cforkish@gmail.com";
        self.password = @"loudfowl98";
    }
    
    return self;
}

- (NSString *)definitionRequestUrlString
{
    return [NSString stringWithFormat:@"people/%@/current", self.ohmId];
}

- (void)login
{
    [self.httpClient setAuthorizationToken:nil];
    
    NSString *request =  @"auth_token";
    NSDictionary *parameters = @{@"email": self.email, @"password" : self.password};
    __weak OHMUser *weakSelf = self;
    
    [self.httpClient getRequest:request withParameters:parameters completionBlock:^(NSDictionary *response, NSError *error) {
        if (error) {
            NSLog(@"Login Error");
        }
        else {
            NSLog(@"Login Success");
            
            weakSelf.authToken = [response authToken];
            weakSelf.refreshToken = [response refreshToken];
            weakSelf.ohmId = [response userId];
            
            [weakSelf updateFromServer];
        }
    }];
}

- (void)updateFromServer
{
    [self.httpClient setAuthorizationToken:self.authToken];
    
    __weak OHMUser *weakSelf = self;
    
    [self.httpClient getRequest:[self definitionRequestUrlString]
                 withParameters:nil completionBlock:^(NSDictionary *response, NSError *error) {
        
        if (error) {
            NSLog(@"Update user info Error");
        }
        else {
            NSLog(@"update user info Success");
            
            weakSelf.fullName = [response userFullName];
            NSDictionary *ohmletDef = [[response ohmlets] firstObject];
            NSString *ohmletId = [ohmletDef ohmletId];
            
            if ([ohmletId isEqualToString:weakSelf.ohmlet.ohmId]) {
                [weakSelf.ohmlet updateFromServer];
            }
            else {
                weakSelf.ohmlet = [OHMOhmlet loadFromServerWithId:ohmletId];
            }
        }
    }];
}

@end
