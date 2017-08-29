//
//  ImageUnits.m
//  imageDispose
//
//  Created by 胡高广 on 2017/8/29.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "ImageUnits.h"
#import "Utils.h"

@implementation ImageUnits

//实现类方法
+ (UIImage *)iosImageProcess:(UIImage *)image
{
    //第一步：确定图片的大小
    //两种方式
//    CGFloat width = image.size.width;
//    CGFloat height = image.size.height;
    NSUInteger width = CGImageGetWidth(image.CGImage);
    NSUInteger height = CGImageGetHeight(image.CGImage);
    
    //第二步：确定图片颜色的空间 -> 目前的颜色图片是什么就是什么颜色空间
    //两种
    //第一种：彩色空间
    //第二种：灰色空间
    //动态获取空间（学习方法：查看源码-> API demo -> 英文）
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    
    //第三步：创建上下文 -> 存储全局变量（图片的信息）
    //分析参数的含义
    //参数一：数据源
    //分析含义？
    //第一点：计算机图像学中 -> 图片 -> 本质是像素数组 -> 像素点组成 -> ARGB -> 图片默认像素点格式(ARGB)
    //第二点：ARGB -> 每一个颜色值内存大小是8位(一般情况下) ->
    //扩展的知识
    //特殊情况：高清PNG图片 -> 位深度 -> 32位、16位、8位 （位深度越大也就越高清）
    //压缩PNG图片 -> 有些工具 -> 压缩算法（一般压缩工具：解决共性问题，特殊图片：特殊工具进行压缩）
    //低层开发：PNG图片 -> 32位深度 -> 进行压缩(2MB) -> 压缩目标(8位) -> 图片的大小 -> 缩小4倍（500KB）-> 不失真 -> 性能优化
    //第三点：ARGB = 32位的指针（image图片：可能是ARGB、也可能RGB，用最大的位深32去接收）
    //第四点：计算机 -> 数据类型
    //第一类：无符号类型 ->Unsigned -> 简写“U” -> 只有正数
    //第二类：有符号类型 ->Signed -> 简写“S” -> 有正负
    //第五点：因为一般情况下颜色值正数的
    //第一类：无符号类型 -> 颜色取值 0-255 (通常写法)
    //第二类：有符号类型 -> 颜色取值 -128-127
    UInt32 *inputPix = (UInt32 *)calloc(width * height, sizeof(UInt32));
    
    //参数二：图片宽
    //参数三：图片高
    //参数四：每一个像素点每一个颜色值得大小
    //参数五：每一行占用的内存大小（每张图片很多像素点）
    //第一点：计算一个像素点的大小 = ARGB * 8 = 32位 = 4字节（每8位一个字节）
    //第二点：一行大小 = 1个像素点的大小 * 宽 = width * 4
    //参数六：颜色的空间
    //参数七：布局的摆放 -> 是否需要透明度
    //kCGBitmapByteOrder32Big：计算机节序（大端、小端）
    
   CGContextRef contextRef = CGBitmapContextCreate(inputPix, width, height, 8, width * 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    //第四步：根据上下文去绘制图片
    CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), image.CGImage);
    
    //第五步：正式开始操作二进制
    //分析原理
    //第一点：颜色值取值范围（0-255）
    //第二点：分析颜色值变化的规律
    //0-255：越来越白 -> 255(纯白色)
    //第三点：举个例子
    //原始图片： R = 60   G = 80   B = 120
    //将图片的亮度调高 -> 调高60(整体)
    //结果图片： R = 120  G = 140  B = 180
    int ld = 60 ; //亮度 整体的分行
    for (int i = 0; i < height; i ++) {
        for (int j = 0; j < width; j++) {
            //首先：获取当前遍历像素点指针 -> 获取像素点值 -> 根据像素点值获取颜色值 -> 修改颜色值
            //指针位移获取
            UInt32* currentPix = inputPix + (i * width) + j;
            
            //其次：获取像素点值 指针
            UInt32 color = *currentPix;
            
            //获取颜色值：根据像素点的值 -> 获取颜色值
            UInt32 thisR,thisG,thisB,thisA;
            
            //1.获取红色的值 -> thisR
            thisR = Red(color);
            //NSLog(@"红色值：%d",thisR);
            
            //2.获取绿色的值 -> thisG
            thisG = Green(color);
           // NSLog(@"绿色值：%d",thisG);
            
            //3.获取蓝色的值 -> thisB
            thisB = Blue(color);
            //NSLog(@"蓝色值：%d",thisB);
            
            //4.获取透明度的值 -> thisA
            thisA = Alahp(color);
            //NSLog(@"透明度值：%d",thisA);
            
            //其次：修改二进制 (少写变颜色)
            thisR = thisR + ld;
            thisG = thisG + ld;
            thisB = thisB + ld;
            
            //其次：控制范围
            thisR = thisR > 255 ? 255 : thisR;
            thisG = thisG > 255 ? 255 : thisG;
            thisB = thisB > 255 ? 255 : thisB;
            
            //最后：修改像素点的值
            *currentPix = RGBAMake(thisR,thisG,thisB,thisA);
            
            
        }
    }
    
    //第六步：创建UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(contextRef);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    //第七步：释放内存
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(contextRef);
    CGImageRelease(newImageRef);
    free(inputPix);
    
    return newImage;
}


//实现openCV的方法
+ (UIImage *)openCVImageProcess:(UIImage *)image
{
    //第一步：获取宽高
    int width = image.size.width;
    int height = image.size.height;
    
    //第二步：将ios图片 -> opencv图片 这里用到c语言，所以.m变成.mm
    Mat mat_image_src;
    UIImageToMat(image, mat_image_src);
    
    //在opencv里面，有一个规则，支持图片的类型 -> RGB,然后我们的图片类型为ARGB
    //将ARGB类型 -> RGB类型 -> 解决了
    Mat mat_image_dst;
    cvtColor(mat_image_src, mat_image_dst, CV_RGBA2BGR,4); //4个通道 转换
    
    //第三步：图像操作
    //亮度
    int ld = 60;
    //创建新的图片
    Mat mat_image_clone = mat_image_dst.clone();
    for (int i = 0; i < height; i ++) {
        for (int j = 0; j < width; j ++) {
            //1.获取红色的值 -> thisR -> 修改
            //mat_image_clone.at<Vec3b>)(i,j)：获取像素点
            //mat_image_clone.at<Vec3b>)(i,j)[0]:获取像素点颜色值 -> R
            //控制范围 saturate_cast<uchar>
            mat_image_clone.at<Vec3b>(i,j)[0] = saturate_cast<uchar>(mat_image_dst.at<Vec3b>(i,j)[0] + ld);
            
            //2.获取绿色 -> 修改
            mat_image_clone.at<Vec3b>(i,j)[1] = saturate_cast<uchar>(mat_image_dst.at<Vec3b>(i,j)[1] + ld);
            
            //3.获取蓝色 -> 修改
            mat_image_clone.at<Vec3b>(i,j)[2] = saturate_cast<uchar>(mat_image_dst.at<Vec3b>(i,j)[2] + ld);
            //到这里只有3/4的图片美白了
            //解决平台的兼容性
            //mat_image_clone 换成 mat_image_dst
        }
    }
    //第四步：将opencv的图片 -> ios图片
    return MatToUIImage(mat_image_clone);
}




@end
