//
//  NCBaseViewController.h
//  NuanChou
//
//  Created by Jia jianhao on 09/05/2017.
//  Copyright © 2017 Jia jianhao. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface NCBaseViewController : UIViewController
{
    BOOL isLoading;
}
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIView *barView;
@property (nonatomic, strong) UIButton* myRightBtn;
@property (nonatomic, strong) UIView* baseDataEmptyView;
@property (nonatomic, strong) UIView* baseNetworkConnectionFailedView;
@property (nonatomic, strong) UIButton* baseNetworkConnectionFailedBtn;
- (void)customNaviItemWithBarColor:(UIColor *)barColor
                             title:(NSString *)title
                 useDefaultBackBtn:(BOOL)useDefault
                           leftBtn:(UIButton *)leftBtn
                          rightBtn:(UIButton *)rightBtn
                   hasLineAtBottom:(BOOL)hasLine;

/*
 * Custom Navigation Bar With TitleTopView
 * @params      titleTopView - for switch button View in navigation bar
 other params - the same as the aboving function
 */
 
/*
 * Setup View BackgroundColor if it is not the same as default color _BACKGROUND_COLOR
 *
 */
- (void)setViewBackgroundColor:(UIColor *)bgColor;

/*
 * Setup Pop Gesture, default is YES
 *
 */
- (void)setPopGestureRecognizer:(BOOL)hasPopGesture;
- (void)tabbarDoSelectIndex:(NSInteger)tag;


 @end


