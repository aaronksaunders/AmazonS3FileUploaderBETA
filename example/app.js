// This is a test harness for your module
// You should do something interesting in this harness
// to test out the module and to provide instructions
// to users on how to use it by example.
// open a single window
// TODO: write your module tests here
var s3uploader = require('com.ci.s3uploader')
 var proxy = s3uploader.create({
    "ACCESS_KEY_ID": "",
    "SECRET_KEY": ""
});
Ti.API.info("module is => " + s3uploader);


//
// UPLOAD PDF FILE
function uploadPDF() {
    var f = Ti.Filesystem.getFile("Module-Developers-Guide-iOS.pdf");
	var fData = f.read();
	
	Ti.API.info("mimeType " + fData.mimeType);
    proxy.uploadToAS3(fData, {
        "PATH": "pdf.data/Module-Developers-Guide-iOS.pdf",
        "BUCKET_NAME": "people-interact",
    },
    function(_data) {
        Ti.API.info("data " + JSON.stringify(_data));
        uploadImageFile();
    });
}

//
// UPLOAD IMAGE FILE
function uploadImageFile() {
    f = Ti.Filesystem.getFile("aaron-pic.jpg")
    proxy.uploadToAS3(f.read(), {
        "PATH": "jpg.data/aaron-pic.jpg",
        "BUCKET_NAME": "people-interact",
    },
    function(_data) {
        Ti.API.info("data " + JSON.stringify(_data));
    });
}


//
// START THE FUN
uploadPDF();