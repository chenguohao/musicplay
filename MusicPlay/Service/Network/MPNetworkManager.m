//
//  MPNetworkManager.m
//  MusicPlay
//
//  Created by Chen guohao on 8/29/24.
//

#import "MPNetworkManager.h"
#import "AFNetworking/AFNetworking.h"


const NSString* HOST = @"http://127.0.0.1:8011";//@"http://192.168.1.221:8011";

@implementation MPNetworkManager

+ (instancetype)sharedManager {
    
    static MPNetworkManager *objc = NULL;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objc = [[MPNetworkManager alloc] init];
    });
    
    return objc;
}

- (void)getRequestPath:(NSString*)path
                Params:(NSDictionary*)params
          Completion:(void(^)(id ,NSError*))block{
    [self commonRequestMethod:NO
                          Path:path
                       Params:params
                   Completion:block];
}


- (void)postRequestPath:(NSString*)path
                Params:(NSDictionary*)params
          Completion:(void(^)(id,NSError*))block{
    [self commonRequestMethod:YES
                          Path:path
                       Params:params
                   Completion:block];
}


- (void)commonRequestMethod:(BOOL)isPost
                        Path:(NSString*)path
                     Params:(NSDictionary*)params
                 Completion:(void(^)(id ,NSError*))block{
    NSString* url = [NSString stringWithFormat:@"%@%@",HOST,path];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    void (^resultBlock)(NSURLSessionDataTask * , id) = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        NSLog(@"Response: %@", responseObject);
        if([responseObject[@"code"] intValue] != 0){
            int errCode = [responseObject[@"code"] intValue];
            NSError* error = [NSError errorWithDomain:@"App" code:errCode userInfo:@{@"msg":responseObject[@"msg"]}];
            if(block){
                block(nil,error);
            }
        }else{
            NSDictionary* userdic = responseObject[@"data"];
            if(block){
                block(userdic,nil);
            }
        }
    };
    
    void (^failBlock)(NSURLSessionDataTask * , id) = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if(block){
                block(nil,error);
            }
    };
    int uid = MPProfileManager.sharedManager.curUser.uid;
    NSDictionary* header = @{@"X-User-ID":@(uid).stringValue};
    
     if(isPost){
        [manager POST:url parameters:params headers:header progress:nil success:resultBlock failure:failBlock];
    }else{
        [manager GET:url parameters:params headers:header progress:nil success:resultBlock failure:failBlock];
    }
    
    
}


@end
