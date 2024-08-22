#import "MPMusicPlayer.h"

@implementation MPMusicPlayer

+ (instancetype)sharedPlayer {
  static MPMusicPlayer *sharedInstance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[MPMusicPlayer alloc] init];
  });
  return sharedInstance;
}

- (instancetype)init{
    self = [super init];
    self.musicPlayer = [MPMusicPlayerController systemMusicPlayer];
    return self;
}

- (instancetype)initWithPlaylist:(NSArray *)playlist {
    self = [super init];
    if (self) {
       
        self.playlist = playlist;
        self.currentIndex = 0;
        
        // 请求访问 Apple Music 权限
        [self requestAppleMusicPermission];
    }
    return self;
}

- (void)setPlaylist:(NSArray * _Nonnull)playlist{
    _playlist = playlist;
}

- (void)requestAppleMusicPermission {
    [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
        switch (status) {
            case MPMediaLibraryAuthorizationStatusAuthorized:
                NSLog(@"Apple Music access granted.");
                break;
            case MPMediaLibraryAuthorizationStatusDenied:
            case MPMediaLibraryAuthorizationStatusRestricted:
            case MPMediaLibraryAuthorizationStatusNotDetermined:
                NSLog(@"Apple Music access denied.");
                break;
        }
    }];
}

- (void)playNextTrack {
    if (self.currentIndex < self.playlist.count) {
        [self playCurrentTrack];
        self.currentIndex++;
    } else {
        NSLog(@"End of playlist.");
    }
}
- (void)playTrackWithIndex:(int)index
                inPlayList:(NSArray*)playList{
    self.playlist = playList;
    self.currentIndex = index;
    NSNumber *trackID = self.playlist[self.currentIndex][@"trackId"];
    MPMediaItem *mediaItem = [self mediaItemFromID:trackID];
    
    if (mediaItem) {
        MPMediaItemCollection *collection = [MPMediaItemCollection collectionWithItems:@[mediaItem]];
        [self.musicPlayer setQueueWithItemCollection:collection];
        [self.musicPlayer play];
        
        NSLog(@"Playing track: %@", self.playlist[self.currentIndex][@"name"]);
    } else {
        NSLog(@"Track not found: %@", self.playlist[self.currentIndex][@"name"]);
    }
}

- (void)playCurrentTrack {
   
}
//- (MPMediaItem *)mediaItemFromID:(NSNumber *)trackID{
//    MPMediaPropertyPredicate *albumPredicate = [MPMediaPropertyPredicate predicateWithValue: albumTitle forProperty: MPMediaItemPropertyAlbumTitle];
//    [albumQuery addFilterPredicate:albumPredicate];
//
//    NSArray *albumTracks = [albumQuery items];
//}
- (MPMediaItem *)mediaItemFromID:(NSNumber *)trackID {
    
    
    
    MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:trackID
                                                                           forProperty:MPMediaItemPropertyPersistentID];
    MPMediaQuery *query = [[MPMediaQuery alloc] init];
    [query addFilterPredicate:predicate];
    
    return query.items.firstObject;
}

- (void)stop {
    if (self.musicPlayer) {
        [self.musicPlayer stop];
    }
}

@end
