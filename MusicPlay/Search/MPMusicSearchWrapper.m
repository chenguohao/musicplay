#import "MPMusicSearchWrapper.h"
#import <StoreKit/StoreKit.h>
#import "MusicPlay-Swift.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MPMusicCacheManager.h"
@implementation MPMusicSearchWrapper
- (void)requestMediaLibraryPermissionWithCompletion:(void (^)(BOOL granted, NSError *error))completion {
    [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
        if (status == MPMediaLibraryAuthorizationStatusAuthorized) {
            completion(YES, nil);
        } else {
            NSError *error = [NSError errorWithDomain:@"MPMusicSearchWrapperErrorDomain" code:1003 userInfo:@{NSLocalizedDescriptionKey: @"The requesting app does not have media library permissions."}];
            completion(NO, error);
        }
    }];
}

- (void)requestAppleMusicPermissionWithCompletion:(void (^)(BOOL granted, NSError *error))completion {
    [SKCloudServiceController requestAuthorization:^(SKCloudServiceAuthorizationStatus status) {
        if (status == SKCloudServiceAuthorizationStatusAuthorized) {
            completion(YES, nil);
        } else {
            NSError *error = [NSError errorWithDomain:@"MPMusicSearchWrapperErrorDomain" code:1002 userInfo:@{NSLocalizedDescriptionKey: @"The requesting app does not have the necessary permissions."}];
            completion(NO, error);
        }
    }];
}

- (void)searchForSongsWithQuery:(NSString *)query completion:(MPMusicSearchCompletionHandler)completion {
    if (query.length == 0) {
        if (completion) {
            completion(nil, [NSError errorWithDomain:@"MPMusicSearchWrapperErrorDomain" code:1001 userInfo:@{NSLocalizedDescriptionKey: @"Query string is empty."}]);
        }
        return;
    }
    
    [self requestAppleMusicPermissionWithCompletion:^(BOOL granted, NSError *error) {
           if (granted) {
               [self performSearchWithQuery:query completion:completion];
           } else {
               if (completion) {
                   completion(nil, error);
               }
           }
       }];
    
   
}


- (void)performSearchWithQuery:(NSString *)query completion:(MPMusicSearchCompletionHandler)completion {
    
    MusicKitWrapper* wrap = [MusicKitWrapper new];
    [wrap searchWithKeyword:query completionHandler:^(NSArray*info) {
         
        [[MPMusicCacheManager sharedInstance] saveList:info];
        int n = 0;
        completion(info,nil);
    }];
     

}



@end
