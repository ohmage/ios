//
//  OMHDataPoint.h
//  OMHClient
//
//  Created by Charles Forkish on 12/13/14.
//  Copyright (c) 2014 Open mHealth. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSMutableDictionary OMHDataPoint;
typedef NSMutableDictionary OMHHeader;
typedef NSMutableDictionary OMHSchemaID;
typedef NSMutableDictionary OMHAcquisitionProvenance;
typedef NSMutableDictionary OMHRichMediaDataPoint;
typedef NSMutableDictionary OMHMediaAttachment;

/**
 *  Data Point
 *  http://www.openmhealth.org/developers/schemas/#data-point
 *
 * The easiest way to create a new data point conforming to the OmH
 * data point schema is with a call to [OMHDataPoint templateDataPoint].
 * That will return a dictionary with the schema structure like this:
 *
 *  {
 *      "header": {
 *           "id": <a new UUID string>,
 *           "creation_date_time": <the current date and time>,
 *           "schema_id": {
 *               "namespace": "",
 *               "name": "",
 *               "version": ""
 *           }
 *       },
 *       "body": {}
 *   }
 *
 */
@interface NSMutableDictionary (OMHDataPoint)

+ (instancetype)templateDataPoint;

@property (nonatomic, copy) OMHHeader *header;
@property (nonatomic, copy) NSDictionary *body;


/**
 *  Header
 *  http://www.openmhealth.org/developers/schemas/#header
 */
@property (nonatomic, copy) NSString *headerID;
@property (nonatomic, copy) NSDate *creationDateTime;
@property (nonatomic, copy) OMHSchemaID *schemaID;
@property (nonatomic, copy) OMHAcquisitionProvenance *acquisitionProvenance;


/**
 *  Schema ID
 *  http://www.openmhealth.org/developers/schemas/#schema-id
 */
@property (nonatomic, copy) NSString *schemaNamespace;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *version;


/**
 *  Acquisition Provenance
 *  http://www.openmhealth.org/developers/schemas/#header
 */
typedef enum {
    OMHAcquisitionProvenanceModalitySensed,
    OMHAcquisitionProvenanceModalitySelfReported,
    OMHAcquisitionProvenanceModalityUnknown
} OMHAcquisitionProvenanceModality;

@property (nonatomic, copy) NSString *sourceName;
@property (nonatomic, copy) NSDate *sourceCreationDateTime;
@property (nonatomic) OMHAcquisitionProvenanceModality modality;

/**
 *  Rich Media Data Point
 */
+ (OMHRichMediaDataPoint *)richMediaDataPointWithDataPoint:(NSDictionary *)dataPoint
                                          mediaAttachments:(NSArray *)mediaAttachments;

@property (nonatomic, copy) OMHDataPoint *dataPoint;
//@property (nonatomic, readonly) NSArray *jsonArray;
@property (nonatomic, copy) NSArray *mediaAttachments;

- (void)removeTempFile;

/**
 *  Media Attachments
 */
@property (nonatomic, copy) NSURL *mediaAttachmentFileURL;
@property (nonatomic, readonly) NSString *mediaAttachmentFileName;
@property (nonatomic, copy) NSString *mediaAttachmentMimeType;
@property (nonatomic, readonly) NSURL *tempFileURL;

// helpers
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSDate *)dateFromString:(NSString *)string;

@end
