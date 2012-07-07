/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "TiModule.h"

@interface ComCiS3uploaderProxy : TiProxy 
{
}

@property (nonatomic, retain) KrollCallback * _callback;
@property (nonatomic, retain) UIImage * _image;
@property (nonatomic, retain) TiBlob * _blob;
@property (strong, nonatomic) NSString *ACCESS_KEY_ID;
@property (strong, nonatomic) NSString *SECRET_KEY;
@property (strong, nonatomic) NSString *FILENAME;
@property (strong, nonatomic) NSString *BUCKET_NAME;
@property (strong, nonatomic) NSString *PATH;

@end
