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

- (void)updatePlaylistWithModel:(MPPlaylistModel*)model
                         Result:(void(^)(NSError*))result{
    NSMutableDictionary* mdic = [[MTLJSONAdapter JSONDictionaryFromModel:model error:nil] mutableCopy];
    [[MPNetworkManager sharedManager] postRequestPath:@"/v1/updatePlaylist"
                                               Params:mdic
                                           Completion:^(NSDictionary * dict, NSError * err) {
        if(result){
            result(err);
        }
    }];
}

- (void)deletePlaylistWithPlaylistID:(int)playlistID
                              Result:(void(^)(NSError*))result{
    NSDictionary* param = @{@"playlist_id":@(playlistID)};
    [[MPNetworkManager sharedManager] postRequestPath:@"/v1/deletePlaylist"
                                               Params:param
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
    [mdic setObject:@(islike) forKey:@"is_like"];
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
