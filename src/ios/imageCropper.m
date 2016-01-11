//
//  imageCropper.m
//  panart
//
//  Created by zsly on 16/1/6.
//
//

#import "imageCropper.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "MLImageCrop.h"

@interface imageCropper()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,MLImageCropDelegate>
@property (nonatomic,assign) BOOL isEdit;
@property (nonatomic,assign) CGSize imageSize;
@property (nonatomic,strong) CDVInvokedUrlCommand* command;
@end

@implementation imageCropper
-(void)crop:(CDVInvokedUrlCommand*)command
{
    NSNumber *arg_0=command.arguments[0];
    NSNumber *arg_1=command.arguments[1];
    NSArray *arg_2=command.arguments[2];
    self.imageSize=CGSizeMake([[arg_2 objectAtIndex:0] integerValue],[[arg_2 objectAtIndex:1] integerValue]);
    GetPicType type=(GetPicType)arg_0.integerValue;
    self.isEdit=arg_1.boolValue;
    switch (type) {
        case k_fromGallery_type:
            [self fromGallery:command];
            break;
            
        case k_fromCamera_type:
            [self fromCamera:command];
            break;
        default:
            break;
    }
    
}

-(void)fromGallery:(CDVInvokedUrlCommand*)command
{
    self.command=command;
    AppDelegate *app_delegate=[UIApplication sharedApplication].delegate;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate=self;
    
    //@"public.movie"
    picker.mediaTypes =  @[@"public.image"];
    
    //设置选择后的图片可被编辑
    picker.allowsEditing = NO;
    [app_delegate.viewController presentViewController:picker animated:YES completion:nil];
}


-(void)fromCamera:(CDVInvokedUrlCommand*)command
{
     NSString *str=@"ios未开放此功能";
     CDVPluginResult*pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:str];
     [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey: @"UIImagePickerControllerOriginalImage"];
    UIImageOrientation imageOrientation=image.imageOrientation;
    if(imageOrientation!=UIImageOrientationUp)
    {
        UIGraphicsBeginImageContext(image.size);
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    if(self.isEdit)
    {
        MLImageCrop *imageCrop = [[MLImageCrop alloc]init];
        imageCrop.delegate = self;
        imageCrop.ratioOfWidthAndHeight =self.imageSize.width/self.imageSize.height;
        imageCrop.image = image;
        [picker pushViewController:imageCrop animated:YES];
    }
    else
    {
        [self addImage:image];
    }
}

-(void)addImage:(UIImage*)image
{
    image=[Operation scaleToSize:image size:self.imageSize];
    NSData *data=UIImageJPEGRepresentation(image, 0.9f);
    NSString* tmpPath =[Operation tmpImagesDirectoryPath];
    NSDate *date=[NSDate date];
    NSString *filePath=[NSString stringWithFormat:@"%@/%ld_%@", tmpPath,(long)date.timeIntervalSince1970,@"tmpImage"];
    NSError* err = nil;
    CDVPluginResult *pluginResult = nil;
    if(![data writeToFile:filePath options:NSAtomicWrite error:&err])
    {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_IO_EXCEPTION messageAsString:[err localizedDescription]];
    }
    else
    {
        NSURL*url=[NSURL fileURLWithPath:filePath];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:url.absoluteString];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.command.callbackId];
}

#pragma mark - crop delegate
- (void)cropImage:(UIImage*)cropImage forOriginalImage:(UIImage*)originalImage
{
      [self addImage:cropImage];
}
@end
