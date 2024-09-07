#import "ViewController.h"
#import "Masonry.h"
#import "MPPlaylistSectionHeader.h"
#import "MPPlayDetailListCell.h"
#import "BDLeftMenuView.h"
#import "MPGlobalPlayerManager.h"
#import "TZImagePickerController.h"
#import "MPAliOSSManager.h"
#import "DNEHUD.h"
#import "MPPlaylistService.h"
#import "MPPlayListEditViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSDictionary *> *models;
@property (nonatomic, strong) NSIndexPath *expandedIndexPath;
@property (nonatomic) NSInteger curSection;
@property (nonatomic,strong) MPPlaylistService* service;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.curSection = -1;
    self.service = [MPPlaylistService new];
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];

 
    self.models = @[]; // Get your data models here

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
   
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColor.whiteColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[MPPlayDetailListCell class] forCellReuseIdentifier:@"CardCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        }];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithTitle:@"menu"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(onMenu)];
       
       // 将按钮设置为导航栏左侧按钮
       self.navigationItem.leftBarButtonItem = menuButton;
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithTitle:@"+"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(onAdd)];
       
       // 将按钮设置为导航栏左侧按钮
       self.navigationItem.rightBarButtonItem = newButton;
    [[MPGlobalPlayerManager globalManager] showPlayer:self.view];
    [self refreshList];
}


- (void)refreshList{
    [self.service getPlaylistWithPage:1 Size:10 Result:^(NSArray * list) {
        self.models = list;
        [self.tableView reloadData];
    }];
}

- (void)onMenu {
    [BDLeftMenuView show];
}

- (void)onAdd{
    MPPlayListEditViewController * editVC = [MPPlayListEditViewController new];
    NSString* t = @"111";
    NSMutableDictionary* info = @{@"title":t};
    [editVC setupInfo:info];
    [self.navigationController pushViewController:editVC animated:YES];
    return;;
    
    
    
    [editVC showCreatePlaylistAlert:self
                           onCreate:^(NSString * title) {
        NSMutableDictionary* info = @{@"title":title};
        [editVC setupInfo:info];
        [self.navigationController pushViewController:editVC animated:YES];
    }];
//
    
    return;
    NSDictionary* item = self.models[0];
    
    NSString* title = item[@"title"];
    NSString* cover = item[@"coverUrl"];
    NSArray* playlist = item[@"playlist"];
    
    [DNEHUD showLoading:@""];
    [self.service createPlaylistWithTitle:title Cover:cover PlayItems:playlist Result:^(NSError * err) {
        [DNEHUD hideHUD];
        
        if(err == nil){
            [DNEHUD showMessage:@"success"];
            
           
            
            
        }else{
            [DNEHUD showMessage:@"fail"];
        }
        
    }];
    return;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        UIImage* image = photos[0];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.7);

//        NSData *imageData = UIImagePNGRepresentation(image);
        
       
        [DNEHUD showLoading:@"uploading"];
        [[MPAliOSSManager sharedManager] uploadData:imageData withBlock:^(NSString * url, NSError * err) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [DNEHUD hideHUD];
                if(err){
                    [DNEHUD showMessage:err.description];
                }else{
                    [DNEHUD showMessage:@"Upload Success"];
                    NSLog(@"url %@",url);
                }
            });
          
            
        }];
    }];
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    CGFloat kScreenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat kScreenWidth  = [UIScreen mainScreen].bounds.size.width;
    imagePickerVc.cropRect = CGRectMake(0,(kScreenHeight - kScreenWidth) / 2, kScreenWidth, kScreenWidth);
    imagePickerVc.allowCrop = YES;
    imagePickerVc.allowPickingVideo = NO;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (NSArray*)fetchData{
    
    NSString* path  = [[NSBundle mainBundle] pathForResource:@"playlist" ofType:@"plist"];
    NSArray* array = [NSArray arrayWithContentsOfFile:path];
    return array;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(self.curSection == section){
        NSArray* playlist = self.models[section][@"list_item"];
        return playlist.count;
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MPPlayDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CardCell" forIndexPath:indexPath];
    NSArray* playlist = self.models[indexPath.section][@"list_item"];
    NSDictionary* info = playlist[indexPath.row];
    [cell configureWithInfo:info];
    [cell setBgColor2: indexPath.section % 2 == 0?MPUITheme.contentBg:MPUITheme.contentBg_semi];
       
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60; // Height of the card view
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MPPlaylistSectionHeader* view = [MPPlaylistSectionHeader new];
    view.tag = section;
    [view configureWithDictionary:self.models[section] index:section];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHeader:)];
    [view addGestureRecognizer:tap];
//    view.backgroundColor = UIColor.redColor;
    return view;
}

- (void)onHeader:(id)sender{
    int preSection = -1;
    if(self.curSection != -1){
        preSection = self.curSection;
        self.curSection = -1;
        [self removeRowInCurSection:preSection];
    }
    
    UIGestureRecognizer* ges = (UIGestureRecognizer*)sender;
    if (preSection != ges.view.tag) {
        self.curSection = ges.view.tag;
        [self addRowInCurSection];
    }
}

- (void)removeRowInCurSection:(int)section{
    NSMutableArray* sourceArr = [NSMutableArray new];
    NSArray* playList = self.models[section][@"list_item"];
    for (int i = 0; i < [playList count]; i++)
    {
        // 取得当前分区行indexPath
        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:section];
        
        // 赋值给新数组
        [sourceArr addObject:index];
    }
//    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:self.curSection];
//    
    // 动态插入数据
    [self.tableView deleteRowsAtIndexPaths:sourceArr withRowAnimation:UITableViewRowAnimationTop];
}

- (void)addRowInCurSection{
    NSMutableArray* sourceArr = [NSMutableArray new];
    NSArray* playList = self.models[self.curSection][@"list_item"];
    for (int i = 0; i < [playList count]; i++)
    {
        // 取得当前分区行indexPath
        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:self.curSection];
        
        // 赋值给新数组
        [sourceArr addObject:index];
    }
    
    // 动态插入数据
    [self.tableView insertRowsAtIndexPaths:sourceArr withRowAnimation:UITableViewRowAnimationBottom];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSArray* playlist = self.models[indexPath.section][@"list_item"];
    
    
    
    [[MPGlobalPlayerManager globalManager] playWithIndex:indexPath.row playList:playlist];
}

@end
