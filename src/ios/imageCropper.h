//
//  imageCropper.h
//  panart
//
//  Created by zsly on 16/1/6.
//
//

#import <Cordova/CDV.h>

typedef enum _getPicType
{
    k_fromGallery_type,
    k_fromCamera_type,
    
}GetPicType;

@interface imageCropper : CDVPlugin
-(void)crop:(CDVInvokedUrlCommand*)command;
@end
