//
//  MPAuthService.m
//  MusicPlay
//
//  Created by Chen guohao on 8/26/24.
//

#import "MPAuthService.h"
#import "MPUIManager.h"
#import "AFNetworking/AFNetworking.h"
#import <AuthenticationServices/AuthenticationServices.h>
#import "MPUserProfile.h"
#import "MPProfileManager.h"
#import "MPNetworkManager.h"
@interface MPAuthService()<ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>
@property (nonatomic,copy) void(^onResultBlock)(NSError*);
@end

@implementation MPAuthService




- (void)loginWithAppleWithComplete:(void(^)(NSError*))block{
    
    self.onResultBlock = block;
    
    
#if TARGET_OS_SIMULATOR
    [self onSimulatorLogin];
    return;
#endif
    
    ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc] init];
    ASAuthorizationAppleIDRequest *request = [provider createRequest];
    request.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
    
    ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
    controller.delegate = self;
    controller.presentationContextProvider = self;
    [controller performRequests];
}
#pragma mark - 验证服务


// ASAuthorizationControllerDelegate method
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization {
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        ASAuthorizationAppleIDCredential *appleIDCredential = (ASAuthorizationAppleIDCredential *)authorization.credential;
        
        // 处理获取的Apple ID凭证
//        NSString* authorizationCode = appleIDCredential.authorizationCode;
        NSString *authorizationCode = [[NSString alloc] initWithData:appleIDCredential.authorizationCode encoding:NSUTF8StringEncoding];
        NSString *userID = appleIDCredential.user;
        NSString *email = appleIDCredential.email;
        NSString *fullName = [NSString stringWithFormat:@"%@ %@", appleIDCredential.fullName.givenName, appleIDCredential.fullName.familyName];
        NSString *idToken = [[NSString alloc] initWithData:appleIDCredential.identityToken encoding:NSUTF8StringEncoding];
              
        email = @"chenguohaox@sina.com";
        fullName = @"Chen guohao";
        
        NSDictionary *postData = @{
                  @"authorizationCode": authorizationCode,
                  @"userID": userID,
                  @"email": email ? email : @"",
                  @"fullName": fullName,
                  @"idToken": idToken
              };
        // 在这里可以发送凭证到后端进行进一步验证
        [self requestLogin:postData];
//        [self serververifyWithUserID:userID authorCode:authorizationCode token:idToken];
    }
}

- (void)onSimulatorLogin{
    NSDictionary *postData = @{
              @"authorizationCode": @"c905018ad7f4c451b87cec842e3a8aa7c.0.srwr.7o7tf4OmoYoWyPdb2A6rGQ",
              @"userID": @"000161.a0c7369de65243fc88265540a03091ea.0324",
              @"email": @"xes@test.com",
              @"fullName": @"Xes",
              @"idToken": @"eyJraWQiOiJwZ2duUWVOQ09VIiwiYWxnIjoiUlMyNTYifQ.eyJpc3MiOiJodHRwczovL2FwcGxlaWQuYXBwbGUuY29tIiwiYXVkIjoiY29tLnhlcy5tZWxvZHkiLCJleHAiOjE3MjYxMzEwNjUsImlhdCI6MTcyNjA0NDY2NSwic3ViIjoiMDAwMTYxLmEwYzczNjlkZTY1MjQzZmM4ODI2NTU0MGEwMzA5MWVhLjAzMjQiLCJjX2hhc2giOiJkZ18tdXhiOWItVjNoZmRObHRjSmtRIiwiZW1haWwiOiJjaGVuZ3VvaGFveEBzaW5hLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJhdXRoX3RpbWUiOjE3MjYwNDQ2NjUsIm5vbmNlX3N1cHBvcnRlZCI6dHJ1ZX0.PGOTui0n-bDQ9iFATZXs4KWBjGUiL-crKBff_zSjsg9ifCs8KI5gc6mnxx3v7hhUG9kxqTjY6zZBiGTDKcXmmcCTNnZjz2NyTlYcDF2N6rHNsLYW7G9wtBLLQKfpnWJX4jkh8eSUCkBRBRKdHKZ8Mf4ZEvOvXgYgml_hSoA_dHQGv_H9fWbQrInEDmGNxPEWfzoOUwSqPvyf--mQML1xTzOX8HJNwcmz8phjQlPBb2GTjuQHqDc0fzkZFU5TXpVMCj3tJ_QZwS-O2YdrJtiVUY6hUHz12AM1P6H0kFsBj_lMS0d4CPUgB1i6QTjSOqwZd33WVqK55zopX2MnBg8Gnw"
          };
    // 在这里可以发送凭证到后端进行进一步验证
    [self requestLogin:postData];
}

