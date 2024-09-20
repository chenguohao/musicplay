#import "MPPlayListEditViewController.h"
#import "Masonry.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "MPMusicSearchViewController.h"
#import "MPPlayDetailListCell.h"
#import "MPPlaylistService.h"
#import "DNEHUD.h"
#import "SDWebImage/SDWebImage.h"
#import "TZImagePickerController.h"
#import "UIView+TapGesture.h"
#import "MPPlaylistModel.h"
#import "MPAliOSSManager.h"
@interface MPPlayListEditViewController ()<UITableViewDelegate,UITableViewDataSource,UITableViewDragDelegate>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *addSongButton;

@property (nonatomic,assign) long createTime;
@property (nonatomic,strong) UILabel *playlistNameLabel;
@property (nonatomic,strong) UILabel *userNameLabel;
@property (nonatomic,strong) UILabel *createdAtLabel;
@property (nonatomic,strong) UIImageView *playlistCover;

@property (nonatomic,strong) NSMutableArray* playlistItems;
@property (nonatomic,strong) UIImageView* avatar;
@property (nonatomic,strong) UIImageView* avatarEdit;
@property (nonatomic,strong) MPPlaylistService* service;
@property (nonatomic,strong) UILabel* createAt;
@property (nonatomic,assign) BOOL isCoverUpdated;
@property (nonatomic,strong) UIImageView* titleEdit;
@property (nonatomic,strong) MPPlaylistModel* model;
@property (nonatomic,strong) MPPlaylistModel* modelSnapshot;
@property (nonatomic,strong) UIButton *saveBtn;
@property (nonatomic,strong) void(^onRefresh)(void);
@end

@implementation MPPlayListEditViewController

-(instancetype)init{
    self = [super init];
    self.model = [MPPlaylistModel init];
self.modelSnapshot = self.model.copy;
    return self;
}

- (instancetype)initWithModel:(MPPlaylistModel*)model{
    self = [super init];
    self.model = model;
    self.modelSnapshot = self.model.copy;
    if(self.model.items.count){
        self.playlistItems = [NSMutableArray arrayWithArray:self.model.items];
    }else{
        self.playlistItems = [NSMutableArray new];
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupConstraints];
    
    
    [self updateSaveButtonState];
}

