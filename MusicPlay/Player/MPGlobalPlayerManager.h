//
//  MPGlobalPlayerManager.h
//  MusicPlay
//
//  Created by Chen guohao on 8/12/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPGlobalPlayerManager : NSObject
+ (instancetype)globalManager;
- (void)showPlayer:(UIView*)view;
- (void)playWithIndex:(int)index
             playList:(NSArray*)playlist;
@end

NS_ASSUME_NONNULL_END
