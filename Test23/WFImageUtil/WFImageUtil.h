//
//  WFImageAtlas.h
//  IT资讯
//
//  Created by wolvesqun on 14-8-9.
//  Copyright (c) 2014年 wolvesqun. All rights reserved.
//



#import <Foundation/Foundation.h>

/*** 图片MIMEType ***/
#define kMIMETypeImg_JPEG  @"image/jpeg"
#define kMIMETypeImg_GIF  @"image/gif"
#define kMIMETypeImg_PNG  @"image/png"
#define kMIMETypeImg_TIFF  @"image/tiff"
#define KMIMETypeImg_BMP  @"image/bmp"
typedef NSString KMEMETypeImg;

/*** 显示图册动画类型 ***/
typedef enum : NSUInteger {
    WFImageShowType_Default = 0, // 默认
    WFImageShowType_Fade = 0,    // 淡入淡出
    WFImageShowType_Expand = 1,  // 展开
    WFImageShowType_Shrink = 2,  // 缩小
} WFImageShowType;

@protocol WFImageUtilDelegate <NSObject>

- (void)imageUtilForCloseFrame;

@end

/**
 * 图册
 */
@interface WFImageUtil : NSObject

/**
 *  显示图册
 *
 *  @param imageURL 图片地址 -》类型为字符串
 */
+ (void)showImgWithImageURL:(NSString *)imageURL
                 myDelegate:(id<WFImageUtilDelegate>)myDelegate;

/**
 *  显示图册
 *  
 *  @param imageURLArray 图片地址 -》类型为字符串
 */
+ (void)showImgWithImageURLArray:(NSMutableArray *) imageURLArray
                           index:(NSInteger)index
                      myDelegate:(id<WFImageUtilDelegate>)myDelegate;

/**
 *  显示图册
 *
 *  @param imageURLArray 图片地址 -》类型为字符串
 *
 *  @param type 显示动画类型
 *
 *  @param index 指定请求哪一张图片
 *
 *  @param myDelegate 关闭图册回调action
 */
+ (void)showImgWithImageURLArray:(NSMutableArray *) imageURLArray
                            type:(WFImageShowType)type
                           index:(NSInteger)index
                      myDelegate:(id<WFImageUtilDelegate>)myDelegate;

/**
 *  判断是否为图片请求
 *
 *  @param requestURL 请求字符串
 */
+ (BOOL)isImageURL:(NSString *)requestURL;

/**
 *  获取图片请求的MIMEType , 构建缓存时可以用到
 *
 *  @param request 请求地址
 */
+ (NSString *)getMIMETypeImg:(NSURLRequest *)request;


@end


