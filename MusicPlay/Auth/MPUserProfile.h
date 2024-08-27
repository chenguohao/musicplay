//
//  MPUserProfile.h
//  MusicPlay
//
//  Created by Chen guohao on 8/27/24.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
NS_ASSUME_NONNULL_BEGIN

@interface MPUserProfile: MTLModel<MTLJSONSerializing,NSCoding>
@property(nonatomic,strong)NSString* name;
@property(nonatomic,strong)NSString* avatar;
@property(nonatomic,assign)NSInteger uid;
- (void)encodeWithCoder:(NSCoder *)coder;
- (instancetype)initWithCoder:(NSCoder *)coder;
@end

NS_ASSUME_NONNULL_END
