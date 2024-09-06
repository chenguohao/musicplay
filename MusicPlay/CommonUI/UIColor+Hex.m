//
//  UIColor+Hex.m
//  MusicPlay
//
//  Created by Chen guohao on 8/29/24.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)
+ (UIColor *)colorWithHexString:(NSString *)hexString {
    // 去掉前缀#号或0x
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    cleanString = [cleanString stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    
    // 如果是三位数，转换为六位数
    if ([cleanString length] == 3) {
        NSMutableString *expandedHex = [NSMutableString stringWithCapacity:6];
        for (NSUInteger i = 0; i < 3; i++) {
            NSString *hexChar = [cleanString substringWithRange:NSMakeRange(i, 1)];
            [expandedHex appendString:hexChar];
            [expandedHex appendString:hexChar];
        }
        cleanString = expandedHex;
    }
    
    // 检查长度是否有效
    if ([cleanString length] != 6 && [cleanString length] != 8) {
        return [UIColor clearColor]; // 返回透明颜色表示输入无效
    }
    
    // 解析RGB值
    unsigned int red, green, blue, alpha = 255; // 默认alpha值为255，表示不透明
    NSRange range = NSMakeRange(0, 2);
    
    [[NSScanner scannerWithString:[cleanString substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[cleanString substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[cleanString substringWithRange:range]] scanHexInt:&blue];
    
    if ([cleanString length] == 8) { // 处理八位数情况，即包括alpha值
        range.location = 6;
        [[NSScanner scannerWithString:[cleanString substringWithRange:range]] scanHexInt:&alpha];
    }
    
    return [UIColor colorWithRed:((float) red / 255.0f)
                           green:((float) green / 255.0f)
                            blue:((float) blue / 255.0f)
                           alpha:((float) alpha / 255.0f)];
}
@end
