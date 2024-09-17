//
//  MPPlaylistModel.m
//  MusicPlay
//
//  Created by Chen guohao on 9/15/24.
//

#import "MPPlaylistModel.h"

@implementation MPPlaylistModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"coverUrl": @"cover_url",
        @"title": @"title",
        @"items": @"list_item",
        @"ownerID":@"owner_id",
        @"createAt":@"created_at",
        @"playlistID":@"playlist_id",
        @"likeCount":@"like_count",
        @"playCount":@"play_count",
        @"isLiked":@"is_liked",
        @"user":@"Owner"
    };
}
@end
