//
//  DNEBasicAlertView.h
//  zaky
//
//  Created by 吴迪 on 2021/1/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface D9BasicAlertView : UIView
//  是否点击背景图自动隐藏 默认Yes
@property (nonatomic, assign) BOOL enableHideWhenTapBackgroundView;
//  展示视图容器
@property (nonatomic, readonly, strong) UIImageView *contentView;

@property (nonatomic, strong, readonly) UIView *bgView;

/// 设置subview
- (void)setupUI;
/// 设置布局
- (void)setupConstraints;
/// 在当前keywindow上展示弹窗
- (void)showAlert;
/// 在制定view上展示弹窗
/// @param view 制定父视图
- (void)showAlertOnView:(UIView *)view;
/// 隐藏弹窗
- (void)hideAlert;
/// 点击背景
- (void)onTapBackgroundView;

- (void)onTapContentView;

@end

NS_ASSUME_NONNULL_END
