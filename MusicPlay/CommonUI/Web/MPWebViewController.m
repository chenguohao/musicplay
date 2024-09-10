#import "MPWebViewController.h"
#import <WebKit/WebKit.h>
#import "Masonry.h"

@interface MPWebViewController ()

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSURL *url;

@end

@implementation MPWebViewController

// 初始化方法，传入 URL
- (instancetype)initWithURL:(NSString *)url {
    self = [super init];
    if (self) {
        _url = [NSURL URLWithString:url];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置视图背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(4, 0, 40, 40);
    [btn setImage:[UIImage imageNamed:@"navbar_back_btn"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    // 添加并配置 WKWebView
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.webView];
    
    // 使用 Masonry 设置 webView 的约束
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view); // 让 webView 填满整个视图
    }];
    
    // 加载传入的 URL
    if (self.url) {
        NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
        [self.webView loadRequest:request];
    } else {
        NSLog(@"Error: URL is nil");
    }
}

- (void)onBack{
    [self dismissModalViewControllerAnimated:YES];
}
@end
