//
//  MPPlaylistService.h
//  MusicPlay
//
//  Created by Chen guohao on 8/29/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPPlaylistService : NSObject
- (void)createPlaylistWithTitle:(NSString*)title
                          Cover:(NSString*)url
                      PlayItems:(NSArray*)items
                         Result:(void(^)(NSError*))result;

- (void)updatePlaylistWithPlayID:(NSInteger)playID
                           Title:(NSString*)title
                          Cover:(NSString*)url
                      PlayItems:(NSArray*)items
                         Result:(void(^)(NSError*))result;

- (void)getPlaylistWithPage:(int)index
                       Size:(int)size
                     Result:(void(^)(NSArray*))result;

@end

NS_ASSUME_NONNULL_END
