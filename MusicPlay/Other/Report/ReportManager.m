//
//  ReportManager.m
//  MusicPlay
//
//  Created by Chen guohao on 9/12/24.
//

#import "ReportManager.h"

#define KHIDEUSER    @"ReportKeyHideUser"
#define KHIDECONTENT @"ReportKeyHideContent"

@interface ReportManager()
@property(nonatomic,strong)NSMutableArray* userSet;
@property(nonatomic,strong)NSMutableArray* contentSet;
@end

@implementation ReportManager
+ (instancetype)sharedManager {
    
    static ReportManager *objc = NULL;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objc = [[ReportManager alloc] init];
    });
    
    return objc;
}


-(NSMutableArray *)userSet{
    if(_userSet == nil){
        _userSet = [NSMutableArray new];
    }
    return _userSet;
}

-(NSMutableArray *)contentSet{
    if(_contentSet == nil){
        _contentSet = [NSMutableArray new];
    }
    return _contentSet;
}

- (void)hideUser:(int)userID{
//    [self.userSet addObject:@(userID)];
//    return;
    NSMutableArray* set = [[[NSUserDefaults standardUserDefaults] objectForKey:KHIDEUSER] mutableCopy];
    if(set == nil){
        set = [NSMutableArray new];
    }
    if(![set containsObject:@(userID)]){
        [set addObject:@(userID)];
    }
    [[NSUserDefaults standardUserDefaults] setObject:set forKey:KHIDEUSER];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)hideContent:(int)contentID{
//    [self.contentSet addObject:@(contentID)];
//    return;
    
    NSMutableArray* set = [[[NSUserDefaults standardUserDefaults] objectForKey:KHIDECONTENT] mutableCopy];
    if(set == nil){
        set = [NSMutableArray new];
    }
    if(![set containsObject:@(contentID)]){
        [set addObject:@(contentID)];
    }
    [[NSUserDefaults standardUserDefaults] setObject:set forKey:KHIDECONTENT];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isOKWithUser:(int)userID
           ContentID:(int)contentID{
    
//    NSSet* userSet = self.userSet;
    NSArray* userSet = [[NSUserDefaults standardUserDefaults] objectForKey:KHIDEUSER] ;
    if ([userSet containsObject:@(userID)]) {
        return NO;
    }
    
//    NSSet* contentSet = self.contentSet;
    NSArray* contentSet = [[NSUserDefaults standardUserDefaults] objectForKey:KHIDECONTENT ] ;
    if ([contentSet containsObject:@(contentID)]) {
        return NO;
    }
    
    return YES;
}

@end
