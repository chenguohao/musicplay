//
//  MPProfileManager.m
//  MusicPlay
//
//  Created by Chen guohao on 8/27/24.
//

#import "MPProfileManager.h"
#import "MPUserProfile.h"
@implementation MPProfileManager
+ (instancetype)sharedManager {
    
    static MPProfileManager *objc = NULL;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objc = [[MPProfileManager alloc] init];
    });
    
    return objc;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        MPUserProfile *cachedUser = [self loadCacheUserProfile];
           if (cachedUser) {
               self.curUser = cachedUser;
           }
    }
    return self;
}

- (void)cacheUserProfile:(MPUserProfile*)user{
    NSError* err;
    NSData *userData     = [NSKeyedArchiver archivedDataWithRootObject:user ];
     
    [[NSUserDefaults standardUserDefaults] setObject:userData forKey:@"cachedUserprofile"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//- (MPUserProfile*)loadCacheUserProfile{
//    return [[NSUserDefaults standardUserDefaults] objectForKey:@"cachedUserprofile"];
//}
- (MPUserProfile *)loadCacheUserProfile {
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"cachedUserprofile"];
    if (userData) {
        MPUserProfile *user =[NSKeyedUnarchiver unarchiveObjectWithData:userData ];
        return user;
    }
    return nil;
}
- (void)removeUserCache{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cachedUserprofile"];
}

@end