- (void)setupUI {
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(4, 0, 40, 40);
    [btn setImage:[UIImage imageNamed:@"navbar_back_btn"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];

    
    self.saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.saveBtn.frame = CGRectMake(4, 0, 40, 40);
    [self.saveBtn setTitle:@"Save" forState:UIControlStateNormal];
    [self.saveBtn setTitleColor:MPUITheme.mainDark forState:UIControlStateNormal];
    [self.saveBtn setTitleColor:UIColor.lightGrayColor forState:UIControlStateDisabled];
    [self.saveBtn addTarget:self action:@selector(onSave) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.saveBtn];

    
    // Header View
    self.headerView = [[UIView alloc] init];
    self.headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.headerView];
    
    // Add Header Subviews (e.g., imageView, labels, etc.)
    self.playlistCover = [[UIImageView alloc] init];
    self.playlistCover.backgroundColor = [UIColor lightGrayColor]; // Placeholder color
    self.playlistCover.image = [UIImage imageNamed:@"cover_default"];
    self.playlistCover.layer.cornerRadius = 20;
    self.playlistCover.clipsToBounds = YES;
    self.playlistCover.userInteractionEnabled = YES;
    [self.headerView addSubview:self.playlistCover];
    __weak typeof(self) wkSelf = self;
    [self.playlistCover addTapGestureWithBlock:^{
        [wkSelf onCover];
    }];
    
    self.playlistNameLabel = [[UILabel alloc] init];
    @weakify(self);
    [RACObserve(self.model, title) subscribeNext:^(NSString *newTitle) {
        @strongify(self);
        self.playlistNameLabel.text = newTitle;
        [self updateSaveButtonState];
    }];
    self.playlistNameLabel.userInteractionEnabled = YES;
    [self.playlistNameLabel addTapGestureWithBlock:^{
        [wkSelf onTitle];
    }];
    
    self.titleEdit = [UIImageView new];
    UIImage *image = [[UIImage imageNamed:@"profile_edit"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.titleEdit.image = image;
    self.titleEdit.tintColor = MPUITheme.mainDark;
    [self.headerView addSubview:self.titleEdit];
    self.titleEdit.userInteractionEnabled = YES;
    [self.titleEdit addTapGestureWithBlock:^{
        [wkSelf onTitle];
    }];
    
    [self.headerView addSubview:self.playlistNameLabel];
    
    self.userNameLabel = [[UILabel alloc] init];
    self.userNameLabel.font = [UIFont systemFontOfSize:12];
    self.userNameLabel.textColor = UIColor.grayColor;
    self.userNameLabel.text = MPProfileManager.sharedManager.curUser.name;
    [self.headerView addSubview:self.userNameLabel];
    
    self.createdAtLabel = [[UILabel alloc] init];
    
    NSDateFormatter* formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd";
    if (self.model.createAt) {
        
        NSDate* time = [NSDate dateWithTimeIntervalSince1970:self.model.createAt];
        NSString* timeStr = [formatter stringFromDate:time];
        self.createdAtLabel.text = [NSString stringWithFormat:@"Created at %@",timeStr];
    }else{
        NSDate* now = [NSDate date];
        NSString* nowStr = [formatter stringFromDate:now];
        self.createdAtLabel.text = [NSString stringWithFormat:@"Created at %@",nowStr];
    }
    
    self.createdAtLabel.font = [UIFont systemFontOfSize:12];
    self.createdAtLabel.textColor = UIColor.grayColor;
    [self.headerView addSubview:self.createdAtLabel];
    
    // Table View
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView registerClass:[MPPlayDetailListCell class] forCellReuseIdentifier:@"MPPlayDetailListCell"];
    self.tableView.dragInteractionEnabled = YES;
    self.tableView.dragDelegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.editing = YES;
    [self.view addSubview:self.tableView];
    
    // Add Song Button
    self.addSongButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.addSongButton setTitle:@"Add Song" forState:UIControlStateNormal];
//    self.addSongButton.backgroundColor = MPUITheme.contentBg;
    [self.addSongButton setBackgroundColorImage:MPUITheme.contentBg forState:UIControlStateNormal];
    [self.addSongButton setBackgroundColorImage:UIColor.lightGrayColor forState:UIControlStateDisabled];
    [self.addSongButton setTitleColor:MPUITheme.contentText forState:UIControlStateNormal];
    self.addSongButton.layer.cornerRadius = 25;
    self.addSongButton.clipsToBounds = YES;
    [self.addSongButton addTarget:self  action:@selector(onAdd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addSongButton];
    
    self.avatar = [UIImageView new];
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:MPProfileManager.sharedManager.curUser.avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    self.avatar.layer.cornerRadius = 10;
    self.avatar.clipsToBounds = YES;
    self.avatar.userInteractionEnabled = YES;
    
   
    [self.headerView addSubview:self.avatar];
    
    self.avatarEdit = [UIImageView new];
    self.avatarEdit.image = [UIImage imageNamed:@"avatar_edit"];
   
    [self.headerView addSubview:self.avatarEdit];
}

- (void)setupConstraints {
    // Header View Constraints
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(120);
    }];
    
    [self.playlistCover mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headerView).offset(20);
            make.top.equalTo(self.headerView).offset(20);
            make.width.height.mas_equalTo(80);
    }];
    
    [self.playlistNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playlistCover.mas_right).offset(20);
        make.top.equalTo(self.playlistCover);
    }];
    
    [self.titleEdit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.playlistNameLabel);
            make.left.equalTo(self.playlistNameLabel.mas_right).offset(10);
            make.width.height.mas_equalTo(20);
    }];
    
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.playlistNameLabel);
            make.top.equalTo(self.playlistNameLabel.mas_bottom).offset(10);
            make.height.width.mas_equalTo(20);
    }];
    
    [self.avatarEdit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.playlistCover);
            make.bottom.equalTo(self.playlistCover);
            make.width.height.mas_equalTo(20);
    }];
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatar.mas_right).mas_offset(10);
            make.centerY.equalTo(self.avatar);
    }];
    
    [self.createdAtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.playlistNameLabel);
            make.top.equalTo(self.userNameLabel.mas_bottom).offset(10);
    }];
   
    
    // Table View Constraints
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.addSongButton.mas_top);
    }];
    
    // Add Song Button Constraints
    [self.addSongButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-10);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(200);
    }];
}

