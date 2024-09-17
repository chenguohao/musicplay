//
//  MPPlaylistService.h
//  MusicPlay
//
//  Created by Chen guohao on 8/29/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class  MPPlaylistModel;
@interface MPPlaylistService : NSObject
- (void)createPlaylistWithModel:(MPPlaylistModel*)model
                         Result:(void(^)(NSError*))result;

- (void)updatePlaylistWithModel:(MPPlaylistModel*)model
                         Result:(void(^)(NSError*))result;

- (void)deletePlaylistWithPlaylistID:(int)playlistID
                         Result:(void(^)(NSError*))result;

- (void)getPlaylistWithPage:(int)index
                       Size:(int)size
                     Result:(void(^)(NSArray*))result;

- (void)likePlayList:(BOOL)islike
          PlaylistID:(int)playlistID
              Result:(void(^)(NSError*))result;

- (void)addPlayCount:(int)playlistID
              Result:(void(^)(BOOL isAdd,NSError*))result;

@end

NS_ASSUME_NONNULL_END
