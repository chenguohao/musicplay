//
//  MPNetworkManager.h
//  MusicPlay
//
//  Created by Chen guohao on 8/29/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPNetworkManager : NSObject

+ (instancetype)sharedManager;
- (void)getRequestPath:(NSString*)path
                Params:(NSDictionary*)params
            Completion:(void(^)(id ,NSError*))block;

- (void)postRequestPath:(NSString*)path
                Params:(NSDictionary*)params
             Completion:(void(^)(id ,NSError*))block;
@end

NS_ASSUME_NONNULL_END
