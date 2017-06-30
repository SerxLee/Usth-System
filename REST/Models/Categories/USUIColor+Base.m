//
//  USUIColor+Base.m
//  Usth System
//
//  Created by Serx on 2017/5/15.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import "USUIColor+Base.h"

@implementation UIColor (Base)

/**
 *  根据十六进制颜色生成UIColor
 *
 *  @param color 十六进制颜色字符串
 *
 *  @return 返回UIColor
 */
+ (UIColor *) colorWithHexString: (NSString *)color{
    
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
    cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
    cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
    return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
    
}

+ (UIColor *) sexBlue{
    return [UIColor colorWithHexString:@"478cc5"];
}

+ (UIColor *) sexLightGray {
    return [UIColor colorWithHexString:@"f8f8fa"];
}

+ (UIColor *) lineGray {
    return [UIColor colorWithHexString:@"c8c7cc"];
}

+ (UIColor *) homeLightGreen {
    return [UIColor colorWithHexString:@"87b72a"];
}

+ (UIColor *) homeLightYellow {
    return [UIColor colorWithHexString:@"ffbb34"];
}

+ (UIColor *) noodleLightGray {
    return [UIColor colorWithHexString:@"f8f8fa"];
}

+ (UIColor *) noodleGray {
    return [UIColor colorWithHexString:@"e9e9eb"];
}

+ (UIColor *) noodleLoveGray {
    return [UIColor colorWithHexString:@"b3b3b3"];
}

+ (UIColor *) noodleDarkGray{
    return [UIColor colorWithHexString:@"9d9d9d"];
}

+ (UIColor *)noodlelightYellow{
    return [UIColor colorWithHexString:@"ffbb34"];
}

+ (UIColor *) noodleBlack {
    return [UIColor colorWithHexString:@"333333"];
}

+ (UIColor *)noodleBarGray{
    return [UIColor colorWithHexString:@"fafafa"];
}

+ (UIColor *) guidanceDeepOrange{
    return [UIColor colorWithHexString:@"ea7732"];
}

+ (UIColor *) noodleBlueN{
    return [UIColor colorWithHexString:@"2894da"];
}

+ (UIColor *) sexRed{
    return [UIColor colorWithHexString:@"ff57a9"];
}

+ (UIColor *) noodleBlue {
    return [UIColor colorWithHexString:@"3497da"];
}

+ (UIColor *) noodleRed {
    return [UIColor colorWithHexString:@"ec4c47"];
}

+ (UIColor *) guidanceLightBlue{
    return [UIColor colorWithHexString:@"5083cc"];
}

+ (UIColor *) guidanceLightYellow{
    return [UIColor colorWithHexString:@"e6a82e"];
}

+ (UIColor *) guidanceLightRed{
    return [UIColor colorWithHexString:@"e64c2e"];
}

+ (UIColor *) noodleDeepGray{
    return [UIColor colorWithHexString:@"6e6e6e"];
}

+ (UIColor *) noodleDeepBlue{
    return [UIColor colorWithHexString:@"5C9CEF"];
}

+ (UIColor *) musicBlue{
    return [UIColor colorWithHexString:@"6abefa"];
}


+ (UIColor *) noodleGrayBlack{
    return [UIColor colorWithHexString:@"424242"];
}

+ (UIColor *) myinforYellow{
    return [UIColor colorWithHexString:@"FFBB32"];
}

+ (UIColor *) myinforLightGreen{
    return [UIColor colorWithHexString:@"4ADAB3"];
}

+ (UIColor *) myinforLightRed{
    return [UIColor colorWithHexString:@"FE4D5F"];
}

+ (UIColor *) myinforDeepRed{
    return [UIColor colorWithHexString:@"FF554B"];
}


+ (UIColor *) myinforDeepGreen{
    return [UIColor colorWithHexString:@"62C37E"];
}


+ (UIColor *) myinforUpBlue{
    return [UIColor colorWithHexString:@"3497DA"];
}

+ (UIColor *) myinforDownBlue{
    return [UIColor colorWithHexString:@"318ECC"];
}


+ (UIColor *) myinforGray{
    return [UIColor colorWithHexString:@"8A8A8A"];
}

+ (UIColor *) musicSliderGray{
    return [UIColor colorWithHexString:@"cccccc"];
}

+ (UIColor *) videoBlue{
    return [UIColor colorWithHexString:@"4787f1"];
    
}


