//
//  MPPlaylistEditViewController.h
//  MusicPlay
//
//  Created by Chen guohao on 8/15/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPPlayListEditViewController : UIViewController
- (void)setupInfo:(NSDictionary*)info;
- (void)showCreatePlaylistAlert:(UIViewController*)viewController
                       isCreate:(BOOL)isCreate
                       onCreate:(void(^)(NSString*))block;
@end

NS_ASSUME_NONNULL_END
