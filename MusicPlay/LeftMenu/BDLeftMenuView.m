//
//  BDLeftMenuView.m
//  YueChe
//
//  Created by VictorZhang on 2020/4/19.
//  Copyright © 2020 TelaBytes. All rights reserved.
//
#import "DNEHUD.h"
#import "BDLeftMenuView.h"
#import "Masonry.h"
#import "SDWebImage/SDWebImage.h"
#import "UIView+TapGesture.h"
#import "MPUIManager.h"
#import "MPProfileManager.h"
#import "ReactiveObjC/ReactiveObjC.h"
#import "MPUserProfile.h"
#import "MPAboutViewController.h"
#import "MPProfileEditViewController.h"
#import "MPWebViewController.h"
#import "D9UserAgreementAlert.h"
#define UIScreenBounds          [UIScreen mainScreen].bounds
#define BDLeftMenuViewMaxWidth  UIScreenBounds.size.width * 0.70  // 左侧白色菜单的宽度
#define AnimationDuration       0.25

#define kCellReuseIDUserHeader  @"BDLeftMenuViewTableViewUserHeaderCellReuseID"
#define kCellReuseID            @"BDLeftMenuViewTableViewCellReuseID"


static BDLeftMenuView *_leftMenuView = nil;


@interface BDLeftMenuView ()<UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UIView *translucentView;
@property (nonatomic, weak) UIView *menuListView;

@property (nonatomic, assign) CGPoint originalMenuViewCenter;

@property (nonatomic, strong) NSMutableArray<NSNumber *> *scrollXAxisPathes; // 滑动时X值的路径，最多只存5个

@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *menuDataList;

@property (nonatomic, strong) UIView* profileHeader;
@property (nonatomic, strong) UIImageView* profileAvatar;
@property (nonatomic, strong) UILabel* profileName;

@property (nonatomic,strong) UIImageView* profileEditbtn;

@property (nonatomic, strong) void(^onPushBlock)(UIViewController*);

@end

@implementation BDLeftMenuView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupViews];
        @weakify(self);
        [RACObserve([MPProfileManager sharedManager], curUser) subscribeNext:^(MPUserProfile *newUser) {
                @strongify(self);
                if (newUser) {
                    // 更新头像
                    [self loadCurUser:newUser];
                }else{
                    [self setUserDefault];
                }
            }];
    }
    if([MPProfileManager sharedManager].curUser){
        [self loadCurUser:[MPProfileManager sharedManager].curUser];
    }else{
        [self setUserDefault];
    }
   
    return self;
}

- (void)loadCurUser:(MPUserProfile*)user{
    self.profileName.text = user.name;
    if(user.avatar.length){
        [self.profileAvatar sd_setImageWithURL:[NSURL URLWithString:user.avatar]];
    }
}

+ (BDLeftMenuView *)getInstanceView {
    return _leftMenuView;
}

+ (BDLeftMenuView*)show {
    _leftMenuView = [[BDLeftMenuView alloc] init];
    [[[UIApplication sharedApplication] keyWindow] addSubview:_leftMenuView];
    [_leftMenuView addMenuPanGesture]; // 添加拖拽手势
    return  _leftMenuView;
}

+ (void)hide {
    [_leftMenuView didCloseLeftMenu];
}

+ (void)showInView:(UIView *)superView {
    _leftMenuView = [[BDLeftMenuView alloc] init];
    [superView addSubview:_leftMenuView];
    [_leftMenuView addMenuPanGesture]; // 添加拖拽手势
}

+ (void)hideInView:(UIView *)superView {
    [_leftMenuView didCloseLeftMenu];
}

// 启用屏幕边缘拖拽
+ (void)enableScreenEdgeDraggingInView:(UIView *)edgeSelfView {
    UIScreenEdgePanGestureRecognizer *edgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(didReceiveEdgeGesture:)];
    edgePanGesture.edges = UIRectEdgeLeft;
    [edgeSelfView addGestureRecognizer:edgePanGesture];
}

