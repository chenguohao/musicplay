//
//  DNEHUD.h
//  HighChat
//
//  Created by 吴迪 on 2021/1/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DNEHUDType) {
    DNEHUDTypeSuccess,
    DNEHUDTypeError,
    DNEHUDTypeInfo,
    DNEHUDTypeLoading
};

@interface DNEHUD : NSObject

@property (nonatomic, assign, getter=isShow) BOOL isShow;

+ (instancetype)sharedInstance;

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
          duration:(NSTimeInterval)duration;

+ (void)showStatus:(DNEHUDType)status
              text:(nullable NSString *)text
         textColor:(UIColor *)color
              font:(UIFont *)font;

+ (void)showStatus:(DNEHUDType)status text:(nullable NSString*)text;

+ (void)showMessage:(NSString *)text;

+ (void)showLoading:(nullable NSString *)text;

/// 隐藏HUD
+ (void)hideHUD;
@end

NS_ASSUME_NONNULL_END
