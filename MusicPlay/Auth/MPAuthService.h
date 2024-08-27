//
//  MPAuthService.h
//  MusicPlay
//
//  Created by Chen guohao on 8/26/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPAuthService : NSObject
- (void)loginWithAppleWithComplete:(void(^)(NSError*))block;
@end
NS_ASSUME_NONNULL_END