- (void)requestLogin:(NSDictionary*)params{

    [DNEHUD showLoading:@""];
    [[MPNetworkManager sharedManager] postRequestPath:@"/v1/appleSign"
                                               Params:params
                                           Completion:^(id responseObject, NSError * err) {
        NSLog(@"Response: %@", responseObject);
        [DNEHUD hideHUD];
        if(err){
            if(self.onResultBlock){
                self.onResultBlock(err);
            }
        }else{
            if([responseObject[@"code"] intValue] != 0){
                int oo = [responseObject[@"code"] intValue];
                NSError* error = [NSError errorWithDomain:@"com.xes.Melodie" code:oo userInfo:@{@"msg":responseObject[@"msg"]}];
                if(self.onResultBlock){
                    self.onResultBlock(error);
                }
            }else{
                NSDictionary* userdic = responseObject;
                MPUserProfile *user = [MTLJSONAdapter modelOfClass:MPUserProfile.class fromJSONDictionary:userdic error:nil];
                [MPProfileManager sharedManager].curUser = user;
                [[MPProfileManager sharedManager] cacheUserProfile:user];
            }
            
        
            
            
            if(self.onResultBlock){
                self.onResultBlock(nil);
            }
        }
    }];
    
    
    
}

// ASAuthorizationControllerDelegate method
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error {
    NSLog(@"Authorization failed: %@", error.localizedDescription);
    if(self.onResultBlock){
        self.onResultBlock(error);
    }
}

// ASAuthorizationControllerPresentationContextProviding method
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller {
    return MPUIManager.sharedManager.curWindow;
}


#pragma  mark -

- (NSString*)genSecret{
    NSString* keyID = @"9TA7FWK494";
    NSString* teamID = @"525KY2226B";
    NSString* clientID = @"com.xes.melody";
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"AuthKey_9TA7FWK494" ofType:@"p8"];
    
    return generateJWT(teamID,clientID,keyID,filePath,180);
}


NSString *generateJWT(NSString *teamID, NSString *clientID, NSString *keyID, NSString *keyFilePath, NSInteger validityPeriod) {
    // 读取 .p8 文件内容
    NSString *privateKeyString = [NSString stringWithContentsOfFile:keyFilePath encoding:NSUTF8StringEncoding error:nil];
    NSData *privateKeyData = [[NSData alloc] initWithBase64EncodedString:privateKeyString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    // 加载 EC 私钥
    SecKeyRef privateKey = NULL;
    NSDictionary *options = @{
        (__bridge id)kSecAttrKeyType: (__bridge id)kSecAttrKeyTypeECSECPrimeRandom,
        (__bridge id)kSecAttrKeyClass: (__bridge id)kSecAttrKeyClassPrivate,
    };
    privateKey = SecKeyCreateWithData((__bridge CFDataRef)privateKeyData, (__bridge CFDictionaryRef)options, NULL);

    // 准备 JWT 的头部和负载部分
    NSDictionary *header = @{@"alg": @"ES256", @"kid": keyID};
    NSDictionary *payload = @{
        @"iss": teamID,
        @"iat": @([[NSDate date] timeIntervalSince1970]),
        @"exp": @([[NSDate dateWithTimeIntervalSinceNow:86400 * validityPeriod] timeIntervalSince1970]),
        @"aud": @"https://appleid.apple.com",
        @"sub": clientID
    };
    
    // 编码为 Base64URL
    NSString *headerBase64 = [[NSJSONSerialization dataWithJSONObject:header options:0 error:nil] base64EncodedStringWithOptions:0];
    NSString *payloadBase64 = [[NSJSONSerialization dataWithJSONObject:payload options:0 error:nil] base64EncodedStringWithOptions:0];
    
    headerBase64 = [[headerBase64 stringByReplacingOccurrencesOfString:@"=" withString:@""]
                    stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    headerBase64 = [headerBase64 stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    
    payloadBase64 = [[payloadBase64 stringByReplacingOccurrencesOfString:@"=" withString:@""]
                     stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    payloadBase64 = [payloadBase64 stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    
    NSString *signingInput = [NSString stringWithFormat:@"%@.%@", headerBase64, payloadBase64];
    
    // 签名数据
    NSData *signingInputData = [signingInput dataUsingEncoding:NSUTF8StringEncoding];
    size_t signedBytesSize = SecKeyGetBlockSize(privateKey);
    uint8_t *signedBytes = malloc(signedBytesSize);
    
    OSStatus status = SecKeyRawSign(privateKey,
                                    kSecPaddingPKCS1,
                                    signingInputData.bytes,
                                    signingInputData.length,
                                    signedBytes,
                                    &signedBytesSize);
    
    if (status != errSecSuccess) {
        return nil; // 签名失败
    }
    
    NSData *signature = [NSData dataWithBytes:signedBytes length:signedBytesSize];
    free(signedBytes);
    
    NSString *signatureBase64 = [signature base64EncodedStringWithOptions:0];
    signatureBase64 = [[signatureBase64 stringByReplacingOccurrencesOfString:@"=" withString:@""]
                       stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    signatureBase64 = [signatureBase64 stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    
    NSString *jwt = [NSString stringWithFormat:@"%@.%@.%@", headerBase64, payloadBase64, signatureBase64];
    
    CFRelease(privateKey);
    return jwt;
}


@end
