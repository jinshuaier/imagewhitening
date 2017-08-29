//
//  ImageUnits.h
//  imageDispose
//
//  Created by 胡高广 on 2017/8/29.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> //因为是图片处理
//导入Opencv核心头文件
#import <opencv2/opencv.hpp>

//导入opencv对ios支持
#import <opencv2/imgcodecs/ios.h>

//导入opencv的命名空间
using namespace cv;

@interface ImageUnits : NSObject

//ios平台下实现 -> 调用ios -> API
+ (UIImage *)iosImageProcess:(UIImage *)image;


//在OpenCV框架下实现 -> 调用OpenCV API
+ (UIImage *)openCVImageProcess:(UIImage *)image; //支持多个领域 技术（人脸识别、人脸检测、身份证识别、车牌号识别）
@end
