//
//  MPPlaylistService.m
//  MusicPlay
//
//  Created by Chen guohao on 8/29/24.
//

#import "MPPlaylistService.h"
#import "MPNetworkManager.h"
#import "MPProfileManager.h"
#import "MPUserProfile.h"
@implementation MPPlaylistService
- (void)createPlaylistWithTitle:(NSString*)title
                          Cover:(NSString*)coverUrl
                      PlayItems:(NSArray*)items
                         Result:(void(^)(NSError*))result{
    NSMutableDictionary* mdic = [NSMutableDictionary new];
    [mdic setObject:title forKey:@"title"];
    if(coverUrl.length < 1){
        coverUrl = @"";
    }
    [mdic setObject:coverUrl forKey:@"cover" ];
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:items options:0 error:nil];
    [mdic setObject:items forKey:@"playlist" ];
    
    int UID = [MPProfileManager sharedManager].curUser.uid;
    UID = 110;
    [mdic setObject:@(UID) forKey:@"ownerID" ];
    [[MPNetworkManager sharedManager] postRequestPath:@"/v1/createPlaylist"
                                               Params:mdic
                                           Completion:^(NSDictionary * dict, NSError * err) {
        if(result){
            result(err);
        }
    }];
}

- (void)updatePlaylistWithPlayID:(NSInteger)playID
                           Title:(NSString*)title
                          Cover:(NSString*)coverUrl
                      PlayItems:(NSArray*)items
                          Result:(void(^)(NSError*))result{
    NSMutableDictionary* mdic = [NSMutableDictionary new];
    [mdic setObject:@(playID) forKey:@"playID"];
    [mdic setObject:title forKey:@"title"];
    [mdic setObject:coverUrl forKey:@"cover" ];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:items options:0 error:nil];
    [mdic setObject:jsonData forKey:@"playlist" ];
    [[MPNetworkManager sharedManager] postRequestPath:@"/v1/updatePlayList"
                                               Params:mdic
                                           Completion:^(NSDictionary * dict, NSError * err) {
        if(result){
            result(err);
        }
    }];
}



- (void)getPlaylistWithPage:(int)index
                       Size:(int)size
                     Result:(void(^)(NSArray*))result{
    NSMutableDictionary* mdic = [NSMutableDictionary new];
    [mdic setObject:@(index) forKey:@"page"];
    [mdic setObject:@(size) forKey:@"size"];
    [[MPNetworkManager sharedManager] getRequestPath:@"/v1/getPlaylist"
                                               Params:mdic
                                           Completion:^(NSArray * list, NSError * err) {
      
        if(result){
            result(list);
        }
    }];

}
@end
