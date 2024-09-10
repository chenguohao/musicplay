//
//  UITextView+Link.m
//  KuKoo
//
//  Created by Chen guohao on 2/6/24.
//

#import "UITextView+Link.h"

@implementation UITextView (Link)
- (void)addLinkWithString:(NSString *)string url:(NSString *)url textColor:(UIColor *)textColor font:(UIFont *)font underlineColor:(UIColor *)underlineColor {
    
    NSRange range = [self.text rangeOfString:string];
    
    if (range.location == NSNotFound) {
        return;
    }
    
    self.dataDetectorTypes = UIDataDetectorTypeLink;
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] init];
    
    if (self.attributedText) {
        attrStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    }
    
    [attrStr addAttribute:NSLinkAttributeName value:url range:range];
    
    self.attributedText = attrStr;
    
    self.linkTextAttributes = @{
        NSForegroundColorAttributeName: textColor,
        NSFontAttributeName: font,
        NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
        NSUnderlineColorAttributeName: underlineColor
    };
}
@end
