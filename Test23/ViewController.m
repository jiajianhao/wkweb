//
//  ViewController.m
//  Test23
//
//  Created by 小雨科技 on 2017/8/11.
//  Copyright © 2017年 jiajianhao. All rights reserved.
//

#import "ViewController.h"
#import "HZBaseWebViewController.h"
#import "mConstant.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    HZBaseWebViewController*vc=[[HZBaseWebViewController alloc]init];
    vc.titlename=@"web";
    vc.urlString=@"https://www.baidu.com";
    [self.navigationController pushViewController:vc animated:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
