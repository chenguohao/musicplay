//
//  MPPlayerViewController.m
//  MusicPlay
//
//  Created by Chen guohao on 8/12/24.
//

#import "MPPlayerViewController.h"
#import "Masonry.h"
#import "SDWebImage/SDWebImage.h"
#import "NSString+ItunesSongUrl.h"
@interface MPPlayerViewController ()
@property (nonatomic,strong)UIView* containerView;
@property (nonatomic,strong)UIImageView* coverImv;
@property (nonatomic, strong)UILabel* nameLabel;
@property (nonatomic, strong)UILabel* artistLabel;
@property (nonatomic, strong)UILabel* albumLabel;
@property (nonatomic, strong)UIButton* btnPlay;
@property (nonatomic, strong)UIButton* btnList;
@end

@implementation MPPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupConstraint];
    self.nameLabel.text = @"Melodies";
    self.artistLabel.text = @"com.xes";
    self.albumLabel.text = @"One OK App";
    self.coverImv.image = [UIImage imageNamed:@"mini_logo"];
    self.btnPlay.enabled = NO;
    // Do any additional setup after loading the view.
}
- (void)setSongInfo:(NSDictionary*)info{
    NSString* strUrl = info[@"attributes"][@"artwork"][@"url"];
    [self.coverImv sd_setImageWithURL:[NSURL URLWithString:[strUrl getWrappedUrlWithW:100 H:100]]];
    self.nameLabel.text = info[@"attributes"][@"name"];
    self.artistLabel.text = info[@"attributes"][@"artistName"];
    self.albumLabel.text = info[@"attributes"][@"albumName"];
}

- (void)setupUI{
    self.containerView = [UIView new];
    self.containerView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.containerView];
    
    self.coverImv = [UIImageView new];
    self.coverImv.backgroundColor = UIColor.lightGrayColor;
    [self.containerView addSubview:self.coverImv];
    
    
    self.nameLabel = [UILabel new];
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    [self.containerView addSubview:self.nameLabel];
    
    self.artistLabel = [UILabel new];
    self.artistLabel.textColor = UIColor.darkGrayColor;
    self.artistLabel.font = [UIFont systemFontOfSize:10];
    [self.containerView addSubview:self.artistLabel];
    
    self.albumLabel = [UILabel new];
    self.albumLabel.font = [UIFont systemFontOfSize:10];
    self.albumLabel.textColor = UIColor.lightGrayColor;
    [self.containerView addSubview:self.albumLabel];
    
    self.btnList = [[UIButton alloc] init];
    [self.btnList setImage:[UIImage imageNamed:@"common_playlist"] forState:UIControlStateNormal];
    [self.containerView addSubview:self.btnList];
    
    self.btnPlay = [[UIButton alloc] init];
    [self.btnPlay setImage:[UIImage imageNamed:@"icon_play_playing"] forState:UIControlStateNormal];
    [self.btnPlay setImage:[UIImage imageNamed:@"icon_play_pause"] forState:UIControlStateSelected];
    [self.btnPlay setImage:[UIImage imageNamed:@"icon_play_disable"] forState:UIControlStateDisabled];
    [self.containerView addSubview:self.btnPlay];
}

- (void)setupConstraint{
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.equalTo(self.view).offset(-10);
    }];
    
    [self.coverImv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.containerView).offset(10);
        make.centerY.equalTo(self.containerView);
        make.width.height.equalTo(@(45));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.containerView).offset(5);
            make.left.equalTo(self.coverImv.mas_right).offset(10);
        make.right.equalTo(self.btnPlay.mas_left);
    }];
    
    [self.artistLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(4);
    }];
    
    [self.albumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.artistLabel);
        make.right.equalTo(self.btnPlay.mas_left);
            make.top.equalTo(self.artistLabel.mas_bottom).offset(4);
    }];
    
    [self.btnList mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.containerView.mas_right).offset(-10);
            make.width.height.equalTo(@(30));
            make.centerY.equalTo(self.containerView);
        }];
    [self.btnPlay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.btnList.mas_left).offset(-10);
            make.width.height.equalTo(@(30));
            make.centerY.equalTo(self.btnList);
    }];
    
}

@end
