//
//  Operation.h
//  panart
//
//  Created by zsly on 16/1/7.
//
//

#import <Foundation/Foundation.h>
@interface Operation : NSObject
///创建临时文件夹
+(void)createDirectory;
///获取文件夹路径
+(NSString*)tmpImagesDirectoryPath;
///清空临时文件夹
+(void)removeTmpImages;
///图像缩放
+(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;
///屏幕尺寸
+(CGSize)screenSize;
@end
