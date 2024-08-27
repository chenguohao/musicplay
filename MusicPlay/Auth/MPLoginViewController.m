#import "MPLoginViewController.h"
#import <Masonry/Masonry.h>
#import "MPAuthService.h"

@interface MPLoginViewController ()

@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic,strong) MPAuthService* service;
@end

@implementation MPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置视图背景色
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 初始化登录按钮
    self.loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.loginButton setTitle:@"Login with Apple" forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(loginButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加到视图
    [self.view addSubview:self.loginButton];
    
    // 使用Masonry设置按钮的约束
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(@200);
        make.height.equalTo(@50);
    }];
}

- (void)loginButtonTapped:(UIButton *)sender {
    [self.service loginWithAppleWithComplete:^(NSError * err) {
        if(err){
            
        }else{
            [self dismissModalViewControllerAnimated:YES];
        }
    }];
}


-(MPAuthService*)service{
    if(_service == nil){
        _service = [MPAuthService new];
    }
    return _service;
}
@end
