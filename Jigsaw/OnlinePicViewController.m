//
//  OnlinePicViewController.m
//  Jigsaw
//
//  Created by Ever on 15/3/5.
//  Copyright (c) 2015年 Ever. All rights reserved.
//

#import "OnlinePicViewController.h"
#import "MBProgressHUD.h"

@interface OnlinePicViewController ()
{
    NSTimer *timer;
}

@property(nonatomic,strong)NSMutableData *urlData ;

@end

@implementation OnlinePicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.navigationItem.title=NSLocalizedString(@"browser", nil);
    
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://image.baidu.com/i?tn=wiseala&ie=utf8&word=%E6%89%8B%E6%9C%BA%E5%A3%81%E7%BA%B8&fmpage=index&from=index&pos=magic"]];
    [self.picWebView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [timer invalidate];
    timer=nil;
}

#pragma mrak - lozy loading
-(NSMutableData *)urlData
{
    if (_urlData==nil) {
        _urlData=[[NSMutableData alloc] initWithCapacity:0];
    }
    return _urlData;
}

#pragma mark - Action
- (IBAction)backAction:(id)sender {
    if (self.picWebView.canGoBack) {
        [self.picWebView goBack];
    }
}

- (IBAction)forwardAction:(id)sender {
    if(self.picWebView.canGoForward)
    {
        [self.picWebView goForward];
    }
}

- (IBAction)refreshAction:(id)sender {
    [self.picWebView reload];
}

- (IBAction)loadPicAction:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *imgUrl= [self.picWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('vivid')[0].src;"];
    NSString *imgUrl2= [self.picWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('vivid')[1].src;"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
        [self savePhoto:data];
        if (![imgUrl isEqualToString:imgUrl2]) {
            NSData *data2=[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl2]];
            [self savePhoto:data2];
        }
        [self performSelectorOnMainThread:@selector(backMainWhenLoadedImg) withObject:nil waitUntilDone:YES];

    });
    NSLog(@"url:%@",imgUrl);
}

-(void)backMainWhenLoadedImg
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)savePhoto:(NSData *)imgData
{
    NSDate *date=[NSDate new];
    NSTimeInterval interval=[date timeIntervalSince1970];
    NSString *path=[NSTemporaryDirectory() stringByAppendingPathComponent:@"userPic"];
    
    NSString *fileName=[NSString stringWithFormat:@"%ld.png",(long)interval];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *filePath=[path stringByAppendingPathComponent:fileName];
    [imgData writeToFile:filePath atomically:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:PicAddNotification object:fileName];
}

-(void)filterHTML
{
    [self.picWebView stringByEvaluatingJavaScriptFromString:@"var arr=document.getElementsByClassName('nav'); for(i=0;i<arr.length;i++){arr[i].style.display='none'}"];
    [self.picWebView stringByEvaluatingJavaScriptFromString:@"var arr=document.getElementsByClassName('searchBox'); for(i=0;i<arr.length;i++){arr[i].style.display='none'}"];
    [self.picWebView stringByEvaluatingJavaScriptFromString:@"var arr=document.getElementsByClassName('nav-cls'); for(i=0;i<arr.length;i++){arr[i].style.display='none'}"];
    [self.picWebView stringByEvaluatingJavaScriptFromString:@"var arr=document.getElementsByClassName('footer'); for(i=0;i<arr.length;i++){arr[i].style.display='none'}"];
    [self.picWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('topRsQuery').style.display='none';"];
    [self.picWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('rsQuery').style.display='none';"];
    [self.picWebView stringByEvaluatingJavaScriptFromString:@"var tool=document.getElementById('infoBar');tool.parentNode.removeChild(tool);"];
    [self.picWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('topBar').style.display='none';"];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self filterHTML];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self filterHTML];
    timer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(filterHTML) userInfo:nil repeats:YES];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSString *html= [self.picWebView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML;"];
    NSLog(@"html-----------%@",html);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType==UIWebViewNavigationTypeLinkClicked) {
        return NO;
    }
    [timer invalidate];
    timer=nil;
    return YES;
}
//
//#pragma mark - load HTML
//-(void)loadRequest:(NSURLRequest *)request
//{
//    _urlData=nil;
//    [NSURLConnection connectionWithRequest:request delegate:self];
//}
//
//#pragma mark - NSURLConnectionDataDelegate
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//    [self.urlData appendData:data];
//}
//
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    NSString *htmlString=[[NSString alloc] initWithData:self.urlData encoding:NSUTF8StringEncoding];
//    [self.picWebView loadHTMLString:htmlString baseURL:nil];
//}
//
//#pragma mark - NSURLConnectionDelegate
//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
//{
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    NSString *htmlString=@"<html><body style='text-align:center;margin-top:100'>加载失败</body></html>";
//    [self.picWebView loadHTMLString:htmlString baseURL:nil];
//}
@end
