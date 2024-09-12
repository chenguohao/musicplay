//
//  MPAboutViewController.m
//  MusicPlay
//
//  Created by Chen guohao on 9/10/24.
//

#import "MPAboutViewController.h"

@interface MPAboutViewController ()
@property (nonatomic,strong)UIImageView* logo;
@property (nonatomic,strong)UILabel* nameLabel;
@property (nonatomic,strong)UILabel* versionLabel;
@property (nonatomic,strong)UILabel* sloganLabel;
@end

@implementation MPAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    [self setupConstrait];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    self.nameLabel.text = appName;
    NSString * version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"Version %@",version];
    
    self.sloganLabel.text = @"One OK App";
}

- (void)setupUI{
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(4, 0, 40, 40);
    [btn setImage:[UIImage imageNamed:@"navbar_back_btn"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.logo = [UIImageView new];
    self.logo.image = [UIImage imageNamed:@"mini_logo"];
    self.logo.layer.cornerRadius = 20;
    self.logo.clipsToBounds = YES;
    [self.view addSubview:self.logo];
    
    self.nameLabel = [UILabel new];
    self.nameLabel.font = [MPUITheme font_bold:32];
    self.nameLabel.textColor = UIColor.blackColor;
    [self.view addSubview:self.nameLabel];
    
    
    self.versionLabel = [UILabel new];
    self.versionLabel.font = [MPUITheme font_normal:20];
    self.versionLabel.textColor = UIColor.lightGrayColor;
    [self.view addSubview:self.versionLabel];
    
    self.sloganLabel = [UILabel new];
    self.sloganLabel.font = [MPUITheme font_normal:24];
    self.sloganLabel.textColor = UIColor.blackColor;
    [self.view addSubview:self.sloganLabel];
}


- (void)setupConstrait{
    [self.logo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(100);
            make.width.height.mas_equalTo(100);
            make.centerX.equalTo(self.view);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.logo.mas_bottom).mas_offset(80);
    }];
    
    [self.sloganLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.nameLabel.mas_bottom).mas_offset(20);
    }];
    
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.sloganLabel.mas_bottom).mas_offset(20);
    }];
    
    
    
}


- (void)onBack{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
