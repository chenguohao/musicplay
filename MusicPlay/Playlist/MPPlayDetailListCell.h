#import <UIKit/UIKit.h>

@interface MPPlayDetailListCell : UITableViewCell
@property (nonatomic,strong)UIColor* bgColor;
- (void)configureWithInfo:(NSDictionary *)info;
-(void)setBgColor2:(UIColor *)bgColor;
@end
