//
//  MPAliOSSManager.h
//  ossDemo
//
//  Created by Chen guohao on 8/15/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPAliOSSManager : NSObject
+ (instancetype)sharedManager;
- (void)uploadData:(NSData*)data withBlock:(void(^)(NSString *,NSError*))resultBlock;
@end

NS_ASSUME_NONNULL_END
