var exec = require('cordova/exec');

exports.cropFromGallery = function(arg0, arg1, success, error) {
    exec(success, error, "imageCropper", "cropFromGallery", [arg0, arg1]);
};
