//
//  WFImageAtlas.m
//  IT资讯
//
//  Created by wolvesqun on 14-8-9.
//  Copyright (c) 2014年 wolvesqun. All rights reserved.
//

#define WF_DEVICE_IPad ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)

/*** 文件 ***/
#define WFIMAGEUTIL_RS_FILE @"WFImageUtil_Rs.plist"

/*** 图片后缀key ***/
#define WFIMAGEUTIL_IMG_SUBFFIX_KEY @"ImageSuffixKey"

#define IMGATAQLS_CONTAINER_SIZE_HEIGHT 300

/*** 动画时间 ***/
#define kWFImageUtil_Animate_Time 0.3

#import "WFImageUtil.h"
//#import "WFCommonUtil.h"
//#import "WFProgressHUD.h"
//#import "AdapterClass.h"
//#import "WFConfigHelper.h"
#import "UIImageView+WebCache.h"
#import "WFImageScrollView.h"
//#import "WebViewURLCached.h"
//#import "WebViewCachedData.h"
#import "SVProgressHUD.h"

// ============================== WFImageAtlasUtil end =======================

@interface WFImageAtlasUtil : NSObject<WFImageScrollViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate>

+ (WFImageAtlasUtil *)sharedInstances;

/*** 动画类型 ***/
@property (assign, nonatomic) WFImageShowType type;

/*** 图片滚动视图 ***/
@property (strong, nonatomic) WFImageScrollView *imgScollView;
@property (strong, nonatomic) UIView *rootView;


@property (strong,nonatomic) UIButton *btn;

/*** 图片索引位置 ***/
@property (strong, nonatomic) UILabel *lbImgIndex;

@property (assign, nonatomic) NSInteger totalPage;

@property (assign, nonatomic) id<WFImageUtilDelegate> myDelegate;

@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (strong, nonatomic) UIAlertView *alertView;
//图片地址
@property (strong, nonatomic) NSString *currentImgURL;

@end

@implementation WFImageAtlasUtil

#pragma mark - 单例
static WFImageAtlasUtil *imgAtlasUtil;
+ (WFImageAtlasUtil *)sharedInstances {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(imgAtlasUtil == nil) {
            imgAtlasUtil = [WFImageAtlasUtil new];
        }
    });
    return imgAtlasUtil;
}

/**
 *  显示图册
 *
 *  @param imageURLArray 图片地址 -》类型为字符串
 *
 *  @param type 显示动画类型
 *
 *  @param indexImageURLKey 指定显示请求地址key，没有默认显示第一张
 */
- (void)_showImgWithImageURLArray:(NSMutableArray *) imageURLArray type:(WFImageShowType)type index:(NSInteger)index  {
    // *** 记录参数
    self.type = type;
    
    // ***
    self.rootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT)];
    self.rootView.userInteractionEnabled = YES;
//    self.rootView.alpha = 0;
    [[self getWindow] addSubview:self.rootView];
    // * 关闭图册手势
    UITapGestureRecognizer *closeAtlasFrame = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAtlas)];
    [self.rootView addGestureRecognizer:closeAtlasFrame];
    
   // 长按保存图片手势
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] init];
    longpress.minimumPressDuration=0.5;
    longpress.allowableMovement=50;
    [self.rootView addGestureRecognizer:longpress];
    [longpress addTarget:self action:@selector(longPressGesture)];
    
    // *** 图片滚动视图2
    self.imgScollView = [[WFImageScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.imgScollView.myDelegate = self;
    [self.rootView addSubview:self.imgScollView];
    [self.imgScollView _initParam:imageURLArray index:index];
    
    
    self.totalPage = imageURLArray.count;
    [self _initLabel:self.totalPage currentPage:index];
    
    // *** 显示图册
    [self showAtlas];
    
//    [UIView animateWithDuration:0.5 animations:^{
//        self.rootView.alpha = 1;
//    }];
}

#pragma mark - 初始化显示控件
- (void)_initLabel:(NSInteger)totalPage currentPage:(NSInteger)currentPage {
    if(self.lbImgIndex == nil)
    {
        self.lbImgIndex = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 100)];
        self.lbImgIndex.textColor = [UIColor whiteColor];
        self.lbImgIndex.backgroundColor = [UIColor clearColor];
        self.lbImgIndex.textAlignment = NSTextAlignmentCenter;
//        self.lbImgIndex = [WFGlobalUICommon createLabel:@""
//                                                  frame:CGRectMake(0, IPHONE_HEIGHT - 100, IPHONE_WIDTH, 100)
//                                              textColor:[UIColor whiteColor]
//                                        backgroundColor:[UIColor clearColor]
//                                          textAlignment:NSTextAlignmentCenter
//                                                   font:nil];
        [self.rootView addSubview:self.lbImgIndex];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.lbImgIndex.text = [NSString stringWithFormat:@"%d/%d", (int)currentPage + 1, (int)totalPage];
    });
    
    //保存图片按钮
    [self createSavaImageBtn];
    
}


