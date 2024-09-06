#import "MPPlayListEditViewController.h"
#import "Masonry.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "MPMusicSearchViewController.h"
#import "MPPlayDetailListCell.h"
#import "MPPlaylistService.h"
#import "DNEHUD.h"
@interface MPPlayListEditViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *addSongButton;
@property (nonatomic,strong) NSString* playTitle;
@property (nonatomic,strong) NSString* playCoverUrl;
@property (nonatomic,assign) long createTime;
@property (nonatomic,strong) UILabel *playlistNameLabel;
@property (nonatomic,strong) UILabel *userNameLabel;
@property (nonatomic,strong) UILabel *createdAtLabel;
@property (nonatomic,strong) UIImageView *playlistCover;

@property (nonatomic,strong) NSMutableArray* playlistItems;
@property (nonatomic,strong) UIImageView* avatar;
@property (nonatomic,strong) MPPlaylistService* service;
@property (nonatomic,strong) UILabel* createAt;

@end

@implementation MPPlayListEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupConstraints];
}

- (void)setupUI {
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(4, 0, 40, 40);
    [btn setImage:[UIImage imageNamed:@"navbar_back_btn"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];

    
    UIButton *btn_save = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_save.frame = CGRectMake(4, 0, 40, 40);
    [btn_save setTitle:@"Save" forState:UIControlStateNormal];
    [btn_save setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [btn_save addTarget:self action:@selector(onSave) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn_save];

    
    // Header View
    self.headerView = [[UIView alloc] init];
    self.headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.headerView];
    
    // Add Header Subviews (e.g., imageView, labels, etc.)
    self.playlistCover = [[UIImageView alloc] init];
    self.playlistCover.backgroundColor = [UIColor lightGrayColor]; // Placeholder color
    self.playlistCover.image = [UIImage imageNamed:@"cover_default"];
    [self.headerView addSubview:self.playlistCover];
    
    self.playlistNameLabel = [[UILabel alloc] init];
    @weakify(self);
    [RACObserve(self, playTitle) subscribeNext:^(NSString *newTitle) {
        @strongify(self);
        self.playlistNameLabel.text = newTitle;
    }];
    [self.headerView addSubview:self.playlistNameLabel];
    
    self.userNameLabel = [[UILabel alloc] init];
    self.userNameLabel.font = [UIFont systemFontOfSize:12];
    self.userNameLabel.textColor = UIColor.grayColor;
    self.userNameLabel.text = @"UserName";
    [self.headerView addSubview:self.userNameLabel];
    
    self.createdAtLabel = [[UILabel alloc] init];
    self.createdAtLabel.text = @"Created at 2024-09-04";
    self.createdAtLabel.font = [UIFont systemFontOfSize:12];
    self.createdAtLabel.textColor = UIColor.grayColor;
    [self.headerView addSubview:self.createdAtLabel];
    
    // Table View
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView registerClass:[MPPlayDetailListCell class] forCellReuseIdentifier:@"MPPlayDetailListCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    // Add Song Button
    self.addSongButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.addSongButton setTitle:@"Add Song" forState:UIControlStateNormal];
    self.addSongButton.backgroundColor = UIColor.blueColor;
    [self.addSongButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.addSongButton.layer.cornerRadius = 25;
    [self.addSongButton addTarget:self  action:@selector(onAdd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addSongButton];
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
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.playlistNameLabel);
            make.top.equalTo(self.playlistNameLabel.mas_bottom).offset(10);
    }];
    
    [self.createdAtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userNameLabel);
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

- (void)setupInfo:(NSDictionary*)info{
    self.playTitle = info[@"title"];
    if([[info allKeys] containsObject:@"url"]){
        self.playCoverUrl = info[@"url"];
    }
}

- (void)onAdd{
    MPMusicSearchViewController* searchVc = [MPMusicSearchViewController new];
    [searchVc setSelect:^(NSDictionary * selectInfo) {
        [self.playlistItems addObject:selectInfo];
        [self.tableView reloadData];
    }];
    [self presentViewController:searchVc animated:YES completion:nil];
}

- (void)onBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onSave{
    [DNEHUD showLoading:@"Uploading..."];
    [self.service createPlaylistWithTitle:self.playTitle Cover:self.playCoverUrl PlayItems:self.playlistItems Result:^(NSError * err) {
        [DNEHUD hideHUD];
        
        if(err == nil){
            [DNEHUD showMessage:@"Save Success"];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }else{
            [DNEHUD showMessage:@"Save fail"];
        }
        
    }];
}

#pragma mark -
- (void)showCreatePlaylistAlert:(UIViewController*)viewController
                       onCreate:(void(^)(NSString*))block{
    // 创建UIAlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"New Playlist"
                                                                             message:@"Enter a name for your playlist"
                                                                      preferredStyle:UIAlertControllerStyleAlert];

    // 添加TextField到Alert
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Playlist Name";
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


-(NSMutableArray *)playlistItems{
    if(_playlistItems == nil){
        _playlistItems = [NSMutableArray new];
    }
    return _playlistItems;
}

-(MPPlaylistService *)service{
    if(_service == nil){
        _service = [MPPlaylistService new];
    }
    return _service;
}

#pragma mark -
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
@end

