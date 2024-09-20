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
#import "MPPrivacyPolicyViewController.h"
#import "D9EULAViewController.h"
#import "MJRefresh/MJRefresh.h"
#import "D9ReportAlert.h"
#import "ReportManager.h"
#import "MPPlaylistModel.h"
#import <Mantle/Mantle.h>
@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<MPPlaylistModel *> *models;
@property (nonatomic, strong) NSIndexPath *expandedIndexPath;
@property (nonatomic) NSInteger curSection;
@property (nonatomic,strong) MPPlaylistService* service;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.curSection = -1;
    self.service = [MPPlaylistService new];
    self.view.backgroundColor = MPUITheme.theme_white;
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];

 
    self.models = @[]; // Get your data models here

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    __weak typeof(self) wkself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [wkself refreshList];
        [wkself.tableView.mj_header endRefreshing];
    }];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = MPUITheme.theme_white;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[MPPlayDetailListCell class] forCellReuseIdentifier:@"CardCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        }];
    
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0, 0, 40, 40);
//    [btn setImage:[UIImage imageNamed:@"icon_menu"] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(onMenu) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_menu"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(onMenu)];
    menuButton.tintColor = MPUITheme.contentBg_semi;
       // 将按钮设置为导航栏左侧按钮
       self.navigationItem.leftBarButtonItem = menuButton;
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"set_tag_add_btn"]
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(onAdd)];
    newButton.tintColor = MPUITheme.contentBg_semi;
       // 将按钮设置为导航栏左侧按钮
       self.navigationItem.rightBarButtonItem = newButton;
    
    [[MPGlobalPlayerManager globalManager] showPlayer:self.view];
    [self refreshList];
}


- (void)refreshList{
    [self.service getPlaylistWithPage:1 Size:10 Result:^(NSArray * list) {
        
        
        
        [self wrapReportWithList:list];
        
        
        [self.tableView reloadData];
    }];
}

- (void)wrapReportWithList:(NSArray*)list{
    NSMutableArray* marray = [NSMutableArray new];
    for (NSDictionary* info in list) {
        int userID = [info[@"owner_id"] intValue];
        int contentID = [info[@"playlist_id"] intValue];
        if([[ReportManager sharedManager] isOKWithUser:userID ContentID:contentID]){
            MPPlaylistModel* model = [MTLJSONAdapter modelOfClass:[MPPlaylistModel class]
                                               fromJSONDictionary:info
                                                            error:nil];

            [marray addObject:model];
        }
    }
    
    self.models = marray;
}

- (void)onMenu {
    BDLeftMenuView* leftmenu = [BDLeftMenuView show];
    [leftmenu setPushBlock:^(UIViewController * vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)onAdd{
    
    if(!IsUserLogin){
        [[MPUIManager sharedManager] showLogin];
    }else{
        MPPlaylistModel* model = [MPPlaylistModel new];
        MPPlayListEditViewController * editVC = [[MPPlayListEditViewController alloc] initWithModel:model];
        editVC.isCreate = YES;
        
        [editVC showCreatePlaylistAlert:self
                               isCreate:YES
                               onCreate:^(NSString * title) {
           
            model.ownerID  = MPProfileManager.sharedManager.curUser.uid;
            model.title = title;
            [self.navigationController pushViewController:editVC animated:YES];
            [editVC setRefreshBlock:^{
                [self refreshList];
            }];
        }];
    //
    }
    
//    NSString* t = @"111";
//
    
    
//    return;;
//    
//    
//    
//    [editVC showCreatePlaylistAlert:self
//                           onCreate:^(NSString * title) {
//        NSMutableDictionary* info = @{@"title":title};
//        [editVC setupInfo:info];
//        [self.navigationController pushViewController:editVC animated:YES];
//    }];
////
//    
//    return;
//    NSDictionary* item = self.models[0];
//    
//    NSString* title = item[@"title"];
//    NSString* cover = item[@"coverUrl"];
//    NSArray* playlist = item[@"playlist"];
//    
//    [DNEHUD showLoading:@""];
//    [self.service createPlaylistWithTitle:title Cover:cover PlayItems:playlist Result:^(NSError * err) {
//        [DNEHUD hideHUD];
//        
//        if(err == nil){
//            [DNEHUD showMessage:@"success"];
//            
//           
//            
//            
//        }else{
//            [DNEHUD showMessage:@"fail"];
//        }
//        
//    }];
//    return;
//    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
//    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//        
//        UIImage* image = photos[0];
//        NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
//
////        NSData *imageData = UIImagePNGRepresentation(image);
//        
//       
//        [DNEHUD showLoading:@"uploading"];
//        [[MPAliOSSManager sharedManager] uploadData:imageData withBlock:^(NSString * url, NSError * err) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [DNEHUD hideHUD];
//                if(err){
//                    [DNEHUD showMessage:err.description];
//                }else{
//                    [DNEHUD showMessage:@"Upload Success"];
//                    NSLog(@"url %@",url);
//                }
//            });
//          
//            
//        }];
//    }];
//    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
//    CGFloat kScreenHeight = [UIScreen mainScreen].bounds.size.height;
//    CGFloat kScreenWidth  = [UIScreen mainScreen].bounds.size.width;
//    imagePickerVc.cropRect = CGRectMake(0,(kScreenHeight - kScreenWidth) / 2, kScreenWidth, kScreenWidth);
//    imagePickerVc.allowCrop = YES;
//    imagePickerVc.allowPickingVideo = NO;
//    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (NSArray*)fetchData{
    
    NSString* path  = [[NSBundle mainBundle] pathForResource:@"playlist" ofType:@"plist"];
    NSArray* array = [NSArray arrayWithContentsOfFile:path];
    return array;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(self.curSection == section){
        MPPlaylistModel* model = self.models[section];
        NSArray* playlist = model.items;
        return playlist.count;
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MPPlayDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CardCell" forIndexPath:indexPath];
    NSArray* playlist = self.models[indexPath.section].items;
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
    MPPlaylistModel* model = self.models[section];
    [view configureWithModel:model index:section];
    int contentID = self.models[section].playlistID  ;
    int userID = self.models[section].ownerID;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHeader:)];
    [view addGestureRecognizer:tap];
    
    
    [view setLikeAvtion:^(BOOL isLike) {
        [self.service likePlayList:isLike PlaylistID:contentID Result:^(NSError * err) {
            if (err) {
                [DNEHUD showMessage:err.description];
            }else{
                view.model.isLiked = isLike;
                if(isLike){
                    view.model.likeCount += 1;
                }else{
                    view.model.likeCount -= 1;
                }
            }
        }];
    }];
    
    [view setMoreAction:^{
        
        if(userID == MPProfileManager.sharedManager.curUser.uid){
            [self showEditMenuWihModel:self.models[section]];
        }else{
            [self reportWithContentID:contentID 
                               UserID:userID];
        }
        
        
    }];
//    view.backgroundColor = UIColor.redColor;
    return view;
}

- (void)showEditMenuWihModel:(MPPlaylistModel*)model{
    UIAlertController *sheets = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:CustomLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    
    [sheets addAction:cancelAction];
    @weakify(self)
    
    UIAlertAction *hideContentAction = [UIAlertAction actionWithTitle:@"Edit" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self onEdit:model];
    }];
    [sheets addAction:hideContentAction];
    
    UIAlertAction *hideUserAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         
        [self onDelete:model];
    }];
    [sheets addAction:hideUserAction];
    [[MPUIManager.sharedManager getCurrentViewController] presentViewController:sheets animated:YES completion:nil];
}

