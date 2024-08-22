//
//  DNEHUD.m
//  HighChat
//
//  Created by 吴迪 on 2021/1/6.
//

#import "DNEHUD.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface DNEHUD ()

@property (nonatomic, weak) MBProgressHUD *hud;

@end
@implementation DNEHUD
+ (instancetype)sharedInstance {
    
    static DNEHUD *objc = NULL;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objc = [[DNEHUD alloc] init];
    });
    
    return objc;
}

+ (void)showStatus:(DNEHUDType)status text:(nullable NSString *)text {
    [self showStatus:status text:text textColor:UIColor.whiteColor font: [UIFont systemFontOfSize:16]];
}

+ (void)showStatus:(DNEHUDType)status
              text:(nullable NSString *)text
         textColor:(UIColor *)color
              font:(UIFont *)font {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow;
        if (@available(iOS 13.0, *)){
            for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
                if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                    for (UIWindow *window in windowScene.windows) {
                        if (window.isKeyWindow) {
                            keyWindow = window;
                            break;
                        }
                    }
                }
            }
        }
        if (!keyWindow) {
            keyWindow = [UIApplication sharedApplication].keyWindow;
        }

        [self showStatus:status text:text textColor:color font: font view:keyWindow  duration:2.0f];

    });
}

/// 展示HUD
/// @param status 类型
/// @param text 文字
/// @param color 颜色
/// @param font 字体
/// @param view 父视图
/// @param duration 持续时间
+ (void)showStatus:(DNEHUDType)status
              text:(nullable NSString*)text
         textColor:(UIColor *)color
              font:(UIFont *)font
              view:(UIView *)view
          duration:(NSTimeInterval)duration {
    
    [self hideHUD];
    
    [DNEHUD sharedInstance].hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    switch (status) {
        case DNEHUDTypeLoading:
            [DNEHUD sharedInstance].hud.userInteractionEnabled = YES;
            break;
            
        default:
            [DNEHUD sharedInstance].hud.userInteractionEnabled = NO;
            break;
    }
    
    [DNEHUD sharedInstance].hud.removeFromSuperViewOnHide = YES;
    
    [DNEHUD sharedInstance].hud.bezelView.blurEffectStyle = UIBlurEffectStyleDark;
    [DNEHUD sharedInstance].hud.contentColor = [UIColor whiteColor];
    [DNEHUD sharedInstance].hud.label.text= text;
    [DNEHUD sharedInstance].hud.label.textColor = color;
    [DNEHUD sharedInstance].hud.label.font = font;
    [DNEHUD sharedInstance].hud.label.numberOfLines = 0;
    [DNEHUD sharedInstance].hud.bezelView.layer.cornerRadius = 20;
    
    [[DNEHUD sharedInstance].hud setMinSize:CGSizeMake(100, 100)];
    
    switch(status) {
        case DNEHUDTypeSuccess:
            [self setCustomeHUDWithImage:NULL duration:duration];
            break;

        case DNEHUDTypeError:
            [self setCustomeHUDWithImage:NULL duration:duration];
            break;

        case DNEHUDTypeLoading:
            [DNEHUD sharedInstance].hud.mode = MBProgressHUDModeIndeterminate;
            [[DNEHUD sharedInstance].hud hideAnimated:YES afterDelay:CGFLOAT_MAX];
            return;
            
        case DNEHUDTypeInfo:
            [DNEHUD sharedInstance].hud.mode = MBProgressHUDModeText;
            break;
    }
    
    [[DNEHUD sharedInstance].hud hideAnimated:YES afterDelay:duration];
}

+ (void)setCustomeHUDWithImage:(UIImage *)image duration:(NSTimeInterval)duration {
   
    [DNEHUD sharedInstance].hud.mode = MBProgressHUDModeCustomView;
    UIImageView *errView = [[UIImageView alloc] initWithImage:image];

    [DNEHUD sharedInstance].hud.customView = errView;
}

+ (void)showMessage:(NSString *)text {
    if (text.length == 0) {
        [self hideHUD];
    } else {
        [self showStatus:DNEHUDTypeInfo text:text];
    }
}

+ (void)showLoading:(nullable NSString *)text {
    [self showStatus:DNEHUDTypeLoading text:text];
}

+ (void)hideHUD {
    [[DNEHUD sharedInstance].hud hideAnimated:YES];
    
}

- (BOOL)isShow {
    return [DNEHUD sharedInstance].hud != NULL;
}

@end
