//
//  WFImageScrollView.m
//  news
//
//  Created by mba on 14-12-31.
//  Copyright (c) 2014年 mbalib. All rights reserved.
//

/*** tag 初始化值 ***/
#define kWFImageScrollView_InitValue 1000

#import "WFImageScrollView.h"
#import "UIImageView+WebCache.h"

//#import "UIImageView+WFImageView.h"
//#import "WebViewURLCached.h"
//#import "WebViewCachedData.h"
//#import "WFGlobalUICommon.h"
//#import "WebViewCachedData.h"
//#import "WFConfigHelper.h"


@interface WFImageScrollView ()

@property (strong, nonatomic) NSMutableDictionary *imgDict;

@property (assign, nonatomic) NSInteger currentIndex;

@property (assign, nonatomic) BOOL bChange;

@property (strong,nonatomic) UIButton *btn;

@end

@implementation WFImageScrollView


- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame])
    {
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.delegate = self;
        self.backgroundColor = [UIColor blackColor];
        self.pagingEnabled = YES;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)_initParam:(NSMutableArray *)dataArray index:(NSInteger)index;
{
    // *** 自身
    self.imgURLDataArray = dataArray;
    self.contentSize = CGSizeMake(IPHONE_WIDTH * dataArray.count, IPHONE_HEIGHT);
    self.contentOffset = CGPointMake(IPHONE_WIDTH * index, 0);
    
    self.currentIndex = index;
    
    
    
    // ***
    self.imgDict = [NSMutableDictionary new];
    
    [self addImage:[dataArray objectAtIndex:index] currentIndex:index];
    
    [self setCallbackCurrentImageView:(int)index];
    
}


#pragma mark - 添加图片
- (void)addImage:(NSString *)imgURL currentIndex:(NSInteger)currentIndex
{
    if(![self.imgDict objectForKey:[NSString stringWithFormat:@"%d-%d", (int)kWFImageScrollView_InitValue, (int)currentIndex]])
    {
        UIScrollView *imgScrollView = [self createScrollView:currentIndex];
        [self addSubview:imgScrollView];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT)];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.userInteractionEnabled = YES;
        imgView.tag = kWFImageScrollView_InitValue + currentIndex;
        
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityView.center = imgScrollView.center;
        [imgView addSubview:activityView];
        [activityView startAnimating];
        // * 定制
//        [imgView sd_setImageWithURL:[NSURL URLWithString:imgURL]
//                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
//         {
//             [activityView stopAnimating];
//             [activityView removeFromSuperview];
//         }];
        [imgView sd_setImageWithURL:[NSURL URLWithString:imgURL] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL){
            [activityView stopAnimating];
            [activityView removeFromSuperview];
        }];
 
      //  [imgView setImageWithURL:[NSURL URLWithString:imgURL]] ;
        [imgScrollView addSubview:imgView];
        
        [self.imgDict setObject:imgView forKey:[NSString stringWithFormat:@"%d-%d", (int)kWFImageScrollView_InitValue, (int)currentIndex]];

    }
}

#pragma mark - 创建scrollView
- (UIScrollView *)createScrollView:(NSInteger)index {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(IPHONE_WIDTH * index, 0, IPHONE_WIDTH, IPHONE_HEIGHT)];
    scrollView.maximumZoomScale = 2.0;
    scrollView.minimumZoomScale = 1.0;
    scrollView.delegate = self;
    return scrollView;
}

#pragma mark - scrollView
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    UIImageView *imgView = [self.imgDict objectForKey:[NSString stringWithFormat:@"%d-%d", (int)kWFImageScrollView_InitValue, (int)self.currentIndex]];
    if(imgView == nil)
    {
        //NSLog(@"================ img nil");
    }
    return imgView;
}

#pragma mark - 实现图片在缩放过程中居中
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
    UIImageView *imgView = [self.imgDict objectForKey:[NSString stringWithFormat:@"%d-%d", (int)kWFImageScrollView_InitValue, (int)self.currentIndex]];
    if(imgView != nil)
    {
        
        CGSize boundsSize = scrollView.bounds.size;
        CGRect imgFrame = imgView.frame;
        CGSize contentSize = scrollView.contentSize;
        
        CGPoint centerPoint = CGPointMake(contentSize.width/2, contentSize.height/2);
        
        // center horizontally
        if (imgFrame.size.width <= boundsSize.width)
        {
            centerPoint.x = boundsSize.width/2;
        }
        
        // center vertically
        if (imgFrame.size.height <= boundsSize.height)
        {
            centerPoint.y = boundsSize.height/2;
        }
        
        imgView.center = centerPoint;
        
    }
    
}

- (void)moveLastNextImage:(int)index bStart:(BOOL)bStart
{
    
    UIImageView *lastImage = [self.imgDict objectForKey:[NSString stringWithFormat:@"%d-%d", (int)kWFImageScrollView_InitValue, (int)self.currentIndex - 1]];
    UIImageView *nextImage = [self.imgDict objectForKey:[NSString stringWithFormat:@"%d-%d", (int)kWFImageScrollView_InitValue, (int)self.currentIndex + 1]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(bStart)
        {
            if(lastImage != nil) lastImage.transform = CGAffineTransformMakeScale(0.9, 0.9);
            if(nextImage != nil) nextImage.transform = CGAffineTransformMakeScale(0.9, 0.9);
        }
        else
        {
            if(lastImage != nil) lastImage.transform = CGAffineTransformMakeScale(1.0, 1.0);
            if(nextImage != nil) nextImage.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }
    });
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    [self.btn removeFromSuperview];
}

#pragma mark -
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = fabsf(scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame));
    self.currentIndex = index;
    
    if(index < self.imgURLDataArray.count)
    {
        [self addImage:[self.imgURLDataArray objectAtIndex:index] currentIndex:index];
        
        if([self.myDelegate respondsToSelector:@selector(imageScrollView:)])
        {
            [self.myDelegate imageScrollView:index];
        }
        
        [self setCallbackCurrentImageView:index];
    }
    
}

- (void)setCallbackCurrentImageView:(int)currentIndex
{
    if([self.myDelegate respondsToSelector:@selector(imageScrollView:withImgURL:)])
    {
        [self.myDelegate imageScrollView:currentIndex withImgURL:[self.imgURLDataArray objectAtIndex:currentIndex]];

    }
}


@end
