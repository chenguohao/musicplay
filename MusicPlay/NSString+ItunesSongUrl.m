//
//  NSString+ItunesSongUrl.m
//  MusicPlay
//
//  Created by Chen guohao on 8/14/24.
//

#import "NSString+ItunesSongUrl.h"

@implementation NSString (ItunesSongUrl)
- (NSString*)getWrappedUrlWithW:(int)width
                              H:(int)height{
    NSString* resultUrl = [self stringByReplacingOccurrencesOfString:@"{w}" withString:@(width).stringValue];
    resultUrl = [resultUrl stringByReplacingOccurrencesOfString:@"{h}" withString:@(height).stringValue];
   
    return  resultUrl;
}
@end
