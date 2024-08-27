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
@interface MPAuthService()<ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>
@property (nonatomic,copy) void(^onResultBlock)(NSError*);
@end

@implementation MPAuthService




- (void)loginWithAppleWithComplete:(void(^)(NSError*))block{
    
    self.onResultBlock = block;
    
    ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc] init];
    ASAuthorizationAppleIDRequest *request = [provider createRequest];
    request.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
    
    ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
    controller.delegate = self;
    controller.presentationContextProvider = self;
    [controller performRequests];
}
#pragma mark - 验证服务
-(void)serververifyWithUserID:(NSString *)uid authorCode:(NSString *)code token:(NSString *)token
{
    NSDictionary *dict1 = [self jwtDecodeWithJwtString:token];
    NSLog(@">>解析原始的:%@",dict1);
    NSString* secret = [self genSecret];
    NSDictionary *dict = @{@"client_id":@"com.xes.melody",
                           @"code":code,
                           @"grant_type":@"authorization_code",
                           @"client_secret":secret};
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
 
    [manager POST:@"https://appleid.apple.com/auth/token" parameters:dict 
          headers:nil
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"--success-->%@",responseObject);
        NSDictionary *dict2 = [self jwtDecodeWithJwtString:[responseObject objectForKey:@"id_token"]];
        NSLog(@">>解析请求到的:%@",dict2);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"--error-->%@",error.localizedDescription);
    }];
}

-(NSDictionary *)jwtDecodeWithJwtString:(NSString *)jwtStr {
    NSArray * segments = [jwtStr componentsSeparatedByString:@"."];
    NSString * base64String = [segments objectAtIndex:1];
    int requiredLength = (int)(4 *ceil((float)[base64String length]/4.0));
    int nbrPaddings = requiredLength - (int)[base64String length];
    if(nbrPaddings > 0){
        NSString * pading = [[NSString string] stringByPaddingToLength:nbrPaddings withString:@"=" startingAtIndex:0];
        base64String = [base64String stringByAppendingString:pading];
    }
    base64String = [base64String stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
    base64String = [base64String stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
    NSData * decodeData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    NSString * decodeString = [[NSString alloc] initWithData:decodeData encoding:NSUTF8StringEncoding];
    NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:[decodeString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    return jsonDict;
}

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


- (void)requestLogin:(NSDictionary*)params{
    NSString *urlString = @"http://192.168.1.221:8011/v1/appleSign";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];

        [manager POST:urlString parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"Response: %@", responseObject);
            
            if([responseObject[@"code"] intValue] != 0){
                int oo = responseObject[@"code"];
            }else{
                NSDictionary* userdic = responseObject[@"data"];
                MPUserProfile *user = [MTLJSONAdapter modelOfClass:MPUserProfile.class fromJSONDictionary:userdic error:nil];
                [MPProfileManager sharedManager].curUser = user;
                [[MPProfileManager sharedManager] cacheUserProfile:user];
            }
            
        
            
            
            if(self.onResultBlock){
                self.onResultBlock(nil);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Error: %@", error);
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
