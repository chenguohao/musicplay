//
//  D9EULAViewController.m
//  KuKoo
//
//  Created by Chen guohao on 2/5/24.
// 
#import "D9UserAgreementAlert.h"
#import "D9EULAViewController.h"
#import "MPWebViewController.h"
#define AgreeShowEULAKEY @"NeedShowEULAKEY"
@interface D9EULAViewController ()<UITextViewDelegate>
@property (nonatomic,strong) UITextView* textView;
@property (nonatomic,strong) UIView* contentView;
@property (nonatomic,strong) UIButton* agreeBtn;
@end

@implementation D9EULAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.view addSubview:self.contentView];
    
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(300));
            make.height.equalTo(@(450));
            make.center.equalTo(self.view);
    }];
    
    
    [self.contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 10, 50, 10));
    }];
    
    
    [self.contentView addSubview:self.agreeBtn];
    [self.agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textView.mas_bottom).offset(5);
            make.bottom.equalTo(self.contentView).mas_offset(-5);
        make.width.equalTo(@(100));
        make.centerX.equalTo(self.contentView);
    }];
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [UITextView new];
        _textView.delegate = self;
        _textView.text = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"eula" ofType:@"txt"]];
    }
    return _textView;
}
-(UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 20;
        _contentView.clipsToBounds = YES;
    }
    return _contentView;
}
#define FONTSIZE(size)  [UIFont systemFontOfSize:size]
-(UIButton *)agreeBtn{
   
    if (!_agreeBtn) {
        _agreeBtn = [UIButton new];
        [_agreeBtn setTitle:CustomLocalizedString(@"agree", nil) forState:UIControlStateNormal];
        [_agreeBtn addTarget:self action:@selector(onAgree) forControlEvents:UIControlEventTouchUpInside];
//        [_agreeBtn setBackgroundColor:[UIColor colorWithHexString:@"#3E89F7"]];
        [_agreeBtn setBackgroundColorImage:[[UIColor colorWithHexString:@"3E89F7"] colorWithAlphaComponent:1] forState:UIControlStateNormal];
        [_agreeBtn setBackgroundColorImage:[[UIColor colorWithHexString:@"3E89F7"]  colorWithAlphaComponent:0.3] forState:UIControlStateDisabled];
        _agreeBtn.layer.cornerRadius = 10;
        _agreeBtn.clipsToBounds = YES;
        _agreeBtn.enabled = NO;
    }
    return _agreeBtn;
}

- (void)onAgree{
    [[NSUserDefaults standardUserDefaults] setValue:@(YES)  forKey:AgreeShowEULAKEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
        self.agreeBtn.enabled = YES;
    }
}

+ (void)showEULAIfNeed {
    BOOL agreeEULA = [[[NSUserDefaults standardUserDefaults] valueForKey:AgreeShowEULAKEY] boolValue];
   
    if (!agreeEULA) {
        UIViewController *vc = [MPUIManager.sharedManager getCurrentViewController];
        D9UserAgreementAlert *alert = [[D9UserAgreementAlert alloc] init];
        [alert showAlertOnView:vc.view];
        [alert addClickLinkObserver:^(NSString * _Nonnull url) {
            
            MPWebViewController *webVC = [[MPWebViewController alloc] initWithURL:url];
               
                NSString* title = @"";
                if ([url isEqualToString:[D9UserAgreementAlert privacyUrl]]) {
                    title = CustomLocalizedString(@"Privacy Policy", nil);
                }else{
                    title = CustomLocalizedString(@"User Agreement", nil);
                }
            webVC.title = title;
            UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:webVC];
            nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
                [vc presentViewController:nav animated:YES completion:nil];
        }];

    }
}
@end