+ (UIColor *) commrentGray{
    return [UIColor colorWithHexString:@"b2b2b2"];
}

+ (UIColor *) updateGreen{
    return [UIColor colorWithHexString:@"52b31e"];
}

+ (UIColor *)noodleExitGray{
    return [UIColor colorWithHexString:@"e3e3e3"];
    
}

+ (UIColor *) noodleYellow {
    return [UIColor colorWithHexString:@"f9ba48"];
}

+ (UIColor *) noodleLightGreen{
    return [UIColor colorWithHexString:@"87b72a"];
}

+ (UIColor *) noodleGreen {
    return [UIColor colorWithHexString:@"9CCE24"];
}

+ (UIColor *) noodleDarkGreen {
    return [UIColor colorWithHexString:@"13b5b1"];
}

+ (UIColor *) noodleDeepGreen {
    return [UIColor colorWithHexString:@"#a7d549"];
}

+ (UIColor *) noodleBaseColor {
    return [UIColor noodleBlue];
}

+ (UIColor *) guidanceDeepRed{
    return [UIColor colorWithHexString:@"E82727"];
}

+ (UIColor *) guidanceRed{
    return [UIColor colorWithHexString:@"FF5634"];
}

+ (UIColor *) informationBlue{
    return [UIColor colorWithHexString:@"62bafb"];
}

+ (UIColor *) GiftGolden{
    return [UIColor colorWithHexString:@"fdf54c"];
}

+ (UIColor *) shareGift{
    return [UIColor colorWithHexString:@"fdb720"];
    
}

+ (UIColor *) noodleLightBlue{
    return [UIColor colorWithHexString:@"81ccff"];
}

+ (UIColor *) guidanceYellow{
    return [UIColor colorWithHexString:@"#FEBC34"];
}

+ (UIColor *) noodleDarkBlue{
    return [UIColor colorWithHexString:@"#43536E"];
}

+ (UIColor *) noodleLoginBlue{
    return [UIColor colorWithHexString:@"33bdf2"];
}

+ (UIColor *) noodleDeepRed{
    return [UIColor colorWithHexString:@"ff5534"];
}

+ (UIColor *) noodleCollegeBlue{
    return [UIColor colorWithHexString:@"373f74"];
}

+ (UIColor *) noodleWechatGreen {
    return [UIColor colorWithHexString:@"29cf34"];
}

+ (UIColor *) noodleKiteGreen {
    return [UIColor colorWithHexString:@"7db42d"];
}

+ (UIColor *) noodleGolden {
    return [UIColor colorWithHexString:@"a38843"];
}

+ (UIColor *) noodleLineGray {
    return [UIColor colorWithHexString:@"c8c7cc"];
}

+ (UIColor *) noodleTagColor {
    return [UIColor colorWithHexString:@"393b4e"];
}

+ (UIColor *) noodleTagBG {
    return [UIColor colorWithHexString:@"f7f9fc"];
}

+ (UIColor *) noodleBlueDark {
    return [UIColor colorWithHexString:@"318ECC"];
}

+ (UIColor *) noodleWatermelonRed {
    return [UIColor colorWithHexString:@"FF6A7C"];
}

+ (UIColor *) noodleLightBlack {
    return [UIColor colorWithHexString:@"000000"];
}

+ (UIColor *) noodleDeepWhite {
    return [UIColor colorWithHexString:@"ffffff"];
}

+ (UIColor *) noodleBlackDeep {
    return [UIColor colorWithHexString:@"141414"];
}

+ (UIColor *) noodlePurpleWhite{
    return [UIColor colorWithHexString:@"a8c6ff"];
}

+ (UIColor *) noodleChartBG {
    return [UIColor colorWithHexString:@"3196dd"];
}

+ (UIColor *) noodleChartYellowBG {
    return [UIColor colorWithHexString:@"ffbc32"];
}

+ (UIColor *) chatRed{
    return [UIColor colorWithHexString:@"f76e6e"];
}

+ (UIColor *) noodlePaleBlue{
    return [UIColor colorWithHexString:@"f0f9ff"];
}

+ (UIColor *) noodlePaleGreen{
    return [UIColor colorWithHexString:@"2acf35"];
}

+ (UIColor *) noodleLightPaleBlue{
    return [UIColor colorWithHexString:@"2FACEF"];
}

+ (UIColor *) noodleLightWatermelonRed{
    return [UIColor colorWithHexString:@"FF683A"];
}


@end
