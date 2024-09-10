//
//  DNEUserAgreementAlert.m
//  zaky
//
//  Created by 吴迪 on 2021/7/16.
//

#import "D9UserAgreementAlert.h"
#import "UITextView+Link.h"
@interface D9UserAgreementAlert ()<UITextViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UIButton *agreeBtn;

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UIImageView* logo;

@property (nonatomic, copy) void(^linkBlock)(NSString *url);

@end

@implementation D9UserAgreementAlert

- (void)addClickLinkObserver:(void(^)(NSString *url))block {
    self.linkBlock = block;
}

- (void)onClickConfirmButton {
    [self hideAlert];
    [[NSUserDefaults standardUserDefaults] setValue:@(YES)  forKey:@"NeedShowEULAKEY"];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    DNESetBoolUserDefaults(YES, @"DNE_AGREE_USERAGREEMENT");
}

- (void)onClickCancelButton {
    exit(0);
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction  API_AVAILABLE(ios(10.0)){
    self.linkBlock(URL.absoluteString);
    return NO;
}

#pragma mark - UI

- (void)setupUI {
    [super setupUI];
    
    self.enableHideWhenTapBackgroundView = NO;
    
    self.contentView.image = [UIImage imageNamed:@"alertbg"];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.textView];
    [self.contentView addSubview:self.agreeBtn];
    [self.contentView addSubview:self.cancelBtn];
    
    [self.contentView addSubview:self.logo];
}

- (void)setupConstraints {
    [super setupConstraints];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(303);
        make.height.mas_equalTo(420);
        make.center.mas_equalTo(self);
    }];
    
    [self.logo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(80);
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView).mas_offset(30);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView).mas_offset(142);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView).mas_offset(174);
        make.width.mas_lessThanOrEqualTo(250);
    }];
    
    [self.agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.width.mas_equalTo(238);
        make.height.mas_equalTo(48);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-68);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView).mas_offset(-33);
        make.centerX.mas_equalTo(self.contentView);
    }];
}

#pragma mark - Setter & Getter

- (NSString*)getProductName{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        return [infoDictionary objectForKey:@"CFBundleDisplayName"];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColorHex(0x333333);
        _titleLabel.font = FONTB(16);
        NSString* content = [NSString stringWithFormat:@"Welcome to %@",[self getProductName]];
        _titleLabel.text = CustomLocalizedString(content,nil);
    }
    return _titleLabel;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.editable = NO;
        _textView.scrollEnabled = NO;
        _textView.font = FONTL(14);
        _textView.textColor = UIColorHex(0x333333);
        _textView.backgroundColor = UIColorHex(0xFFFFFF);
        NSString* content = [NSString stringWithFormat:@"Please fully read and understand the \"User Agreement\" and \"User Privacy Policy\". Before using %@, please click Agree to indicate that you have read and agreed to all terms.",[self getProductName]];
        _textView.text = CustomLocalizedString(content,nil);
        [_textView addLinkWithString:[NSString stringWithFormat:@"\"%@\"", CustomLocalizedString(@"User Agreement",nil)] url:[D9UserAgreementAlert termsUrl] textColor:UIColorHex(0x7B8DFE) font:FONTM(14) underlineColor:UIColorHex(0x7B8DFE)];
        
        [_textView addLinkWithString:[NSString stringWithFormat:@"\"%@\"", CustomLocalizedString(@"User Privacy Policy",nil)] url:[D9UserAgreementAlert privacyUrl]  textColor:UIColorHex(0x7B8DFE) font:FONTM(14) underlineColor:UIColorHex(0x7B8DFE)];
        _textView.delegate = self;
    }
    return _textView;
}

- (UIButton *)agreeBtn {
    if (!_agreeBtn) {
        _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_agreeBtn setTitle:CustomLocalizedString(@"Agree",nil) forState:UIControlStateNormal];
        [_agreeBtn setTitleColor:UIColorHex(0xFFFFFF) forState:UIControlStateNormal];
        [_agreeBtn setBackgroundColorImage:UIColorHex(0x7B8DFE) forState:UIControlStateNormal];
        _agreeBtn.layer.cornerRadius = 24;
        _agreeBtn.clipsToBounds = YES;
        [_agreeBtn addTarget:self action:@selector(onClickConfirmButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreeBtn;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:CustomLocalizedString(@"Don't agree and quit",nil) forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:UIColorHex(0x999999) forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(onClickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
-(UIImageView *)logo{
    if(_logo == nil){
        _logo = [UIImageView new];
        _logo.image = [UIImage imageNamed:@"mini_logo"];
        _logo.layer.cornerRadius = 10;
        _logo.clipsToBounds = YES;
    }
    return _logo;
}

+(NSString *)privacyUrl  {
    return @"https://sdstorage.oss-cn-hongkong.aliyuncs.com/Protcol/PrivateProvacy.html";
}

+(NSString *)termsUrl {
    return @"https://sdstorage.oss-cn-hongkong.aliyuncs.com/Protcol/UserAgree.html";
}
@end
