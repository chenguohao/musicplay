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
#import "MPPlaylistModel.h"
@implementation MPPlaylistService
- (void)createPlaylistWithModel:(MPPlaylistModel*)model
                         Result:(void(^)(NSError*))result{
    
    
    NSMutableDictionary* mdic = [[MTLJSONAdapter JSONDictionaryFromModel:model error:nil] mutableCopy];
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

- (void)likePlayList:(BOOL)islike
          PlaylistID:(int)playlistID
              Result:(void(^)(NSError*))result{
    NSMutableDictionary* mdic = [NSMutableDictionary new];
    [mdic setObject:@(islike) forKey:@"islike"];
    [mdic setObject:@(playlistID) forKey:@"target_id"];
    [[MPNetworkManager sharedManager] postRequestPath:@"/v1/like"
                                               Params:mdic
                                           Completion:^(id nul, NSError * err) {
      
        if(result){
            result(err);
        }
    }];
}


- (void)addPlayCount:(int)playlistID
              Result:(void(^)(BOOL isAdd,NSError*))result{
    NSMutableDictionary* mdic = [NSMutableDictionary new];
    [mdic setObject:@(playlistID) forKey:@"target_id"];
    [[MPNetworkManager sharedManager] postRequestPath:@"/v1/addPlayCount"
                                               Params:mdic
                                           Completion:^(NSDictionary* info, NSError * err) {
        BOOL isAdd = false;
        isAdd = [info[@"isAdd"] boolValue];
        if(result){
            result(isAdd,err);
        }
    }];
}
@end
