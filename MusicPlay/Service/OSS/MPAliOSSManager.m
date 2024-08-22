//
//  MPAliOSSManager.m
//  ossDemo
//
//  Created by Chen guohao on 8/15/24.
//

#import "MPAliOSSManager.h"
#import <AliyunOSSiOS/AliyunOSSiOS.h>

/**
 * 获取sts信息的url,配置在业务方自己的搭建的服务器上。详情可见https://help.aliyun.com/document_detail/31920.html
 */
#define OSS_STS_URL                 @"oss_sts_url"
#define OSS_BUCKET  @"sdstorage"
#define OSS_PATH @"rawimg"
#define AccessKeyID @"Hnpyc8N2qxmoxku2"
#define AccessKeySecret @"sXWEX5pKXV4oEa2B7xY6hkKx8mDxVA"
/**
 * bucket所在的region的endpoint,详情可见https://help.aliyun.com/document_detail/31837.html
 */
#define EndPoint   @"oss-cn-hongkong.aliyuncs.com"
@interface  MPAliOSSManager()
@property (nonatomic, strong) OSSClient *client;
@end

@implementation MPAliOSSManager
+ (instancetype)sharedManager {
    
    static MPAliOSSManager *objc = NULL;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objc = [[MPAliOSSManager alloc] init];
    });
    
    return objc;
}


-(instancetype)init{
    self = [super init];
    OSSAuthCredentialProvider *credentialProvider = [[OSSAuthCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * _Nullable{
        
        OSSFederationToken * token = [OSSFederationToken new];
        token.tAccessKey = AccessKeyID;
        token.tSecretKey = AccessKeySecret;
        return token;
    }];
    
//    id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:@"AccessKeyId" secretKeyId:@"AccessKeySecret" securityToken:@"SecurityToken"];
    
    // client端的配置,如超时时间，开启dns解析等等
    OSSClientConfiguration *cfg = [[OSSClientConfiguration alloc] init];
    
    self.client = [[OSSClient alloc] initWithEndpoint:[@"https://" stringByAppendingString:EndPoint]
                               credentialProvider:credentialProvider
                              clientConfiguration:cfg];
    return self;
}

- (void)uploadData:(NSData*)data withBlock:(void(^)(NSString *,NSError*))resultBlock{
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];

    // required fields
    put.bucketName = OSS_BUCKET;
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-ddHHmmssSSS"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSString * imagName = [NSString stringWithFormat:@"cover%@.jpg",dateString];
    
    put.objectKey = [OSS_PATH stringByAppendingPathComponent:imagName];
    
    put.uploadingData = data;

    // optional fields
//    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
//        NSLog(@"\n%lf%", (double)totalByteSent*100/totalBytesExpectedToSend);
//    };
    put.contentType = @"";
    put.contentMd5 = @"";
    put.contentEncoding = @"";
    put.contentDisposition = @"";

    OSSTask * putTask = [self.client putObject:put];

    [putTask continueWithBlock:^id(OSSTask *task) {
        NSLog(@"objectKey: %@", put.objectKey);
        if (!task.error) {
            NSString* finUrl = [NSString stringWithFormat:@"https://%@.%@/%@/%@",OSS_BUCKET,EndPoint,OSS_PATH,imagName];
//            @"https://""sdstorage.oss-cn-hongkong.aliyuncs.com/rawimg/aa.jpg"
            NSLog(@"upload object success : %@",finUrl);
            if(resultBlock)resultBlock(finUrl,nil);
        } else {
            NSLog(@"upload object failed, error: %@" , task.error);
            if(resultBlock)resultBlock(nil,task.error);
        }
        return nil;
    }];
}
- (void)listObjectsInBucket {
    OSSGetBucketRequest * getBucket = [OSSGetBucketRequest new];
    getBucket.bucketName = OSS_BUCKET;
    getBucket.delimiter = @"";
    getBucket.prefix = @"";


    OSSTask * getBucketTask = [self.client getBucket:getBucket];

    [getBucketTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            OSSGetBucketResult * result = task.result;
            NSLog(@"get bucket success!");
            for (NSDictionary * objectInfo in result.contents) {
                NSLog(@"list object: %@", objectInfo);
            }
        } else {
            NSLog(@"get bucket failed, error: %@", task.error);
        }
        return nil;
    }];
}
@end
