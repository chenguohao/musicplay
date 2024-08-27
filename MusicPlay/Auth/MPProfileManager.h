//
//  MPProfileManager.h
//  MusicPlay
//
//  Created by Chen guohao on 8/27/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class  MPUserProfile;
@interface MPProfileManager : NSObject
+ (instancetype)sharedManager;
@property (nonatomic,strong)MPUserProfile* curUser;
- (void)cacheUserProfile:(MPUserProfile*)user;
- (MPUserProfile*)loadCacheUserProfile;
- (void)removeUserCache;
@end

NS_ASSUME_NONNULL_END
