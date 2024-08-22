//
//  MPMusicCacheManager.m
//  MusicPlay
//
//  Created by Chen guohao on 8/10/24.
//

#import "MPMusicCacheManager.h"

@implementation MPMusicCacheManager

+ (instancetype)sharedInstance {
  static MPMusicCacheManager *sharedInstance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[MPMusicCacheManager alloc] init];
  });
  return sharedInstance;
}

- (NSString *)plistFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"songsData.plist"];
    return filePath;
}


- (NSArray*)loadPlaylist:(NSString*)playlistID{
    NSArray* array = @[];
    
    array = [NSArray arrayWithContentsOfFile:[self plistFilePath]];
    if(array.count < 1){
        NSString* path  = [[NSBundle mainBundle] pathForResource:@"songsData_musicapi" ofType:@"plist"];
        array = [NSArray arrayWithContentsOfFile:path];
    }
    return array;
}

- (void)saveList:(NSArray*)list{
    NSString* path = [self plistFilePath];
    [list writeToFile:path atomically:YES];
    NSLog(path);
}

@end
