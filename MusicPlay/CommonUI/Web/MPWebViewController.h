#import <UIKit/UIKit.h>

@interface MPWebViewController : UIViewController

// 初始化方法，用于传递协议的 URL
- (instancetype)initWithURL:(NSString *)url;

@end
