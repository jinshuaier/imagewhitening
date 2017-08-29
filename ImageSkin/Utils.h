//
//  Utils.h
//  imageDispose
//
//  Created by 胡高广 on 2017/8/29.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#ifndef Utils_h
#define Utils_h

//1.获取红色的值 -> thisR
//thisR = 218
//color = 4294833370
#define Mask8(x) (x & 0xFF)
//第一步：将color和0xFF -> 转成二进制
//color =  11111111 11111101 11110100 11011010
//0xFF =   11111111
//第二步：进行逻辑运算 -> "&"(相同位同为1，则为1，否则为0)
//color =  11111111 11111101 11110100 11011010
//                   &
//0xFF =   00000000 00000000 00000000 11111111
//thisR =  00000000 00000000 00000000 11011010 = 218


#define Red(x) ( Mask8(x))

//第一步：将color和0xFF -> 转成二进制
//color =  11111111 11111101 11110100 11011010
//0xFF =   11111111

//第二步：进行移位运算 -> ">>"（向右移动8位）
//color =  11111111 11111101 11110100 11011010
//                >>8
//color =  11111111 11111101 11110100

//第三步：进行逻辑运算 -> "&"(相同位同为1，则为1，否则为0)
//color =  11111111 11111101 11110100
//                   &
//0xFF =   00000000 00000000 11111111
//thisR =  00000000 00000000 11110100 = 244

//获取绿色值 -> thisG
#define Green(x) (Mask8 (x >> 8)) //像右移动8位


//获取蓝色值 -> thisB 向右移动16位 253
#define Blue(x) (Mask8 (x >> 16))


//获取透明度值 -> thisA 向右移动16位 255
#define Alahp(x) (Mask8 (x >> 24))

//最后一步：修改像素点的值
#define RGBAMake(r, g, b, a)  (Mask8(r) | Mask8(g) << 8 | Mask8(b) << 16 | Mask8(a) << 24)

#endif /* Utils_h */
