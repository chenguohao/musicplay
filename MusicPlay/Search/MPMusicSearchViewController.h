//
//  MPMusicSearchViewController.h
//  MusicPlay
//
//  Created by Chen guohao on 9/4/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPMusicSearchViewController : UIViewController
- (void)setSelect:(void(^)(NSDictionary*))block;
@end

NS_ASSUME_NONNULL_END