#pragma mark - 保存图片按钮
-(void)createSavaImageBtn
{
    if (self.btn == nil) {
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn.frame = CGRectMake(IPHONE_WIDTH - 60, IPHONE_HEIGHT - 60, 25, 20);
        [self.btn addTarget:self action:@selector(saveOperation) forControlEvents:UIControlEventTouchUpInside];
        [self.btn setImage:[UIImage imageNamed:@"btn_save_pic"] forState:UIControlStateNormal];
    }
    [self.rootView addSubview:self.btn];
    
}

#pragma mark - 切换
- (void)imageScrollView:(int)index
{
    [self _initLabel:self.totalPage currentPage:index];
}


- (void)imageScrollView:(int)index withImgURL:(NSString *)imgURL
{
    self.currentImgURL = imgURL;
}

#pragma mark - 打开图册
- (void)showAtlas
{
    switch (self.type) {
        case WFImageShowType_Fade:
        {
            self.rootView.alpha = 0;
            // *** 消失动画
            [UIView animateWithDuration:kWFImageUtil_Animate_Time animations:^{
                self.rootView.alpha = 1;
            } completion:nil];
            
            break;
        }
        case WFImageShowType_Shrink:
        {
            self.rootView.alpha = 0;
            self.rootView.transform = CGAffineTransformMakeScale(1.5, 1.5);
            [UIView animateWithDuration:kWFImageUtil_Animate_Time animations:^
            {
                self.rootView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                self.rootView.alpha = 1;
            }];
            break;
        }
        case WFImageShowType_Expand:
        {
            self.rootView.alpha = 0;
            self.rootView.transform = CGAffineTransformMakeScale(0.1, 0.1);
            [UIView animateWithDuration:kWFImageUtil_Animate_Time animations:^
             {
                 self.rootView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                 self.rootView.alpha = 1;
             }];
            break;
        }
            
    }
}

#pragma mark - 关闭图册
- (void)closeAtlas {
    switch (self.type) {
        case WFImageShowType_Fade:
        {
            // *** 消失动画
            [UIView animateWithDuration:kWFImageUtil_Animate_Time animations:^{
                self.rootView.alpha = 0;
            } completion:^(BOOL finished) {
                
                [self.lbImgIndex removeFromSuperview];
                self.lbImgIndex = nil;
                [self.rootView removeFromSuperview];
                self.rootView = nil;
                
                if(self.myDelegate != nil && [self.myDelegate respondsToSelector:@selector(imageUtilForCloseFrame)])
                {
                    [self.myDelegate imageUtilForCloseFrame];
                }
                
            }];
            
            break;
        }
        case WFImageShowType_Shrink:
        {
            [UIView animateWithDuration:kWFImageUtil_Animate_Time animations:^
             {
                 self.rootView.transform = CGAffineTransformMakeScale(1.5, 1.5);
                 self.rootView.alpha = 0;
             }completion:^(BOOL finished) {
                 
                 [self.lbImgIndex removeFromSuperview];
                 self.lbImgIndex = nil;
                 [self.rootView removeFromSuperview];
                 self.rootView = nil;
                 
                 if(self.myDelegate != nil && [self.myDelegate respondsToSelector:@selector(imageUtilForCloseFrame)])
                 {
                     [self.myDelegate imageUtilForCloseFrame];
                 }
                 
             }];
            break;
        }
        case WFImageShowType_Expand:
        {
            [UIView animateWithDuration:kWFImageUtil_Animate_Time animations:^
             {
                 self.rootView.transform = CGAffineTransformMakeScale(0.1, 0.1);
                 self.rootView.alpha = 0;
             }completion:^(BOOL finished) {
                 
                 [self.lbImgIndex removeFromSuperview];
                 self.lbImgIndex = nil;
                 [self.rootView removeFromSuperview];
                 self.rootView = nil;
                 
                 if(self.myDelegate != nil && [self.myDelegate respondsToSelector:@selector(imageUtilForCloseFrame)])
                 {
                     [self.myDelegate imageUtilForCloseFrame];
                 }
                 
             }];
            break;
        }
            
    }
}


#pragma mark - 长按·保存图片
-(void)longPressGesture
{
    if (WF_DEVICE_IPad) {
        if (self.alertView == nil) {
            self.alertView = [[UIAlertView alloc] initWithTitle:@"将图片保存到照片库" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存图片", nil];
        }
        [self.alertView show];
        
    }else{
        if (self.actionSheet == nil) {
            self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"将图片保存到照片库" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存图片" otherButtonTitles: nil];
        }
        [self.actionSheet showInView:self.imgScollView];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self saveOperation];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self saveOperation];
    }
}

