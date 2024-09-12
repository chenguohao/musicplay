//
//  ReportManager.h
//  MusicPlay
//
//  Created by Chen guohao on 9/12/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReportManager : NSObject
+ (instancetype)sharedManager;
- (void)hideContent:(int)playID;
- (void)hideUser:(int)userID;
- (BOOL)isOKWithUser:(int)userID
           ContentID:(int)contentID;
@end

NS_ASSUME_NONNULL_END
