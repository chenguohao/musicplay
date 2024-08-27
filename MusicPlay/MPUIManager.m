//
//  MPUIManager.m
//  MusicPlay
//
//  Created by Chen guohao on 8/24/24.
//

#import "MPUIManager.h"
#import <UIKit/UIKit.h>
#import "MPLoginViewController.h"
@implementation MPUIManager
+ (instancetype)sharedManager {
    
    static MPUIManager *objc = NULL;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objc = [[MPUIManager alloc] init];
    });
    
    return objc;
}

- (void)showLogin{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        
        // 如果根视图控制器是一个 UINavigationController，则获取其 visibleViewController
        if ([rootViewController isKindOfClass:[UINavigationController class]]) {
            rootViewController = [(UINavigationController *)rootViewController visibleViewController];
        }
        
        // 创建登录视图控制器
    MPLoginViewController *loginVC = [[MPLoginViewController alloc] init];
    loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
        // 确保 `rootViewController` 是当前可视的视图控制器
        if (rootViewController.presentedViewController) {
            [rootViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
        }
        
        [rootViewController presentViewController:loginVC animated:YES completion:nil];
}

-(UIWindow*)curWindow{
    UIWindow *currentWindow = nil;
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene *windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                currentWindow = windowScene.windows.firstObject;
                break;
            }
        }
    } else {
        currentWindow = [UIApplication sharedApplication].keyWindow;
    }
    return currentWindow;
}
@end
