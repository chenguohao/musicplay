//
//  MPPlaylistCell.h
//  MusicPlay
//
//  Created by Chen guohao on 8/13/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

 

@interface MPPlaylistSectionHeader : UIView
@property (nonatomic, assign) BOOL isExpanded;
- (void)configureWithDictionary:(NSDictionary *)dict
                          index:(NSInteger)index;
- (void)setMoreAction:(void(^)(void))block;
@end


NS_ASSUME_NONNULL_END
