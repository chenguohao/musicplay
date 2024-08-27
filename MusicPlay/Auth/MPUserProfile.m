//
//  MPUserProfile.m
//  MusicPlay
//
//  Created by Chen guohao on 8/27/24.
//

#import "MPUserProfile.h"

@implementation MPUserProfile
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"name": @"name",
        @"avatar": @"avatar",
        @"uid": @"uid"
    };
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    [coder encodeObject:self.name forKey:@"profile_name"];
    [coder encodeInteger:self.uid forKey:@"profile_uid"];
    [coder encodeObject:self.avatar forKey:@"profile_avatar"];
    // 继续编码其他属性
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
//    self = [super init];
    if (self) {
        _name = [coder decodeObjectForKey:@"profile_name"];
        _uid = [coder decodeIntegerForKey:@"profile_uid"];
        _avatar = [coder decodeObjectForKey:@"profile_avatar"];
        // 继续解码其他属性
    }
    return self;
}

@end
