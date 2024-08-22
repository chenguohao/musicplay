//
//  MPMusicSearchWrapper.h
//  MusicPlay
//
//  Created by Chen guohao on 8/10/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
 

typedef void (^MPMusicSearchCompletionHandler)(NSArray *results, NSError *error);

@interface MPMusicSearchWrapper : NSObject
- (void)requestAppleMusicPermissionWithCompletion:(void (^)(BOOL granted, NSError *error))completion;
- (void)searchForSongsWithQuery:(NSString *)query completion:(MPMusicSearchCompletionHandler)completion;

@end

NS_ASSUME_NONNULL_END
