//
//  MPUITheme.m
//  MusicPlay
//
//  Created by Chen guohao on 9/6/24.
//

#import "MPUITheme.h"
#import "UIColor+Hex.h"
@implementation MPUITheme


+(UIColor*)mainDark{
    return [UIColor colorWithHexString:@"15321F"];
}

+(UIColor*)mainLight{
    return [UIColor colorWithHexString:@"92DA8B"];
}

+(UIColor*)contentBg{
    return [UIColor colorWithHexString:@"1B4432"];
}

+(UIColor*)contentBg_semi{
    return [UIColor colorWithHexString:@"2D6A4F"];
}

+(UIColor*)contentText{
    return [UIColor colorWithHexString:@"92DA8B"];
}

+(UIColor*)contentText_semi{
    return [UIColor colorWithHexString:@"74C69D"];
}

+(UIColor*)theme_white{
    return [UIColor colorWithHexString:@"D8F3DC"];
}

@end