#pragma mark - 保存操作
-(void)saveOperation
{
//#warning 保存图片 self.currentImgURL 有这个地址 -》自行实现
    UIImage *img = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.currentImgURL];
    
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
//    if([WebViewURLCached checkCacheExist:self.currentImgURL])
//    {
//        WebViewCachedData *webViewCacheData = [WebViewURLCached getCache:self.currentImgURL];
//        //将图片保存到图库
//        UIImageWriteToSavedPhotosAlbum([[UIImage alloc] initWithData:webViewCacheData.data], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//    }else{
//        
//    }
}

#pragma mark - 保存图片回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
#warning 保存成功提示 -》请自行实现
    if (error == nil){//保存成功
//        [WFProgressHUD showToast:[kWFConfigHelper readSimpleStringWithKey:@"kWF_Save_Alert_Success" configFilename:kWF_ConfigFile_Toast defaultValue:nil]];
//    }else{//保存失败
//        [WFProgressHUD showToast:[kWFConfigHelper readSimpleStringWithKey:@"kWF_Save_Alert_Error" configFilename:kWF_ConfigFile_Toast defaultValue:nil]];
        [SVProgressHUD showImage:nil status:@"保存成功"];
    }
}

#pragma mark - window
- (UIWindow *)getWindow {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window makeKeyAndVisible];
    return window;
}

@end

// ============================== WFImageAtlasUtil end =======================

@implementation WFImageUtil


#pragma mark - 显示图册
/**
 *  显示图册
 *
 *  @param imageURL 图片地址 -》类型为字符串
 */

+ (void)showImgWithImageURL:(NSString *)imageURL
                 myDelegate:(id<WFImageUtilDelegate>)myDelegate
{
    [self showImgWithImageURLArray:[NSMutableArray arrayWithObject:imageURL] type:WFImageShowType_Fade index:0 myDelegate:myDelegate];

}

/**
 *  显示图册
 *
 *  @param imageURLArray 图片地址 -》类型为字符串
 */
+ (void)showImgWithImageURLArray:(NSMutableArray *) imageURLArray
                           index:(NSInteger)index
                      myDelegate:(id<WFImageUtilDelegate>)myDelegate
{
    [self showImgWithImageURLArray:imageURLArray type:WFImageShowType_Fade index:index myDelegate:myDelegate];
}

/**
 *  显示图册
 *
 *  @param imageURLArray 图片地址 -》类型为字符串
 *
 *  @param type 显示动画类型
 *
 *  @param indexImageURLKey 指定显示请求地址key，没有默认显示第一张
 */
+ (void)showImgWithImageURLArray:(NSMutableArray *) imageURLArray
                            type:(WFImageShowType)type
                           index:(NSInteger)index
                      myDelegate:(id<WFImageUtilDelegate>)myDelegate
{
    if(imageURLArray == nil || imageURLArray.count == 0) return;
    [WFImageAtlasUtil sharedInstances].myDelegate = myDelegate;
    [[WFImageAtlasUtil sharedInstances] _showImgWithImageURLArray:imageURLArray type:type index:index];
    
    
}

#pragma mark - 判断是否为图片请求
static NSArray *imgSubffixArray;
+ (BOOL)isImageURL:(NSString *)requestURL {
    if(imgSubffixArray == nil) {
        imgSubffixArray = [[self getDict] objectForKey:WFIMAGEUTIL_IMG_SUBFFIX_KEY];
    }
    
    for (NSString *imgSubffix in imgSubffixArray) {
        NSRange imgRange = [requestURL rangeOfString:imgSubffix];
        if(imgRange.length > 0) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - 获取图片MIMEType
+ (NSString *)getMIMETypeImg:(NSURLRequest *)request {
    NSRange pngRange = [[request URL].absoluteString rangeOfString:@".png"];
    if(pngRange.length > 0) return kMIMETypeImg_PNG;
    
    NSRange gifRange = [[request URL].absoluteString rangeOfString:@".gif"];
    if(gifRange.length > 0) return kMIMETypeImg_GIF;
    
    NSRange jpgRange = [[request URL].absoluteString rangeOfString:@".jpg"];
    NSRange jpegRange = [[request URL].absoluteString rangeOfString:@".jpeg"];
    if(jpgRange.length > 0 || jpegRange.length > 0) return kMIMETypeImg_JPEG;
    
    NSRange bmpRange = [[request URL].absoluteString rangeOfString:@".bmp"];
    if(bmpRange.length > 0) return KMIMETypeImg_BMP;
    
    return nil;
}

#pragma mark - 资源文件获取
+ (NSDictionary *)getDict {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:WFIMAGEUTIL_RS_FILE ofType:nil];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dict;
}




@end
