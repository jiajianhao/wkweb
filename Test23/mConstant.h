//
//  mConstant.h
//  Test23
//
//  Created by 小雨科技 on 2017/8/11.
//  Copyright © 2017年 jiajianhao. All rights reserved.
//

#define _WIDTH [[UIScreen mainScreen]                   bounds].size.width
#define _HEIGHT [[UIScreen mainScreen]                  bounds].size.height
//宽高比
#define _SCALEWIDTH (_WIDTH /                           375.0)
#define _SCALEHEIGHT (_HEIGHT /                         667.0)

#define AUTO_ScaleW(width) width*_SCALEWIDTH
#define AUTO_ScaleH(height) height*_SCALEHEIGHT
#define AUTO_Scale_Text(width) (_SCALEWIDTH<=375.0)?width:width*_SCALEWIDTH
#define AUTO_Scale_Font(mFont) (_SCALEWIDTH>=375.0)?mFont:mFont*_SCALEWIDTH


#define kStatusBarHeight         20
#define kNavigationBarHeight     44
#define kNavigationheightForIOS7 64
#define kNavBarHeightWithStatusBar 64
#define kContentHeight           (kApplicationHeight - kNavigationBarHeight)
#define kTabBarHeight            49
