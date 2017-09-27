//
//  WFImageScrollView.h
//  news
//
//  Created by mba on 14-12-31.
//  Copyright (c) 2014年 mbalib. All rights reserved.
//

#define IPHONE_WIDTH    [UIScreen mainScreen].bounds.size.width
#define IPHONE_HEIGHT   [UIScreen mainScreen].bounds.size.height

#import <UIKit/UIKit.h>

typedef void(^WFImageViewDownloadCompletion)(void);

@protocol WFImageScrollViewDelegate <NSObject>

@optional
- (void)imageScrollView:(int)index;

- (void)imageScrollView:(int)index withImageview:(UIImageView *)imgView;

- (void)imageScrollView:(int)index withImgURL:(NSString *)imgURL;

@end

@interface WFImageScrollView : UIScrollView<UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *imgURLDataArray;


@property (weak, nonatomic) id<WFImageScrollViewDelegate> myDelegate;

//@property (strong, nonatomic) 

- (void)_initParam:(NSMutableArray *)dataArray index:(NSInteger)index;

@end
