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
    
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://image.baidu.com/"]];
    [self.picWebView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSLog(@"url:%@",self.picWebView.request.URL);
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

//#pragma mark - UIWebViewDelegate
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//    if (navigationType==UIWebViewNavigationTypeLinkClicked) {
//        [self loadRequest:request];
//        return NO;
//    }
//    return YES;
//}
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
