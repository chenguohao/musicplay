//
//  MPPlaylistCell.h
//  MusicPlay
//
//  Created by Chen guohao on 8/13/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

 
@class MPPlaylistModel;
@interface MPPlaylistSectionHeader : UIView

@property (nonatomic, strong) MPPlaylistModel* model;
@property (nonatomic, assign) BOOL isExpanded;
- (void)configureWithModel:(MPPlaylistModel *)model
                          index:(NSInteger)index;
- (void)setMoreAction:(void(^)(void))block;
- (void)setLikeAvtion:(void(^)(BOOL))block;
@end


NS_ASSUME_NONNULL_END
