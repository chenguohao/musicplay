//
//  D9ReportAlertViewController.m
//  KuKoo
//
//  Created by Chen guohao on 2/5/24.
//

#import "D9ReportAlert.h"
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

-(void)showReportWithContentID:(NSString*)contentID
                      AuthorID:(NSString*)authID
                   FinishBlock:(void(^)(NSString*))finishBlock{
 
    UIAlertController *sheets = [UIAlertController alertControllerWithTitle:CustomLocalizedString(@"Report", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:CustomLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    
    [sheets addAction:cancelAction];
    @weakify(self)
    
    UIAlertAction *hideContentAction = [UIAlertAction actionWithTitle:CustomLocalizedString(@"hide_content", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self)
        [self _reportAudioWithReason:@"hide_content" ContentID:contentID AuthorID:authID FinishBlock:finishBlock];
    }];
    [sheets addAction:hideContentAction];
    
    UIAlertAction *hideUserAction = [UIAlertAction actionWithTitle:CustomLocalizedString(@"hide_user", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self)
        [self _reportAudioWithReason:@"hide_user" ContentID:contentID AuthorID:authID FinishBlock:finishBlock];
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
                     ContentID:(NSString *)contentID
                      AuthorID:(NSString *)authorID
                   FinishBlock:(void(^)(NSString*))finishBlock{
   
    
    void (^onFinishBlock)(NSString* reason) = ^(NSString* reason){
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([reason containsString:@"hide"]) {
                
                    if ([reason isEqualToString:@"hide_user"]) {
                        [DNEHUD showMessage:CustomLocalizedString(@"toast_hide_user", nil)];
                    }else{
                        [DNEHUD showMessage:CustomLocalizedString(@"toast_hide_content", nil)];
                    }
                  
             
               
            }else{
                [DNEHUD showMessage:CustomLocalizedString(@"report_suc", nil)];
            }
        });
        if (finishBlock) {
            finishBlock(reason);
        }
    };
    
    if ([reason containsString:@"hide"]) {
        NSInteger type = 0;
        NSString* objID = @"";
        if ([reason isEqualToString:@"hide_user"]) {
            type = 2;
            objID = authorID;
        }else{
            type = 1;
            objID = contentID;
        }
        
       
        [DNEHUD showLoading:@""];
//        [D9SquareNetworkHandler blockWithType:type param:objID sender:self success:^(NSDictionary *response) {
//            DISMISSPROGRESS
//            onFinishBlock(reason);
//        } error:^(NSError *error) {
//            DISMISSPROGRESS
//        }];
    }else{
//        SHOWPROGRESS
//        [GJNewAprReq reportAudioContentWithContentID:contentID author:authorID reason:reason success:^(id  _Nonnull response) {
//            DISMISSPROGRESS
//            onFinishBlock(reason);
//        } ifFaile:^(NSError * _Nonnull error) {
//            DISMISSPROGRESS
//        }];
    }
    

}
@end
