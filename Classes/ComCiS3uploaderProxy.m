/**
 * S3Uploader 2012 by Clearly Innovative, Inc.
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "ComCiS3uploaderProxy.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"


#import "AmazonS3Client.h"

@implementation ComCiS3uploaderProxy
@synthesize _image;
@synthesize _callback;
@synthesize _blob;
@synthesize FILENAME;
@synthesize BUCKET_NAME;
@synthesize ACCESS_KEY_ID;
@synthesize SECRET_KEY;
@synthesize PATH;

#pragma Public APIs

-(void)uploadToAS3:(id)args
{

    //ENSURE_UI_THREAD(uploadToAS3,args);
    
	NSLog(@"%@",@"IN METHOD: uploadToAS3");

	// get the data
    _blob = [[args objectAtIndex:0] retain];
    
	// get the misc parameters
    NSDictionary * params = [args objectAtIndex:1];
    

    PATH = [params objectForKey:@"PATH"];	
    BUCKET_NAME = [params objectForKey:@"BUCKET_NAME"];	
    
	// get the function callback 
    _callback = [[args objectAtIndex:2] retain];	



    // Initial the S3 Client.
    AmazonS3Client *s3 = [[[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY] autorelease];

    @try {
        // Create the picture bucket.
        [s3 createBucket:[[[S3CreateBucketRequest alloc] initWithName:BUCKET_NAME] autorelease]];

        // Upload data.  Remember to set the content type.
        S3PutObjectRequest *por = [[[S3PutObjectRequest alloc] initWithKey:PATH inBucket:BUCKET_NAME] autorelease];

        
        // if this is an image, then convert
        if ( [[_blob mimeType] rangeOfString:@"image/"].location != NSNotFound) {
            // Convert the image to JPEG data.
             _image = [UIImage imageWithData:[(TiBlob*)_blob data]];
            NSLog(@"Saving image...",nil);
            por.data = UIImageJPEGRepresentation(_image, 1.0);
            por.contentType = [_blob mimeType];
        } else {
            por.data = [_blob data];            
            
            // need to override the mimeType
            if( [[_blob mimeType] isEqualToString:@"application/octet-stream"]) {
                por.contentType = [NSString stringWithFormat:@"application/%@", [PATH pathExtension]];
            } else {
                por.contentType = [_blob mimeType];
            }
        }

        
        // Put the image data into the specified s3 bucket and object.
        [s3 putObject:por];


		// now get the url to send back
		// Set the content type so that the browser will treat the URL as an image.
        S3ResponseHeaderOverrides *override = [[[S3ResponseHeaderOverrides alloc] init] autorelease];
        override.contentType = [_blob mimeType];

        // Request a pre-signed URL to picture that has been uplaoded.
        S3GetPreSignedURLRequest *gpsur = [[[S3GetPreSignedURLRequest alloc] init] autorelease];
        gpsur.key                     = PATH;
        gpsur.bucket                  = BUCKET_NAME;
        gpsur.expires                 = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600]; // Added an hour's worth of seconds to the current time.
        gpsur.responseHeaderOverrides = override;

        // Get the URL
        NSURL *url = [s3 getPreSignedURL:gpsur];

		// send back the url
        NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:NUMBOOL(YES),@"success",[_blob mimeType],@"mimeType",url,@"url",nil];
        [self _fireEventToListener:@"success" withObject:event listener:_callback thisObject:nil];
    }
    @catch (AmazonClientException *exception) {
		NSLog(@"%@",[exception message]);
		
		// send back the error
        NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:NUMBOOL(NO),@"success",exception.message,@"error",nil];
        [self _fireEventToListener:@"error" withObject:event listener:_callback thisObject:nil];
    }

}

-(void)listBuckets:(id)args
{
	NSLog(@"%@",@"IN METHOD: listBuckets");
    
    
	// get the misc parameters
    NSDictionary * params = [args objectAtIndex:0];
    
    
	// get the function callback 
    _callback = [[args objectAtIndex:1] retain];    
    
    
    
    // Initial the S3 Client.
    AmazonS3Client *s3 = [[[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY] autorelease];
    
    @try {
        
		// send back the url
        NSArray * buckets = [s3 listBuckets];
        NSMutableArray *responseArray = [[NSMutableArray alloc] init];
        for (id element in buckets) {
            NSDictionary *e = [NSDictionary dictionaryWithObjectsAndKeys:[element name],@"name",[element creationDate],@"creationDate",nil];
            [responseArray addObject: e];
        }
        NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:NUMBOOL(YES),@"success",[[responseArray copy] autorelease],@"buckets",nil];
        
        [self _fireEventToListener:@"success" withObject:event listener:_callback thisObject:nil];
    }
    @catch (AmazonClientException *exception) {
		NSLog(@"%@",[exception message]);
		
		// send back the error
        NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:NUMBOOL(NO),@"success",exception.message,@"error",nil];
        [self _fireEventToListener:@"error" withObject:event listener:_callback thisObject:nil];
    }    
    
}

-(void)listBucketContents:(id)args
{
	NSLog(@"%@",@"IN METHOD: listBucketContents");
    
    
	// get the misc parameters
    NSDictionary * params = [args objectAtIndex:0];
    

    BUCKET_NAME = [params objectForKey:@"BUCKET_NAME"];	
    
	// get the function callback 
    _callback = [[args objectAtIndex:1] retain];    
    
    
    
    // Initial the S3 Client.
    AmazonS3Client *s3 = [[[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY] autorelease];
    
    @try {
        
        NSArray * buckets = [s3 listObjectsInBucket:BUCKET_NAME];
        NSMutableArray *responseArray = [[NSMutableArray alloc] init];
        for (id element in buckets) {
            S3Owner * owner = [element owner];
            NSDictionary *e = [NSDictionary dictionaryWithObjectsAndKeys:[owner displayName],@"owner_displayName",[owner ID],@"owner_id",[element key],@"name",[element etag],@"etag",[NSString stringWithFormat:@"%d", [element size]],@"size",[element lastModified],@"lastModified",nil];
            [responseArray addObject: e];
        }
        NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:NUMBOOL(YES),@"success",[[responseArray copy] autorelease],@"contents",nil];
        
        [self _fireEventToListener:@"success" withObject:event listener:_callback thisObject:nil];
    }
    @catch (AmazonClientException *exception) {
		NSLog(@"%@",[exception message]);
		
		// send back the error
        NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:NUMBOOL(NO),@"success",exception.message,@"error",nil];
        [self _fireEventToListener:@"error" withObject:event listener:_callback thisObject:nil];
    }    
    
}

-(void)deleteBucketItem:(id)args
{
	NSLog(@"%@",@"IN METHOD: deleteBucketItem");
    
    
	// get the misc parameters
    NSDictionary * params = [args objectAtIndex:0];
    
    BUCKET_NAME = [params objectForKey:@"BUCKET_NAME"];	
    PATH = [params objectForKey:@"PATH"];	
    
	// get the function callback 
    _callback = [[args objectAtIndex:1] retain];    
    
    
    
    // Initial the S3 Client.
    AmazonS3Client *s3 = [[[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY] autorelease];
    
    @try {
        
        S3DeleteObjectResponse * response = [s3 deleteObjectWithKey:PATH withBucket:BUCKET_NAME];
        NSDictionary *event;
        
        if ([response deleteMarker] == FALSE) {
            event = [NSDictionary dictionaryWithObjectsAndKeys:NUMBOOL(YES),@"success",nil];
        } else {
            event = [NSDictionary dictionaryWithObjectsAndKeys:NUMBOOL(NO),@"success",nil];            
        }
        
        [self _fireEventToListener:@"success" withObject:event listener:_callback thisObject:nil];
    }
    @catch (AmazonClientException *exception) {
		NSLog(@"%@",[exception message]);
		
		// send back the error
        NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:NUMBOOL(NO),@"success",exception.message,@"error",nil];
        [self _fireEventToListener:@"error" withObject:event listener:_callback thisObject:nil];
    }    
    
}

-(void)deleteBucket:(id)args
{
	NSLog(@"%@",@"IN METHOD: deleteBucket");
    
    
	// get the misc parameters
    NSDictionary * params = [args objectAtIndex:0];
    
    BUCKET_NAME = [params objectForKey:@"BUCKET_NAME"];	

    
	// get the function callback 
    _callback = [[args objectAtIndex:1] retain];    
    
    
    
    // Initial the S3 Client.
    AmazonS3Client *s3 = [[[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY] autorelease];
    
    @try {
        
        S3DeleteBucketResponse * response = [s3 deleteBucketWithName:BUCKET_NAME];
        NSDictionary *event;
        
        if ([response deleteMarker] == FALSE) {
            event = [NSDictionary dictionaryWithObjectsAndKeys:NUMBOOL(YES),@"success",nil];
        } else {
            event = [NSDictionary dictionaryWithObjectsAndKeys:NUMBOOL(NO),@"success",nil];            
        }
        
        [self _fireEventToListener:@"success" withObject:event listener:_callback thisObject:nil];
    }
    @catch (AmazonClientException *exception) {
		NSLog(@"%@",[exception message]);
		
		// send back the error
        NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:NUMBOOL(NO),@"success",exception.message,@"error",nil];
        [self _fireEventToListener:@"error" withObject:event listener:_callback thisObject:nil];
    }    
    
}

-(void)urlFromAS3:(id)args
{
    
    //ENSURE_UI_THREAD(uploadToAS3,args);
    
	NSLog(@"%@",@"IN METHOD: urlFromAS3");
    
    
	// get the misc parameters
    NSDictionary * params = [args objectAtIndex:0];

    PATH = [params objectForKey:@"PATH"];	
    BUCKET_NAME = [params objectForKey:@"BUCKET_NAME"];	
    
	// get the function callback 
    _callback = [[args objectAtIndex:1] retain];	
    
    // Initial the S3 Client.
    AmazonS3Client *s3 = [[[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY] autorelease];
    
    @try {
                
		// now get the url to send back
		// Set the content type so that the browser will treat the URL as an image.
        S3ResponseHeaderOverrides *override = [[[S3ResponseHeaderOverrides alloc] init] autorelease];
        override.contentType = @"image/jpeg";
        
        // Request a pre-signed URL to picture that has been uplaoded.
        S3GetPreSignedURLRequest *gpsur = [[[S3GetPreSignedURLRequest alloc] init] autorelease];
        gpsur.key                     = PATH;
        gpsur.bucket                  = BUCKET_NAME;
        gpsur.expires                 = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600]; // Added an hour's worth of seconds to the current time.
        gpsur.responseHeaderOverrides = override;
        
        // Get the URL
        NSURL *url = [s3 getPreSignedURL:gpsur];
        
		// send back the url
        NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:NUMBOOL(YES),@"success",url,@"url",nil];
        [self _fireEventToListener:@"success" withObject:event listener:_callback thisObject:nil];
    }
    @catch (AmazonClientException *exception) {
		NSLog(@"%@",[exception message]);
		
		// send back the error
        NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:NUMBOOL(NO),@"success",exception.message,@"error",nil];
        [self _fireEventToListener:@"error" withObject:event listener:_callback thisObject:nil];
    }
    
}



@end
