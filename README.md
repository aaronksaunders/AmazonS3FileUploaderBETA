AmazonS3FileUploaderBETA
========================

Amazon S3 File Uploader IOS Module BETA


# Clearly Innovative Inc
# s3uploader Module 
# THIS IS A TRIAL RELEASE AND WILL EXPIRE

I have released this version so hopefully I can get some broader testing of the module before I submit it to the marketplace.
If there are some individuals who provide good feedback, I will give them a free version of the module.

Please provide feedback if it is something you think would be good for the marketplace and the overall Appcelerator Community

## Description

Simple file upload and bucket management for Amazon S3 written for IOS and Titanium Appcelerator


## Accessing the s3uploader Module

To access this module from JavaScript, you would do the following:

    var s3uploader = require('com.ci.s3uploader')
    var proxy = s3uploader.create({
        "ACCESS_KEY_ID": "XXXXXXXXXXXXXXXXXXXXXXX",
        "SECRET_KEY": "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    });

The s3uploader variable is a reference to the Module object we then create
the proxy object we will actually use.  

## Reference

TODO: If your module has an API, you should document
the reference here.

### listBuckets

will list all buckets

    // list all Buckets
    proxy.listBuckets({
        "BUCKET_NAME" : "people-interact"
    }, callback);


### listBucketContents

will list all files in the specified bucket

    // list all items in an S3 Bucket
    proxy.listBucketContents({
	    "BUCKET_NAME" : "people-interact"
    }, callback);


### deleteBucket

will delete a specified bucket

	    // delete a bucket
	    proxy.deleteBucket({
		    "BUCKET_NAME" : "people-interact"
	    }, callback);


### deleteBucketItem

will delete a specified bucket item

	// delete a bucket
	proxy.deleteBucketItem({
		"PATH" : "photo.data/aaron-pic.jpg",
		"BUCKET_NAME" : "people-interact"
	}, callback);


### uploadToAS3

will upload file/blob to specified path and S3 Bucket

	// upload a file to an S3 Bucket
	var f = Ti.Filesystem.getFile("aaron-pic.jpg");
	proxy.uploadToAS3(f.read(), {
		"PATH" : "photo.data/aaron-pic.jpg",
		"BUCKET_NAME" : "people-interact"
	}, callback);

sample response from success file upload, returns file information and a url that is good
for about 60 minutes before it expires. use method below to get new url when needed

	{
	    "type": "success",
	    "source": {},
	    "mimeType": "application/pdf",
	    "success": true,
	    "url": "https://people-interact.s3.amazonaws.com/pdf.data%2FModule-Developers-Guide-iOS.pdf?AWSAccessKeyId=AKIAJSHYUI4MJHKQ4HBQ&Expires=1337493797&response-content-type=application%2Fpdf&Signature=xRaO4uvUQGrlLR7vavEZjei2Uwc%3D"
	}


### urlFromAS3

will get a url for the specified resource in the S3 bucket

	// get the URL from an item in an S3 Bucket
	proxy.urlFromAS3({
		"PATH" : "photo.data/aaron-pic.jpg",
		"BUCKET_NAME" : "people-interact"
	}, callback);



### Using the callback method
	function(_data) {
	    Ti.API.info("data " + JSON.stringify(_data));
	});

### Callback response information example
	{
	    "type": "success",
	    "source": {
	        "id": "com.ci.s3uploader"
	    },
	    "success": true,
	    "contents": [
	        {
	            "owner_displayName": "aaron",
	            "name": "Untitled.omniplan",
	            "etag": "\"9ada9c606ba3300f5f83a21981eec4cf\"",
	            "owner_id": "34ff3c085c6e2e191d51b92069e4dd9990f3846523fb7e9376d1eee9c2f958ee",
	            "size": "15708",
	            "lastModified": "2012-05-14T02:01:27.000Z"
	        },
	        {
	            "owner_displayName": "aaron",
	            "name": "photo.data/aaron-pic.jpg",
	            "etag": "\"cc974e09dd7c30a4185702ba2120b631\"",
	            "owner_id": "34ff3c085c6e2e191d51b92069e4dd9990f3846523fb7e9376d1eee9c2f958ee",
	            "size": "16251",
	            "lastModified": "2012-05-14T01:57:25.000Z"
	        }
	    ]
	}


## Author

Clearly Innovative Inc 2012
Aaron K. Saunders

## License

This is a beta release of the software, this will EXPIRE when I push to Appcelerator Marketplace
