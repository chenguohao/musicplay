#import "MPPrivacyPolicyViewController.h"
#import "Masonry.h"

@interface MPPrivacyPolicyViewController ()

@property (nonatomic, strong) UIView *popupView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation MPPrivacyPolicyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5]; // 半透明背景
    [self setupUI];
    [self setupConstraints];
}

- (void)setupUI {
    // 弹窗背景
    self.popupView = [[UIView alloc] init];
    self.popupView.backgroundColor = [UIColor whiteColor];
    self.popupView.layer.cornerRadius = 10.0;
    [self.view addSubview:self.popupView];
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"欢迎使用 Melody!";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.popupView addSubview:self.titleLabel];
    
    // 内容
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.text = @"感谢您下载并使用 Melody。为了更好地为您提供服务，请您阅读并同意我们的隐私政策和用户协议。";
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    [self.popupView addSubview:self.contentLabel];
    
    // 确认按钮
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.confirmButton setTitle:@"我已阅读并同意" forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.confirmButton setBackgroundColor:[UIColor systemBlueColor]];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.confirmButton.layer.cornerRadius = 5.0;
    [self.confirmButton addTarget:self action:@selector(confirmButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.popupView addSubview:self.confirmButton];
}

- (void)setupConstraints {
    // 弹窗背景布局
    [self.popupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view).multipliedBy(0.8);
        make.height.equalTo(@250);
    }];
    
    // 标题布局
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.popupView.mas_top).offset(20);
        make.left.right.equalTo(self.popupView).insets(UIEdgeInsetsMake(0, 20, 0, 20));
    }];
    
    // 内容布局
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.popupView).insets(UIEdgeInsetsMake(0, 20, 0, 20));
    }];
    
    // 确认按钮布局
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.popupView.mas_bottom).offset(-20);
        make.centerX.equalTo(self.popupView);
        make.width.equalTo(@200);
        make.height.equalTo(@44);
    }];
}

- (void)confirmButtonTapped {
    // 用户点击确认按钮的处理逻辑，例如关闭弹窗或保存用户同意状态
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
