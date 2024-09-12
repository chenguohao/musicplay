//
//  D9ReportAlertViewController.m
//  KuKoo
//
//  Created by Chen guohao on 2/5/24.
//

#import "D9ReportAlert.h"
#import "ReportManager.h"
@interface D9ReportAlert ()
@end

@implementation D9ReportAlert
+ (instancetype)sharedInstance {
    
    static D9ReportAlert *objc = NULL;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objc = [[D9ReportAlert alloc] init];
    });
    
    return objc;
}

-(void)showReportWithContentID:(int)contentID
                      UserID:(int)authID
                   FinishBlock:(void(^)(NSString*))finishBlock{
 
    UIAlertController *sheets = [UIAlertController alertControllerWithTitle:CustomLocalizedString(@"Report", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:CustomLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    
    [sheets addAction:cancelAction];
    @weakify(self)
    
    UIAlertAction *hideContentAction = [UIAlertAction actionWithTitle:@"Hide this content" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self)
        [self _reportAudioWithReason:@"Hide this content" ContentID:contentID AuthorID:authID FinishBlock:finishBlock];
    }];
    [sheets addAction:hideContentAction];
    
    UIAlertAction *hideUserAction = [UIAlertAction actionWithTitle:@"Hide this user" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self)
        [self _reportAudioWithReason:@"Hide this user" ContentID:contentID AuthorID:authID FinishBlock:finishBlock];
    }];
    [sheets addAction:hideUserAction];
    
    UIAlertAction *eroticAction = [UIAlertAction actionWithTitle:CustomLocalizedString(@"Erotic", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self)
        [self _reportAudioWithReason:@"EROTIC" ContentID:contentID AuthorID:authID FinishBlock:finishBlock];
    }];
    [sheets addAction:eroticAction];
    
    UIAlertAction *abuseAction = [UIAlertAction actionWithTitle:CustomLocalizedString(@"Abuse", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self)
        [self _reportAudioWithReason:@"ABUSE" ContentID:contentID AuthorID:authID FinishBlock:finishBlock];
    }];
    [sheets addAction:abuseAction];
    
    UIAlertAction *advertisingAction = [UIAlertAction actionWithTitle:CustomLocalizedString(@"Advertising", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self)
        [self _reportAudioWithReason:@"ADVERTISING" ContentID:contentID AuthorID:authID FinishBlock:finishBlock];
    }];
    [sheets addAction:advertisingAction];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:CustomLocalizedString(@"Other Bad Things", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self)
        [self _reportAudioWithReason:@"OTHER" ContentID:contentID AuthorID:authID FinishBlock:finishBlock];
    }];
    [sheets addAction:otherAction];
    [[MPUIManager.sharedManager getCurrentViewController] presentViewController:sheets animated:YES completion:nil];
}

- (void)_reportAudioWithReason:(NSString *)reason
                     ContentID:(int)contentID
                      AuthorID:(int)userID
                   FinishBlock:(void(^)(NSString*))finishBlock{
   
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([reason containsString:@"Hide"]) {
                if ([reason isEqualToString:@"Hide this user"]) {
                    [DNEHUD showMessage:@"You won't see this user's content."];
                    [[ReportManager sharedManager] hideUser:userID];
                }else{
                    [DNEHUD showMessage:@"You won't see this content."];
                    [[ReportManager sharedManager] hideContent:contentID];
                }
        }else{
            [DNEHUD showMessage:@"Report Success\nWe will process within 24 hours"];
        }
        if (finishBlock) {
            finishBlock(reason);
        }
    });
    
    

}
@end
