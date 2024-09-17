//
//  MPPlaylistEditViewController.h
//  MusicPlay
//
//  Created by Chen guohao on 8/15/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MPPlaylistModel;
@interface MPPlayListEditViewController : UIViewController
@property (nonatomic,assign)BOOL isCreate;
- (instancetype)initWithModel:(MPPlaylistModel*)model;
- (void)showCreatePlaylistAlert:(UIViewController*)viewController
                       isCreate:(BOOL)isCreate
                       onCreate:(void(^)(NSString*))block;
- (void)setRefreshBlock:(void(^)(void))block;
@end

NS_ASSUME_NONNULL_END
