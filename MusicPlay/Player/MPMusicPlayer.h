//
//  MusicPlayer.h
//  MusicPlay
//
//  Created by Chen guohao on 8/9/24.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
NS_ASSUME_NONNULL_BEGIN

@interface MPMusicPlayer : NSObject

@property (nonatomic, strong) MPMusicPlayerController *musicPlayer;
@property (nonatomic, strong) NSArray *playlist;
@property (nonatomic, assign) NSInteger currentIndex;

+ (instancetype)sharedPlayer;
- (void)setPlaylist:(NSArray * _Nonnull)playlist;
- (void)playNextTrack;
- (void)playTrackWithIndex:(int)index
                inPlayList:(NSArray*)playList;
- (void)playCurrentTrack;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
