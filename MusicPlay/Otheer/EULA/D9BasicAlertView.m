//
//  DNEBasicAlertView.m
//  zaky
//
//  Created by 吴迪 on 2021/1/10.
//

#import "D9BasicAlertView.h"

@interface D9BasicAlertView ()

// 背景蒙层
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *contentView;

@property (nonatomic, assign) BOOL isLayoutFinish;
@end
@implementation D9BasicAlertView

- (void)dealloc {
    NSLog(@" dealloc DNEBasicAlertView");
}

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
    if (self) {
        self.enableHideWhenTapBackgroundView = YES;
        self.isLayoutFinish = YES;
        [self setupUI];
        [self setupConstraints];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
    if (self) {
        self.enableHideWhenTapBackgroundView = YES;
        self.isLayoutFinish = YES;
        [self setupUI];
        [self setupConstraints];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.isLayoutFinish) {
        self.isLayoutFinish = YES;
        [self setupUI];
        [self setupConstraints];
    }
}

#pragma mark - Function

- (void)showAlert {
    [self showAlertOnView:[UIApplication sharedApplication].delegate.window];
}

- (void)showAlertOnView:(UIView *)view {
    
    self.bgView.alpha = 0;
    self.contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.alpha = 1;
    [view addSubview:self];
    
    [UIView animateWithDuration:0.3 * 2 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bgView.alpha = 1;
        self.contentView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];

}

- (void)hideAlert {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - control ecent
- (void)onTapBackgroundView {
    if (self.enableHideWhenTapBackgroundView) {
        [self hideAlert];
    }
}

- (void)onTapContentView {
    
}

#pragma mark - UI
- (void)setupUI {
    
    [self addSubview:self.bgView];
    [self addSubview:self.contentView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapBackgroundView)];
    [self.bgView addGestureRecognizer:tap];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapContentView)];
    [self.contentView addGestureRecognizer:tap];
}

- (void)setupConstraints {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

#pragma mark - Setter & Getter

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.userInteractionEnabled = YES;
        _bgView.backgroundColor = [UIColorHex(0x000000) colorWithAlphaComponent:0.5];
        _bgView.alpha = 0;
    }
    return _bgView;
}

- (UIImageView *)contentView {
    if (!_contentView) {
        _contentView = [[UIImageView alloc] init];
        _contentView.layer.cornerRadius = 32;
        _contentView.userInteractionEnabled = YES;
        _contentView.backgroundColor = UIColorHex(0xFFFFFF);
    }
    return _contentView;
}
@end
