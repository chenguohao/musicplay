//
//  D9ReportAlertViewController.h
//  KuKoo
//
//  Created by Chen guohao on 2/5/24.
//

#import <UIKit/UIKit.h>
@class GJAudioIntroViewModel;
NS_ASSUME_NONNULL_BEGIN

@interface D9ReportAlert : NSObject
+ (instancetype)sharedInstance;
-(void)showReportWithContentID:(NSString*)contentID
                      AuthorID:(NSString*)authID
                   FinishBlock:(void(^)(NSString*))finishBlock;
@end

NS_ASSUME_NONNULL_END