- (void)checkAddButton{
    self.addSongButton.enabled = self.playlistItems.count < 10;
}

- (void)updateSaveButtonState {
    
    if(self.playlistItems.count == 0){
        self.saveBtn.enabled = NO;
        return ;
    }
    
    BOOL titleChanged = ![self.playlistNameLabel.text isEqualToString:self.modelSnapshot.title];
    
    if(titleChanged||self.isCoverUpdated||[self isItemsChanged]){
        self.saveBtn.enabled = YES;
    }else{
        self.saveBtn.enabled = NO;
    }
}

- (BOOL)isItemsChanged{
    if(self.playlistItems.count != self.modelSnapshot.items.count){
        return YES;
    }
    
    if(self.playlistItems.count == 0){
        return NO;
    }
    
    for(int i =0;i< self.playlistItems.count;i++){
        NSDictionary* info = self.playlistItems[i];
        NSDictionary* oriInfo = self.modelSnapshot.items[i];
        if(![info[@"id"] isEqualToString:oriInfo[@"id"]]){
            return YES;
        }
        
    }
    return NO;
}


- (void)onAdd{
    MPMusicSearchViewController* searchVc = [MPMusicSearchViewController new];
    [searchVc setSelect:^(NSDictionary * selectInfo) {
        [self.playlistItems addObject:selectInfo];
        [self checkAddButton];
        //增加时检测
        [self updateSaveButtonState];
        [self.tableView reloadData];
        NSInteger lastSection = [self.tableView numberOfSections] - 1;
        NSInteger lastRow = [self.tableView numberOfRowsInSection:lastSection] - 1;

        if (lastRow >= 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:lastSection];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }];
    [self presentViewController:searchVc animated:YES completion:nil];
}

- (void)onBack{
    
    BOOL titleChanged = ![self.playlistNameLabel.text isEqualToString:self.modelSnapshot.title];
    
    BOOL isUpdate = titleChanged||self.isCoverUpdated||[self isItemsChanged];
    if(isUpdate){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Unsaved Changes"
                                                                                 message:@"Are you sure you want to exit without saving?"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Confirm"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {}];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}

- (void)setRefreshBlock:(void(^)(void))block{
    self.onRefresh = block;
}

- (void)onSave{
    self.model.items = self.playlistItems;
    
    [DNEHUD showLoading:@""];
    void(^finishBlock)(NSError*) = ^(NSError* err){
        [DNEHUD hideHUD];
        if(err == nil){
            [DNEHUD showMessage:@"Save Success"];
            [self.navigationController popViewControllerAnimated:YES] ;
            if(self.onRefresh){
                self.onRefresh();
            }
        }else{
            [DNEHUD showMessage:@"Save fail"];
        }
    };
    
    if(self.isCoverUpdated){
            NSData *imageData = UIImageJPEGRepresentation(self.playlistCover.image, 0.7);
            [DNEHUD showLoading:@"uploading"];
            [[MPAliOSSManager sharedManager] uploadData:imageData withBlock:^(NSString * url, NSError * err) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [DNEHUD hideHUD];
                    if(err){
                        [DNEHUD showMessage:err.description];
                    }else{
                        [DNEHUD showMessage:@"Upload Success"];
                        NSLog(@"url %@",url);
                        self.model.coverUrl = url;
                        if (self.isCreate) {
                            [self.service createPlaylistWithModel:self.model
                                                           Result:finishBlock];
                        }else{
                            [self.service updatePlaylistWithModel:self.model
                                                           Result:finishBlock];
                        }
                    }
                });
            }];
        }else{
            if (self.isCreate) {
                [self.service createPlaylistWithModel:self.model
                                               Result:finishBlock];
            }else{
                
               
                
                [self.service updatePlaylistWithModel:self.model
                                               Result:finishBlock];
            }
        }
    
    
    
    
    
    
    
}

