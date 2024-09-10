//
//  MPUIManager.h
//  MusicPlay
//
//  Created by Chen guohao on 8/24/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface MPUIManager : NSObject
@property (nonatomic,strong)UIWindow* curWindow;
+ (instancetype)sharedManager;
- (void)showLogin;
- (UIViewController *)getCurrentViewController;
@end

NS_ASSUME_NONNULL_END