- (void)onEdit:(MPPlaylistModel*)model{
    MPPlayListEditViewController * editVC = [[MPPlayListEditViewController alloc] initWithModel:model];
    editVC.isCreate = NO;
    [self.navigationController pushViewController:editVC animated:YES];
    [editVC setRefreshBlock:^{
        [self refreshList];
    }];
    return;;
}

- (void)onDelete:(MPPlaylistModel*)model{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Delete Playlist"
                                                                             message:@"Are you sure you want to delete this playlist? This action cannot be undone."
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Delete"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
        [self.service deletePlaylistWithPlaylistID:model.playlistID 
                                            Result:^(NSError * err) {
            if(err){
                [DNEHUD showMessage:err.description];
            }else{
                [DNEHUD showMessage:@"Delete Success"];
                [self refreshList];
            }
        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {}];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)reportWithContentID:(int)contentID
                     UserID:(int)userID{
    D9ReportAlert* report = [[D9ReportAlert alloc] init];
    [report showReportWithContentID:contentID
                             UserID:userID
                        FinishBlock:^(NSString * reason) {
        if([reason containsString:@"Hide"]){
            
            
            [self.tableView beginUpdates];
            if ([reason  isEqualToString:@"Hide this content"]) {
              
                NSMutableIndexSet* sections = [NSMutableIndexSet new];
                for (int i = 0; i < self.models.count; i++) {
                    if (contentID == self.models[i].playlistID) {
                        [sections addIndex:i];
                    }
                }
                [self.tableView deleteSections:sections withRowAnimation:UITableViewRowAnimationFade];
                
            }else{
                NSMutableIndexSet* sections = [NSMutableIndexSet new];
                for (int i = 0; i < self.models.count; i++) {
                    if (userID == self.models[i].ownerID) {
                        [sections addIndex:i];
                    }
                }
                [self.tableView deleteSections:sections withRowAnimation:UITableViewRowAnimationFade];
            }
          
            [self wrapReportWithList:self.models];
            [self.tableView endUpdates];
            
           
//                [self.tableView reloadData];
        }
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    [self showPrivacy];
}
- (void)showPrivacy{
    [D9EULAViewController showEULAIfNeed];
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
    NSArray* playList = self.models[section].items;
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
    NSArray* playList = self.models[self.curSection].items;
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
    MPPlaylistModel* model = self.models[indexPath.section];
    NSArray* playlist = model.items;
    
    
    
    [[MPGlobalPlayerManager globalManager] playWithIndex:indexPath.row playList:playlist];
    
    [self.service addPlayCount:model.playlistID Result:^(BOOL isAdd,NSError * err) {
        if(isAdd){
            model.playCount += 1;
        }
    }];
}

@end
