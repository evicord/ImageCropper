//
//  Operation.m
//  panart
//
//  Created by zsly on 16/1/7.
//
//
#import "Operation.h"

#define TmpImages @"Library/Caches/tmp"

@implementation Operation
+(void)createDirectory
{
    NSString *img_path = [NSHomeDirectory() stringByAppendingPathComponent:TmpImages];
    if(![[NSFileManager defaultManager] fileExistsAtPath:img_path])
    {
       [[NSFileManager defaultManager] createDirectoryAtPath:img_path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

+(NSString*)tmpImagesDirectoryPath
{
    NSString *img_path = [NSHomeDirectory() stringByAppendingPathComponent:TmpImages];
    return img_path;
}

+(void)removeTmpImages
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:[Operation tmpImagesDirectoryPath] error:nil];
    [Operation createDirectory];
}

+(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

+(CGSize)screenSize {
    
    //    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGSize screenSize = [[UIApplication sharedApplication].delegate window].bounds.size;
    if ((NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return CGSizeMake(screenSize.height, screenSize.width);
    }
    //    NSLog(@"size: %@",NSStringFromCGSize(screenSize));
    return screenSize;
}

@end
