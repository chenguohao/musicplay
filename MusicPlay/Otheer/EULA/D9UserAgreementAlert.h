//
//  DNEUserAgreementAlert.h
//  zaky
//
//  Created by 吴迪 on 2021/7/16.
//

#import "D9BasicAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface D9UserAgreementAlert : D9BasicAlertView

- (void)addClickLinkObserver:(void(^)(NSString *url))block;
+(NSString *)termsUrl;
+(NSString *)privacyUrl;
@end

NS_ASSUME_NONNULL_END
