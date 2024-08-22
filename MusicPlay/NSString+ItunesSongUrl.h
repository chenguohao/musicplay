//
//  NSString+ItunesSongUrl.h
//  MusicPlay
//
//  Created by Chen guohao on 8/14/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ItunesSongUrl)
- (NSString*)getWrappedUrlWithW:(int)width
                              H:(int)height;
@end

NS_ASSUME_NONNULL_END
