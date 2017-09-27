//
//  ViewController.m
//  Test23
//
//  Created by Jia jianhao on 2017/8/11.
//  Copyright © 2017年 jiajianhao. All rights reserved.
//

#import "ViewController.h"
#import "HZBaseWebViewController.h"
#import "mConstant.h"
#import "WKWebView+Util.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   

}
-(IBAction)btnOnCLick:(UIButton*)sender{
    if (sender.tag==1) {
        HZBaseWebViewController*vc=[[HZBaseWebViewController alloc]init];
        vc.titlename=@"web";
        vc.urlString=@"https://www.baidu.com";
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if (sender.tag==2) {
         NSString* superiorityDic1 = @" <div><p style=\"text-align:center;\"><img src=\"http://pic.chinaz.com/2017/0926/17092617330681147.jpg\"/></p><p>This is good <br/></p></div>";
        HZBaseWebViewController*vc=[[HZBaseWebViewController alloc]init];
        vc.htmlString=superiorityDic1;
        vc.useHtml=YES;
         [self.navigationController pushViewController:vc animated:YES];
        
    
        

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
