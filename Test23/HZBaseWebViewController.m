//
//  HZBaseWebViewController.m
//  NuanChou
//
//  Created by 小雨科技 on 2017/7/31.
//  Copyright © 2017年 Hui Jiang. All rights reserved.
//
//WKNavigationDelegate 主要用于页面跳转、加载处理等
//WKUIDelegate 主要用于处理js脚本、警告框、确认框等
//使用WKUserContentController实现js native交互。

#import "HZBaseWebViewController.h"
#import <WebKit/WebKit.h>
#import "mConstant.h"

@interface HZBaseWebViewController ()<WKNavigationDelegate, WKUIDelegate,WKScriptMessageHandler, UIGestureRecognizerDelegate>

@property (strong, nonatomic) WKWebView *webView;
@property (nonatomic, strong) WKWebViewConfiguration *wkConfig;
@property (nonatomic, strong) WKUserContentController* userContentController;

@property (nonatomic, strong) UIProgressView *progressView;


@end

@implementation HZBaseWebViewController
- (WKWebViewConfiguration *)wkConfig {
    if (!_wkConfig) {
        //WKWebView的环境配置，默认配置可以修改
        _wkConfig = [[WKWebViewConfiguration alloc] init];
        _wkConfig.allowsInlineMediaPlayback = YES;//打开内嵌视频的播放
        _wkConfig.allowsPictureInPictureMediaPlayback = YES;//允许画中画视频，其实就是小窗播放
        
        _userContentController =[[WKUserContentController alloc]init];
        _wkConfig.userContentController=_userContentController;
    }
    return _wkConfig;
}
- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_userContentController removeScriptMessageHandlerForName:@"sayhello"];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self customNaviItemWithBarColor:[UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0]
                               title:self.titlename
                   useDefaultBackBtn:YES
                             leftBtn:nil
                            rightBtn:nil
                     hasLineAtBottom:YES];
 
    // Do any additional setup after loading the view.
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kNavBarHeightWithStatusBar, _WIDTH, _HEIGHT-kNavBarHeightWithStatusBar) configuration:self.wkConfig];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    [_webView.scrollView setAlwaysBounceVertical:YES];
    [_webView setAllowsBackForwardNavigationGestures:YES];
    //注册方法
    [_userContentController addScriptMessageHandler:self name:@"sayhello"];

    [self.view addSubview:_webView];
    
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, 2)];
    self.progressView.backgroundColor = [UIColor blueColor];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:self.progressView];
    
    /*
     *3.添加KVO，WKWebView有一个属性estimatedProgress，就是当前网页加载的进度，所以监听这个属性。
     */
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
 }
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- 返回按钮
- (void)backBtnOnClick:(id)sender
{
 //    if ([self.webView.realWebView isKindOfClass:[WKWebView class]]) {
//        ((WKWebView *) self.webView.realWebView).allowsBackForwardNavigationGestures = NO;
//    }
    
    if (self.webView.canGoBack) {
        [self.webView goBack];

    }
    else{
        [self.navigationController popViewControllerAnimated:YES];

    }
    
//    if (self.webView.backForwardList.backList.count!=0) {
//        [self.webView goBack];
//    }
//    else
//        [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - WKNavigationDelegate

/**
 *  页面开始加载时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"开始加载网页");
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
}

/**
 *  当内容开始返回时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
    NSLog(@"%s", __FUNCTION__);
}

/**
 *  页面加载完成之后调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    NSLog(@"didFinishNavigation: %s", __FUNCTION__);
 }

/**
 *  加载失败时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 *  @param error      错误
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"error:--- %@",error);
    NSLog(@"%s", __FUNCTION__);
}

/**
 *  接收到服务器跳转请求之后调用
 *
 *  @param webView      实现该代理的webview
 *  @param navigation   当前navigation
 */
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
    NSLog(@"%s", __FUNCTION__);
}

/**
 *  在收到响应后，决定是否跳转
 *
 *  @param webView            实现该代理的webview
 *  @param navigationResponse 当前navigation
 *  @param decisionHandler    是否跳转block
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
//    // 如果响应的地址是百度，则允许跳转
//    if ([navigationResponse.response.URL.host.lowercaseString isEqual:@"www.baidu.com"]) {
//        
//        // 允许跳转
  
        decisionHandler(WKNavigationResponsePolicyAllow);
//        return;
//    }
//    // 不允许跳转
//    decisionHandler(WKNavigationResponsePolicyCancel);
}

/**
 *  在发送请求之前，决定是否跳转
 *
 *  @param webView          实现该代理的webview
 *  @param navigationAction 当前navigation
 *  @param decisionHandler  是否调转block
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView evaluateJavaScript:@"var a = document.getElementsByTagName('a');for(var i=0;i<a.length;i++){a[i].setAttribute('target','');}" completionHandler:nil];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
 
}


#pragma mark -- WKUIdelegate

/**
  进入一个新的webview
 */
-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if (!navigationAction.targetFrame.isMainFrame) {
        [_webView loadRequest:navigationAction.request];
    }
    return nil;
    //当html源代码中，一个可点击的标签带有target='_blank'时，导致WKWebView无法加载点击后的网页的问题。
    //如果你发现你的WKWebView中的网页，点击某个按钮无反应。
    //上面的那段代码可以用来处理点击按钮无法加载网页问题，因为它是强制打开请求链接的，不管点击事件了
    
    //ps:如果request的url是空的呢？？？
    //答：那就把_blank清除掉...见最下面
    
    
}
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler();
//    }])];
//    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler(NO);
//    }])];
//    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler(YES);
//    }])];
//    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.text = defaultText;
//    }];
//    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler(alertController.textFields[0].text?:@"");
//    }])];
//    
//    
//    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark -- 进度监视
/*
    在监听方法中获取网页加载的进度，并将进度赋给progressView.progress
 */

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
                
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
 #pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"name:%@\\\\n body:%@\\\\n frameInfo:%@\\\\n",message.name,message.body,message.frameInfo);
}

/*
//这个是将网页上所有的_blank标签都去掉了。。。上面代码用到了。。
 - (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView evaluateJavaScript:@"var a = document.getElementsByTagName('a');for(var i=0;i<a.length;i++){a[i].setAttribute('target','');}" completionHandler:nil];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

*/
@end