+ (void)didReceiveEdgeGesture:(UIScreenEdgePanGestureRecognizer *)gesture {
    //CGPoint translation = [gesture translationInView:gesture.view];
    if (_leftMenuView == nil) {
        [BDLeftMenuView show];
    }
}


# pragma mark -- 创建基础视图
- (void)setupViews {
    
    [self.profileAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(60));
            make.left.top.equalTo(self.profileHeader).offset(10);
    }];
    self.profileAvatar.layer.cornerRadius = 30;
    self.profileAvatar.clipsToBounds = YES;
    
    [self.profileName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.profileAvatar.mas_right).offset(10);
            make.centerY.equalTo(self.profileAvatar);
    }];
    
    [self.profileEditbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.profileName);
            make.left.equalTo(self.profileName.mas_right).offset(10);
            make.width.height.mas_equalTo(24);
    }];
    
    self.frame = UIScreenBounds;
    _scrollXAxisPathes = [[NSMutableArray alloc] init];
    
    CGFloat pageWidth = BDLeftMenuViewMaxWidth;
    CGFloat pageHeight = UIScreenBounds.size.height;
    
    UITapGestureRecognizer *closeMenuViewRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didCloseLeftMenu)];
    closeMenuViewRecognizer.delegate = self;
    
    UIView *translucentView = [[UIView alloc] init];
    translucentView.backgroundColor = [UIColor blackColor];
    translucentView.frame = UIScreenBounds;
    translucentView.alpha = 0.25;
    [translucentView addGestureRecognizer:closeMenuViewRecognizer];
    [self addSubview:translucentView];
    _translucentView = translucentView;
    
    UIView *whiteLeftView = [[UIView alloc] init];
    whiteLeftView.frame = UIScreenBounds;
    [whiteLeftView addGestureRecognizer:closeMenuViewRecognizer];
    [self addSubview:whiteLeftView];
    
    UIView *menuListView = [self createMenuListViewWithFrame:CGRectMake(-pageWidth, 0, pageWidth, pageHeight)];
    [whiteLeftView addSubview:menuListView];
    _menuListView = menuListView;
    
    // 存储原始的self视图的中心点
    _originalMenuViewCenter = self.center;
    
    [self showInAnimation];
}

# pragma mark -- 关闭菜单视图
- (void)didCloseLeftMenu {
    [self hideInAnimation];
}

# pragma mark -- 点击左侧菜单屏幕事件 UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        // 如果用户点击的是UITableViewCell的话，则不处理此手势事件，应该交给UITableViewCell自己处理
        return NO;
    }
    return YES;
}


# pragma mark -- 添加左侧菜单拖拽手势
- (void)addMenuPanGesture {
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didReceivePanGesture:)];
    panGesture.maximumNumberOfTouches = 1;
    panGesture.minimumNumberOfTouches = 1;
    [self.menuListView.superview addGestureRecognizer:panGesture];
}

- (void)didReceivePanGesture:(UIPanGestureRecognizer *)gesture {
    // 在指定的View上计算转换出它的坐标值
    CGPoint translation = [gesture translationInView:gesture.view];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self addOriginXValue:@(gesture.view.frame.origin.x)];
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        [self addOriginXValue:@(gesture.view.frame.origin.x)];
    }  else {
        // gesture.state == UIGestureRecognizerStateEnded ||
        // gesture.state == UIGestureRecognizerStateCancelled ||
        // gesture.state ==  UIGestureRecognizerStateFailed
        // 判断最后一次是往左滑动，还是往右滑动
        CGFloat firstXValue = [[self.scrollXAxisPathes lastObject] floatValue];
        CGFloat lastXValue = [[self.scrollXAxisPathes firstObject] floatValue];
        if (firstXValue == 0 && lastXValue == 0) {
            // to do nothing
        } else if (firstXValue == lastXValue) {
            [self showInAnimationWhenScrolling];
        } else if (firstXValue > lastXValue) {
            [self showInAnimationWhenScrolling];
        } else {
            [self hideInAnimation];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(AnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // center回到原始点
            gesture.view.center = self.originalMenuViewCenter;
            [gesture setTranslation:CGPointZero inView:gesture.view];
        });
        // 置空X值得数组
        _scrollXAxisPathes = [[NSMutableArray alloc] init];
    }
    
    // 让左侧菜单跟着用户手指拖拽的走
    CGFloat centerX = gesture.view.center.x + translation.x;
    if (centerX > self.originalMenuViewCenter.x) {
        centerX = self.originalMenuViewCenter.x; // 防止向右拖拽时超出左侧边缘
    }
    gesture.view.center = CGPointMake(centerX, gesture.view.center.y);
    [gesture setTranslation:CGPointZero inView:gesture.view];
}

