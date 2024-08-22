//
//  MPMusicCacheManager.h
//  MusicPlay
//
//  Created by Chen guohao on 8/10/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPMusicCacheManager : NSObject
+ (instancetype)sharedInstance;
- (NSArray*)loadPlaylist:(NSString*)playlistID;
- (void)saveList:(NSArray*)list;
@end

NS_ASSUME_NONNULL_END
