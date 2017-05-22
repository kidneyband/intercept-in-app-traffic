//
//  ViewController.m
//  HJFoundationDemo
//
//  Created by lchen on 15/05/2017.
//  Copyright © 2017 lchen. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "HJNetworkingMonitor.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *monitorSwitch;
@property (weak, nonatomic) IBOutlet UIWebView *myUIWebView;
@property (weak, nonatomic) IBOutlet UIButton *uiWebViewButton;
@property (nonatomic, strong) UIButton *wkWebViewButton;
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.wkWebViewButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.wkWebViewButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.wkWebViewButton setTitle:@"tap to load WKWebView" forState:UIControlStateNormal];
    [self.wkWebViewButton addTarget:self action:@selector(loadWKWebView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.wkWebViewButton];
    
    [self.uiWebViewButton setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [self.wkWebViewButton setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    
    self.wkWebView = [[WKWebView alloc] init];
    [self.view addSubview:self.wkWebView];
}

- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config];
    }
    return _session;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    self.wkWebViewButton.frame = CGRectMake(CGRectGetMinX(self.uiWebViewButton.frame), CGRectGetMaxY(self.myUIWebView.frame), CGRectGetWidth(self.uiWebViewButton.bounds), 20.0f);
    self.wkWebView.frame = CGRectMake(CGRectGetMinX(self.uiWebViewButton.frame), CGRectGetMaxY(self.wkWebViewButton.frame), CGRectGetWidth(self.uiWebViewButton.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(self.wkWebViewButton.frame));
}
- (IBAction)enableTrafficMonitor:(UISwitch *)sender {
    [HJNetworkingMonitor setEnable:sender.isOn];
}

- (IBAction)errorLinkWithURLConnection:(UIButton *)sender {
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://api.github.com/yy"]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
    }];
}

- (IBAction)rightLinkWithURLConnection:(UIButton *)sender {
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.github.com/search/users?q=language:objective-c&sort=followers&order=desc"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0f];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
    }];
}

- (IBAction)errorLinkWithURLSession:(UIButton *)sender {
    NSURL *url = [NSURL URLWithString:@"https://api.github.com/yy"];
    __weak typeof(self)weakSelf = self;
    NSURLSessionDataTask *datatask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error) {
        }
        else {
        }
        [weakSelf.session invalidateAndCancel];
    }];
    [datatask resume];
}

- (IBAction)rightLinkWithURLSession:(UIButton *)sender {
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.github.com/search/users?q=language:objective-c&sort=followers&order=desc"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0f];
    __weak typeof(self)weakSelf = self;
    NSURLSessionDataTask *datatask = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error) {
        }
        else {
        }
        [weakSelf.session invalidateAndCancel];
    }];
    [datatask resume];
}

#pragma mark - load webview
- (IBAction)loadUIWebView:(UIButton *)sender {
    NSURL *url = [NSURL URLWithString:@"http://github.com"];
    [self.myUIWebView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)loadWKWebView{
    NSURL *url = [NSURL URLWithString:@"http://github.com"];
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:url]];
}

@end
