var exec = require('cordova/exec');

exports.crop = function(arg0, arg1, success, error) {
    exec(success, error, "imageCropper", "crop", [arg0, arg1]);
};