- (void)onCover{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        UIImage* image = photos[0];
        self.playlistCover.image = image;
        self.isCoverUpdated = YES;
        //更新头像检测
        [self updateSaveButtonState];
      
    }];
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    CGFloat kScreenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat kScreenWidth  = [UIScreen mainScreen].bounds.size.width;
    imagePickerVc.cropRect = CGRectMake(0,(kScreenHeight - kScreenWidth) / 2, kScreenWidth, kScreenWidth);
    imagePickerVc.allowCrop = YES;
    imagePickerVc.allowPickingVideo = NO;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


- (void)onTitle{
    [self showCreatePlaylistAlert:self isCreate:NO onCreate:^(NSString * newTitle){
        self.model.title = newTitle;
    }];
}

#pragma mark - function
- (void)showCreatePlaylistAlert:(UIViewController*)viewController
                       isCreate:(BOOL)isCreate
                       onCreate:(void(^)(NSString*))block{
    // 创建UIAlertController
    NSString* title = isCreate?@"New Playlist":@"Playlist Edit";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:@"Enter a name for your playlist"
                                                                      preferredStyle:UIAlertControllerStyleAlert];

    // 添加TextField到Alert
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Playlist Name";
        if(self.model.title.length && !isCreate){
            textField.text = self.model.title;
        }
        
    }];

    // 创建"Cancel"按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];

    // 创建"Create"按钮，并处理输入
    UIAlertAction *createAction = [UIAlertAction actionWithTitle:@"Create"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
        // 获取TextField中的文本
        UITextField *textField = alertController.textFields.firstObject;
        NSString *playlistName = textField.text;

        // 检查歌单名是否为空
        if (playlistName.length > 0) {
            // 调用你的方法来处理新建歌单的逻辑
            if(block){
                block(playlistName);
            }
        } else {
            // 歌单名为空时的处理（比如提示用户）
            [self showEmptyPlaylistNameAlert];
        }
    }];

    // 将Action添加到AlertController
    [alertController addAction:cancelAction];
    [alertController addAction:createAction];

    // 显示Alert
    [viewController presentViewController:alertController animated:YES completion:nil];
}

// 处理新建歌单的逻辑
- (void)createNewPlaylistWithName:(NSString *)playlistName {
    // 在这里实现新建歌单的逻辑
    NSLog(@"Creating new playlist with name: %@", playlistName);
    // 比如，可以调用API创建歌单，或者更新UI等
}

// 显示歌单名为空的提示
- (void)showEmptyPlaylistNameAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:@"Playlist name cannot be empty."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}


//-(NSMutableArray *)playlistItems{
//    if(_playlistItems == nil){
//        _playlistItems = [NSMutableArray new];
//    }
//    return _playlistItems;
//}

-(MPPlaylistService *)service{
    if(_service == nil){
        _service = [MPPlaylistService new];
    }
    return _service;
}

#pragma mark - tableview delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MPPlayDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPPlayDetailListCell" forIndexPath:indexPath];
    NSArray* playlist = self.playlistItems;
    NSDictionary* info = playlist[indexPath.row];
    [cell configureWithInfo:info];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.playlistItems.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  80;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;  // 所有行都可以编辑
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 在数据源中删除该项
        [self.playlistItems removeObjectAtIndex:indexPath.row];
        [self checkAddButton];
        // 在表视图中删除该行
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        //删除cell时检测
        [self updateSaveButtonState];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;  // 所有行都可以拖拽
}

// 更新数据源以反映新位置
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    // 更新数据源
    id item = self.playlistItems[sourceIndexPath.row];
    [self.playlistItems removeObjectAtIndex:sourceIndexPath.row];
    [self.playlistItems insertObject:item atIndex:destinationIndexPath.row];
    //更新顺序检测
    [self updateSaveButtonState];
}
- (NSArray<UIDragItem *> *)tableView:(UITableView *)tableView itemsForBeginningDragSession:(id<UIDragSession>)session atIndexPath:(NSIndexPath *)indexPath {
    // 创建一个 UIDragItem，并设置拖动时显示的内容
    UIDragItem *dragItem = [[UIDragItem alloc] initWithItemProvider:[[NSItemProvider alloc] initWithObject:@"AAA"]];
    return @[dragItem];
}

// 接收拖放的处理
- (void)tableView:(UITableView *)tableView performDropWithCoordinator:(id<UITableViewDropCoordinator>)coordinator {
    // 处理放下时的逻辑
}
@end

