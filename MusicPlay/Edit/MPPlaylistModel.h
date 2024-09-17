//
//  MPPlaylistModel.h
//  MusicPlay
//
//  Created by Chen guohao on 9/15/24.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
NS_ASSUME_NONNULL_BEGIN
@interface MPPlaylistModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,strong)NSString* coverUrl;
@property (nonatomic,strong)NSString* title;
@property (nonatomic,strong)NSArray* items;
@property (nonatomic, assign)NSInteger ownerID;
@property (nonatomic, assign)long createAt;
@property (nonatomic,assign)NSInteger playlistID;
@property (nonatomic,assign)NSInteger likeCount;
@property (nonatomic,assign)NSInteger playCount;
@property (nonatomic,assign)BOOL isLiked;
@property (nonatomic,strong)MPUserProfile* user;
@end

NS_ASSUME_NONNULL_END