- (void)addOriginXValue:(NSNumber *)number {
    // 最多只存5个滑动时X轴的值
    if (self.scrollXAxisPathes.count <= 5) {
        [self.scrollXAxisPathes addObject:number];
    } else {
        [self.scrollXAxisPathes removeObjectAtIndex:0];
        [self.scrollXAxisPathes addObject:number];
    }
}

- (UIView *)createMenuListViewWithFrame:(CGRect)viewFrame {
    UIView *listView = [[UIView alloc] initWithFrame:viewFrame];
    listView.backgroundColor = MPUITheme.theme_white;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewFrame.size.width, viewFrame.size.height) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = MPUITheme.theme_white;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.gestureRecognizers = nil;
    [listView addSubview:tableView];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellReuseIDUserHeader];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellReuseID];
    _tableView = tableView;
    
    _userInfo = @{ @"icon": @"avatar_default", @"title": @"187****0897"};
    _menuDataList = @[
                      @{@"type": @(1), @"icon": @"OrderBlueIcon", @"title": @"User Agreement"},
                      @{@"type": @(2), @"icon": @"ServiceBlueIcon", @"title": @"Privacy Policy"},
                      @{@"type": @(2), @"icon": @"FeedbackBlueIcon", @"title": @"About"},
                      @{@"type": @(3), @"icon": @"SettingBlueIcon", @"title": @"Log Out"}
                    ];
    [self changeUserInfo:_userInfo];
    return listView;
}

- (void)changeUserInfo:(NSDictionary *)userInfo {
    _userInfo = userInfo;
    NSString* strUrl = userInfo[@"icon"];
    [self.profileAvatar sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    self.profileName.text = @"Tap to Login";
}

- (void)setUserDefault{
    self.profileAvatar.image = [UIImage imageNamed:@"avatar_default"];
    self.profileName.text = @"Tap to Login";
}

// 修改菜单列表的数据  比如：切换语言时，或者新增，或者删除列表项时
- (void)changeMenuDataList:(NSArray *)menuDataList {
    _menuDataList = menuDataList;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)showInAnimationWhenScrolling {
    // 用户左右滑动菜单时，动画显示左侧菜单
    [UIView animateWithDuration:AnimationDuration animations:^{
        CGRect menuListViewFrame = self.menuListView.superview.frame;
        menuListViewFrame.origin.x = 0;
        self.menuListView.superview.frame = menuListViewFrame;
    } completion:^(BOOL finished) {
        if (finished) {
        }
    }];
}

- (void)showInAnimation {
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.translucentView.alpha = 0.25;
    
        // 动画显示左侧菜单
        CGRect menuListViewFrame = self.menuListView.frame;
        menuListViewFrame.origin.x = 0;
        self.menuListView.frame = menuListViewFrame;
    }];
}

- (void)hideInAnimation {
    //_translucentView.alpha = 0.25;
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.translucentView.alpha = 0.0;
        
        // 动画隐藏左侧菜单
        CGRect menuListViewFrame = self.menuListView.frame;
        menuListViewFrame.origin.x = -menuListViewFrame.size.width;
        self.menuListView.frame = menuListViewFrame;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.translucentView removeFromSuperview];
            self.translucentView = nil;

            // 删除当前视图
            [_leftMenuView removeFromSuperview];
            _leftMenuView = nil;
        }
    }];
}

- (void)dealloc {
    NSLog(@"BDLeftMenuView has been deallocated!");
}


