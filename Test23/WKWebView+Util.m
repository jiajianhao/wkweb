//
//  WKWebView+Util.m
//  Test23
//
//  Created by 小雨科技 on 2017/9/26.
//  Copyright © 2017年 jiajianhao. All rights reserved.
//

#import "WKWebView+Util.h"
#import "objc/runtime.h"
@implementation WKWebView (Util)
static char imgUrlArrayKey;
- (void)setMethod:(NSArray *)imgUrlArray
{
    objc_setAssociatedObject(self, &imgUrlArrayKey, imgUrlArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)getImgUrlArray
{
    return objc_getAssociatedObject(self, &imgUrlArrayKey);
}
@end
