#import "MPLoginViewController.h"
#import <Masonry/Masonry.h>
#import "MPAuthService.h"

@interface MPLoginViewController ()
@property (nonatomic, strong) UIImageView *logoImageView ;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic,strong) MPAuthService* service;
@end

@implementation MPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置视图背景色
    self.view.backgroundColor = [UIColor whiteColor];
    
 
    
    
    // 设置背景颜色为白色
    [self setupUI];
    [self setupConstrait];
        
        // 使用Masonry设置布局
       
}

- (void)setupUI{
    self.view.backgroundColor = [UIColor colorWithHexString:@"0x051f11"];
    
    // 添加中间的logo图片
    self.logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mini_logo"]];
    [self.view addSubview:self.logoImageView];
    
    // 添加登录按钮
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginButton setImage:[UIImage imageNamed:@"signApple_bgwhite"] forState:UIControlStateNormal];
    [self.view addSubview:self.loginButton];
    [self.loginButton addTarget:self action:@selector(loginButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton setImage:[UIImage imageNamed:@"icon_navbar_close_white"] forState:UIControlStateNormal];
    [self.view addSubview:self.closeButton];
    [self.closeButton addTarget:self action:@selector(onClose) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupConstrait{
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-100); // 向上偏移100
        make.width.height.equalTo(@200); // 设置图片的宽度和高度
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom).offset(-250); // 图片下方50
        make.width.equalTo(@200); // 设置按钮宽度
        make.height.equalTo(@50); // 设置按钮高度
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.view).offset(50); // 图片下方50
        make.width.equalTo(@50); // 设置按钮宽度
        make.height.equalTo(@50); // 设置按钮高度
    }];
}

- (void)loginButtonTapped:(UIButton *)sender {
    [self.service loginWithAppleWithComplete:^(NSError * err) {
        if(err){
            [DNEHUD showMessage:err.description];
        }else{
            [self dismissModalViewControllerAnimated:YES];
        }
    }];
}


- (void)onClose{
    [self dismissModalViewControllerAnimated:YES];
}

-(MPAuthService*)service{
    if(_service == nil){
        _service = [MPAuthService new];
    }
    return _service;
}
@end
