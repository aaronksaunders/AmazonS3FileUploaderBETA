/**
 * S3Uploader 2012 by Clearly Innovative, Inc.
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "ComCiS3uploaderModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"


#import "AmazonS3Client.h"
#import "ComCiS3uploaderProxy.h"

@implementation ComCiS3uploaderModule
@synthesize _image;
@synthesize _callback;
@synthesize _blob;
@synthesize FILENAME;
@synthesize BUCKET_NAME;
@synthesize ACCESS_KEY_ID;
@synthesize SECRET_KEY;
@synthesize PATH;

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"b123123a-c40e-4932-bd7c-81a59f408aba";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"com.ci.s3uploader";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added 
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma Public APIs

-(id)create:(id)args {
    ComCiS3uploaderProxy * proxy =  [[[ComCiS3uploaderProxy alloc] init ] autorelease ];
    
    // get the misc parameters
    NSDictionary * params = [args objectAtIndex:0];
    
    proxy.ACCESS_KEY_ID = [params objectForKey:@"ACCESS_KEY_ID"];
    proxy.SECRET_KEY = [params objectForKey:@"SECRET_KEY"];	
    
    return proxy;
}
@end
