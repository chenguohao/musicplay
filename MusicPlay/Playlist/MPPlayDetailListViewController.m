#import "MPPlayDetailListViewController.h"
#import "MPPlayDetailHeaderView.h"
#import "MPPlayDetailListCell.h"
#import "Masonry.h"
#import "MPMusicSearchWrapper.h"
#import "MPMusicCacheManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MPMusicPlayer.h"
#import "MusicPlay-Swift.h"
#import "MPGlobalPlayerManager.h"
@interface MPPlayDetailListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) MPPlayDetailHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDictionary *info;
@property (nonatomic, strong) NSArray *playList;

@end

@implementation MPPlayDetailListViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _playList = [[MPMusicCacheManager sharedInstance] loadPlaylist:@""];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupConstraint];
    
   
//    MPMusicSearchWrapper* wrapper = [MPMusicSearchWrapper new];
//    [wrapper searchForSongsWithQuery:@"21 Guns" completion:^(NSArray * _Nonnull results, NSError * _Nonnull error) {
//        
//        
//        
//        int n = 0;
//    }];
}

- (void)setupUI {
    self.headerView = [[MPPlayDetailHeaderView alloc] init];
    [self.view addSubview:self.headerView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[MPPlayDetailListCell class] forCellReuseIdentifier:@"MPPlayDetailListCell"];
    [self.view addSubview:self.tableView];
}

- (void)setupConstraint {
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(150);  // Set appropriate height for the header
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}


- (void)playMusicWithTrackID:(NSString *)trackID {
    // Play the music using MusicKit
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.playList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MPPlayDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPPlayDetailListCell" forIndexPath:indexPath];
    NSDictionary *item = self.playList[indexPath.row];
    [cell configureWithInfo:item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [[MPMusicPlayer sharedPlayer] playTrackWithIndex:indexPath.row inPlayList:self.playList];
    [[MusicKitWrapper shared] playTrackWithIndex:indexPath.row dictArray:self.playList];
     
}

@end
