# ImageCropper
### cordova 图片裁剪插件

### 1.准备工作
		1. 添加平台

		cd Myproj 
		cordova platform add android  
		cordova platform add ios

		ps:这里请注意iOS平台，必须先执行 `cordova platform add ios`,
		然后再执行`cordova plugin add xxxxx`命令，不然有一些必须要的链接库需要手动添加
		
### 2.Cordova CLI/Phonegap 安装 Android & iOS

1).  安装ImageCropper plugin（工程目录下）

方法一： 在线安装

	cordova plugin add  https://github.com/evicord/ImageCropper.git  

方法二：下载到本地再安装

使用git命令将ImageCropper phonegap插件下载的本地,将这个目录标记为`$IMAGE_CROPPER_PLUGIN_DIR`


    git clone https://github.com/evicord/ImageCropper.git
    cordova plugin add $IMAGE_CROPPER_PLUGIN_DIR
    
### 3.使用方法
1).  传入参数：

	sourceType 获取图片方式，0为相册，1为相机
	isEdit 是否裁剪图片，true裁剪，false不裁剪
	outputSize 输出图片尺寸数组格式 [width,height]

2).  调用方法

方法一： 通过中间层js文件调用
	
	document.addEventListener('deviceready', function() {
		var location = cordova.require('com.tyrion.plugin.cropper.imageCropper');
		location.crop(sourceType, isEdit, outputSize,
			function(successData) {
				//这里处理成功回调的数据
			},
			function(failedData) {
				//处理失败的情况
			}
		);
	});
	
方法二：直接调用native方法

	cordova.exec(
		function(successData) {
			//这里处理成功回调的数据
		},
		function(failedData) {
			//处理失败的情况
		},
		"imageCropper",
		"crop",
		[sourceType, isEdit, outputSize]
	);