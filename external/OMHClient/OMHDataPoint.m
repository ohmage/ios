//
//  OMHDataPoint.m
//  OMHClient
//
//  Created by Charles Forkish on 12/13/14.
//  Copyright (c) 2014 Open mHealth. All rights reserved.
//

#import "OMHDataPoint.h"

@implementation NSMutableDictionary (OMHDataPoint)

+ (instancetype)templateDataPoint
{
    OMHDataPoint *template = [[OMHDataPoint alloc] init];
    template.header = [OMHHeader templateHeader];
    template.body = @{};
    return template;
}

- (void)setHeader:(OMHHeader *)header
{
    self[@"header"] = header;
}

- (OMHHeader *)header
{
    return self[@"header"];
}

- (void)setBody:(NSDictionary *)body
{
    self[@"body"] = body;
}

- (NSDictionary *)body
{
    return self[@"body"];
}

+ (NSString *)uuidString
{
    return [[[NSUUID alloc] init] UUIDString];
}

+ (NSDateFormatter *)ISO8601Formatter
{
    static NSDateFormatter *sDateFormatter = nil;
    if (sDateFormatter == nil) {
        sDateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        [sDateFormatter setLocale:enUSPOSIXLocale];
        [sDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    }
    return sDateFormatter;
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    return [[self ISO8601Formatter] stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)string
{
    return [[self ISO8601Formatter] dateFromString:string];
}


#pragma mark - OMHHeader

+ (instancetype)templateHeader
{
    OMHHeader *template = [[OMHHeader alloc] init];
    template.headerID = [OMHDataPoint uuidString];
    template.creationDateTime = [NSDate date];
    template.schemaID = [OMHSchemaID templateSchemaID];
    return template;
}

- (void)setHeaderID:(NSString *)headerID
{
    self[@"id"] = headerID;
}

- (NSString *)headerID
{
    return self[@"id"];
}

- (void)setCreationDateTime:(NSDate *)creationDateTime
{
    self[@"creation_date_time"] = [OMHDataPoint stringFromDate:creationDateTime];
}

- (NSDate *)creationDateTime
{
    return [OMHDataPoint dateFromString:self[@"creation_date_time"]];
}

- (void)setSchemaID:(OMHSchemaID *)schemaID
{
    self[@"schema_id"] = schemaID;
}

- (OMHSchemaID *)schemaID
{
    return self[@"schema_id"];
}

- (void)setAcquisitionProvenance:(OMHAcquisitionProvenance *)acquisitionProvenance
{
    self[@"acquisition_provenance"] = acquisitionProvenance;
}

- (OMHAcquisitionProvenance *)acquisitionProvenance
{
    return self[@"acquisition_provenance"];
}


#pragma mark - OMHSchemaID

+ (instancetype)templateSchemaID
{
    OMHSchemaID *template = [[OMHSchemaID alloc] init];
    template.schemaNamespace = @"";
    template.name = @"";
    template.version = @"";
    return template;
}

- (void)setSchemaNamespace:(NSString *)schemaNamespace
{
    self[@"namespace"] = schemaNamespace;
}

- (NSString *)schemaNamespace
{
    return self[@"namespace"];
}

- (void)setName:(NSString *)name
{
    self[@"name"] = name;
}

- (NSString *)name
{
    return self[@"name"];
}

- (void)setVersion:(NSString *)version
{
    self[@"version"] = version;
}

- (NSString *)version
{
    return self[@"version"];
}


#pragma mark - OMHAcquisitionProvenance

+ (instancetype)templateAcquisitionProvenance
{
    OMHAcquisitionProvenance *template = [[OMHAcquisitionProvenance alloc] init];
    template.sourceName = @"";
    return template;
}

+ (NSDictionary *)modalityDictionary
{
    static NSDictionary *sDictionary = nil;
    if (sDictionary == nil) {
        sDictionary = @{@(OMHAcquisitionProvenanceModalitySensed) : @"sensed",
                        @(OMHAcquisitionProvenanceModalitySelfReported) : @"self-reported",
                        @(OMHAcquisitionProvenanceModalityUnknown) : @"unknown"};
    }
    return sDictionary;
}

+ (NSString *)modalityStringForModalityEnum:(OMHAcquisitionProvenanceModality)modalityEnum
{
    return [OMHAcquisitionProvenance modalityDictionary][@(modalityEnum)];
}

+ (OMHAcquisitionProvenanceModality)modalityEnumForModalityString:(NSString *)modalityString
{
    NSArray *keys = [[OMHAcquisitionProvenance modalityDictionary] allKeysForObject:modalityString];
    if (keys.count > 0) {
        return [keys.firstObject intValue];
    }
    else {
        return OMHAcquisitionProvenanceModalityUnknown;
    }
}

- (void)setSourceName:(NSString *)sourceName
{
    self[@"source_name"] = sourceName;
}

- (NSString *)sourceName
{
    return self[@"source_name"];
}

- (void)setSourceCreationDateTime:(NSDate *)sourceCreationDateTime
{
    self[@"source_creation_date_time"] = [OMHDataPoint stringFromDate:sourceCreationDateTime];
}

- (NSDate *)sourceCreationDateTime
{
    return [OMHDataPoint dateFromString:self[@"source_creation_date_time"]];
}

- (void)setModality:(OMHAcquisitionProvenanceModality)modality
{
    self[@"modality"] = [OMHAcquisitionProvenance modalityStringForModalityEnum:modality];
}

- (OMHAcquisitionProvenanceModality)modality
{
    return [OMHAcquisitionProvenance modalityEnumForModalityString:self[@"modality"]];
}



@end