#pragma mark -- getter
-(UIView *)profileHeader{
    if(_profileHeader == nil){
        _profileHeader = [UIView new];
//        _profileHeader.backgroundColor = UIColor.redColor;
        [_profileHeader addSubview:self.profileName];
        [_profileHeader addSubview:self.profileAvatar];
        
        __weak typeof(self) wkSelf = self;
        [_profileHeader addTapGestureWithBlock:^{
            
            if (IsUserLogin) {
                [wkSelf hideInAnimation];
                [wkSelf onProfileEdit];
                
            }else{
                [wkSelf onLogin];
            }
            
        }];
    }
    return _profileHeader;;
}

-(UIImageView *)profileEditbtn{
    if(_profileEditbtn == nil){
        _profileEditbtn = [[UIImageView alloc] init];
        _profileEditbtn.image = [UIImage imageNamed:@"profile_edit"];
        UIImage *image = [[UIImage imageNamed:@"profile_edit"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _profileEditbtn.image = image;
        _profileEditbtn.tintColor = MPUITheme.mainDark;
        [_profileHeader addSubview:_profileEditbtn];
    }
    return _profileEditbtn;
}

-(UILabel *)profileName{
    if(_profileName == nil){
        _profileName = [UILabel new];
        _profileName.font = [MPUITheme font_normal:20];
    }
    return _profileName;
}

-(UIImageView *)profileAvatar{
    if(_profileAvatar == nil){
        _profileAvatar = [UIImageView new];
    }
    return _profileAvatar;
}

# pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuDataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

 

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIDUserHeader];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellReuseID];
    }
    NSDictionary *dict = [self.menuDataList objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:dict[@"icon"]];
    cell.textLabel.text = dict[@"title"];
    cell.textLabel.font = [MPUITheme font_normal:18];
    cell.textLabel.textColor = MPUITheme.contentBg;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithHexString:@"95d5b2"];
    
    // 设置点击时的背景色
        UIView *selectedBackgroundView = [[UIView alloc] init];
    selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"40916c"]; // 点击时变为深灰色
        cell.selectedBackgroundView = selectedBackgroundView;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 140;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.profileHeader;
}

# pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kBDLeftMenuViewEventNotification object:nil userInfo:@{@"isUserHeader":@(YES), @"data":self.userInfo}];
        [self didCloseLeftMenu];
        switch (indexPath.row) {
            case 0:
                [self onUserAgreement];
                break;
            case 1:
                [self onPrivacy];
                break;
            case 2:
                [self onAbout];
                break;
            case 3:
                [self onLogout];
                break;
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        NSDictionary *dict = [self.menuDataList objectAtIndex:indexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:kBDLeftMenuViewEventNotification object:nil userInfo:@{@"isUserHeader":@(NO), @"data":dict}];
        [self didCloseLeftMenu];
    }
}

#pragma mark - Function

- (void)onUserAgreement{
    MPWebViewController *webVC = [[MPWebViewController alloc] initWithURL:[D9UserAgreementAlert termsUrl]];
    webVC.title = @"User Agreement";
    if(self.onPushBlock){
        self.onPushBlock(webVC);
    }
}

- (void)onPrivacy{
    MPWebViewController *webVC = [[MPWebViewController alloc] initWithURL:[D9UserAgreementAlert privacyUrl]];
    webVC.title = @"Privacy Policy";
    if(self.onPushBlock){
        self.onPushBlock(webVC);
    }
}

- (void)onAbout{
    MPAboutViewController* aboutVC = [MPAboutViewController new];
    if(self.onPushBlock){
        self.onPushBlock(aboutVC);
    }
}

- (void)onProfileEdit{
    MPProfileEditViewController* vc = [MPProfileEditViewController new];
    if(self.onPushBlock){
        self.onPushBlock(vc);
    }
}

- (void)onLogin{
    [[MPUIManager sharedManager] showLogin];
}

- (void)onLogout{
    [MPProfileManager sharedManager].curUser = nil;
    [[MPProfileManager sharedManager] removeUserCache];
    [DNEHUD showMessage:@"Logout Success"];
}

- (void)setPushBlock:(void(^)(UIViewController*))block{
    self.onPushBlock = block;
}

@end
