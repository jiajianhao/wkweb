//
//  NCBaseViewController.m
//  NuanChou
//
//  Created by Hui Jiang on 09/05/2017.
//  Copyright © 2017 Hui Jiang. All rights reserved.
//
//宽高


#import "NCBaseViewController.h"
#import "mConstant.h"

@interface NCBaseViewController ()

@end


@implementation NCBaseViewController
@synthesize baseDataEmptyView;
@synthesize baseNetworkConnectionFailedView;
@synthesize baseNetworkConnectionFailedBtn;
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
//    self.view.backgroundColor = _BACKGROUND_COLOR;
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup Custome NaviBar
- (void)customNaviItemWithBarColor:(UIColor *)barColor
                             title:(NSString *)title
                 useDefaultBackBtn:(BOOL)useDefault
                           leftBtn:(UIButton *)leftBtn
                          rightBtn:(UIButton *)rightBtn
                   hasLineAtBottom:(BOOL)hasLine
{
    
    self.barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _WIDTH, kNavBarHeightWithStatusBar)];
    self.barView.backgroundColor = barColor;
    [self.view addSubview:self.barView];
    
    if (useDefault) {
        
        UIButton *defaultLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        defaultLeftBtn.frame = CGRectMake(10, 20, 40, 40);
        
//        if ([barColor isEqual:[UIColor whiteColor]]) {
//            [defaultLeftBtn setImage:IMAGE(@"common_back_black") forState:UIControlStateNormal];
//        } else {
//            [defaultLeftBtn setImage:IMAGE(@"Common_back_white") forState:UIControlStateNormal];
//        }
        [defaultLeftBtn addTarget:self action:@selector(backBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.barView addSubview:defaultLeftBtn];
        
    } else {
        if (leftBtn != nil) {
            [leftBtn addTarget:self action:@selector(backBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.barView addSubview:leftBtn];
        }
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    }
    
    if (title) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, _WIDTH-60-60, 44)];
        if ([barColor isEqual:[UIColor whiteColor]]) {
            _titleLbl.textColor = [UIColor blackColor];
        } else {
            _titleLbl.textColor = [UIColor whiteColor];
        }
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        [_titleLbl setFont:[UIFont systemFontOfSize:18]];
        _titleLbl.text = title;
        [self.barView addSubview:_titleLbl];
    }
    
     //    if (hasLine) {
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, _WIDTH, 0.5)];
//        lineView.backgroundColor = _MAINCOLOR_light_hui;
//        [self.barView addSubview:lineView];
//    }
}



#pragma mark - Setup View BG Color, default _BACKGROUND_COLOR
- (void)setViewBackgroundColor:(UIColor *)bgColor
{
    self.view.backgroundColor = bgColor;
}

#pragma mark - Disable or Enable Pop Gesture, default enable
- (void)setPopGestureRecognizer:(BOOL)hasPopGesture
{
    self.navigationController.interactivePopGestureRecognizer.enabled = hasPopGesture;
}

#pragma mark - NaviBar Button Event
- (void)backBtnOnClick:(id)sender
{
     [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnOnClick:(id)sender
{
    
}
 @end
