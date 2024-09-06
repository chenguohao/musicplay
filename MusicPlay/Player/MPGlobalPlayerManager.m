//
//  MPGlobalPlayerManager.m
//  MusicPlay
//
//  Created by Chen guohao on 8/12/24.
//
#import <ReactiveObjC/ReactiveObjC.h>
#import "MPGlobalPlayerManager.h"
#import "MPPlayerViewController.h"
#import "AppDelegate.h"
#import "MusicPlay-Swift.h"
#import <MediaPlayer/MediaPlayer.h>
@interface MPGlobalPlayerManager ()
@property (nonatomic,strong)UIViewController* playerViewController;
@property (nonatomic,strong)MPMusicPlayerController *systemPlayer ;
@property (nonatomic, strong) MPMusicPlayerController *musicPlayer;
//@property (nonatomic,strong)
@end

@implementation MPGlobalPlayerManager
+ (instancetype)globalManager {
  static MPGlobalPlayerManager *sharedInstance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[MPGlobalPlayerManager alloc] init];
  });
  return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.systemPlayer = [MPMusicPlayerController systemMusicPlayer];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handlePlaybackStateChanged:)
                                                     name:MPMusicPlayerControllerPlaybackStateDidChangeNotification
                                                   object:self.systemPlayer];
        [self.systemPlayer beginGeneratingPlaybackNotifications];
        [RACObserve(self.systemPlayer, playbackState) subscribeNext:^(id aaa) {
            NSLog(@"systemPlayer state %d",[(NSNumber*)aaa intValue]);
        }];
    }
    return self;
}

- (void)showPlayer:(UIView*)view{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(view){
            [view addSubview:self.playerViewController.view];
        }else{
            AppDelegate  *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //        [[UIApplication sharedApplication].keyWindow addSubview:[GJFloatPlayerManager shareInstance].playerView];
            [[UIApplication sharedApplication].keyWindow addSubview:self.playerViewController.view];
        }
       
//        [[UIApplication sharedApplication].keyWindow.view insertSubview:[GJFloatPlayerManager shareInstance].playerView belowSubview:delegate.tabVC.tabBar];
    });
}
- (void)handlePlaybackStateChanged:(NSNotification *)notification {
    MPMusicPlayerController *player = [notification object];
    
    switch (player.playbackState) {
        case MPMusicPlaybackStatePlaying:
            NSLog(@"系统播放器正在播放");
            // 更新应用内的player状态，例如
            // self.player.status = @"playing";
            break;
            
        case MPMusicPlaybackStatePaused:
            NSLog(@"系统播放器已暂停");
            // 更新应用内的player状态，例如
            // self.player.status = @"pause";
            break;
            
        case MPMusicPlaybackStateStopped:
            NSLog(@"系统播放器已停止");
            // 更新应用内的player状态
            break;
            
        default:
            NSLog(@"系统播放器状态未知");
            break;
    }
}

-(UIViewController *)playerViewController{
    if(_playerViewController == nil){
        _playerViewController = [FloatPlayerSwiftUI makeSwiftUIViewController];
        CGFloat height = 80;
        CGFloat wH = [UIScreen mainScreen].bounds.size.height;
        CGFloat gap = 0;
        CGFloat bottomGap = 20;;
        CGFloat wW = [UIScreen mainScreen].bounds.size.width;
        _playerViewController.view.frame = CGRectMake(gap, wH - height - bottomGap, wW - 2*gap, height);
//        _playerViewController.view.backgroundColor = UIColor.redColor;
    }
    return _playerViewController;
}

- (void)playWithIndex:(int)index
             playList:(NSArray*)playlist{
    NSDictionary* curInfo = playlist[index];
//    [self.playerViewController setSongInfo:curInfo];
    [[MusicKitWrapper shared] playTrackWithIndex:index dictArray:playlist];
    self.musicPlayer= [MPMusicPlayerController applicationMusicPlayer];;
    [RACObserve(self.musicPlayer, playbackState) subscribeNext:^(id aaa) {
        NSLog(@"new tag %d",[(NSNumber*)aaa intValue]);
    }];
}
@end
