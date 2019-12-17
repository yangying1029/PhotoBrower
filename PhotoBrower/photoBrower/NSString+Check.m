//
//  NSString+Check.m
//

//

#import "NSString+Check.h"

@implementation NSString (Check)

/**
 *  判断字符串是否为空
 *
 *  @param str 字符串
 *
 *  @return BOOL
 */
+ (BOOL)isNull:(NSString *)str
{
    if (str == nil || str == Nil || str == NULL) {
        return YES;
    }
    if ([str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (str == [NSString alloc]) {
        return YES;
    }
    if (![str isKindOfClass:[NSString class]]) {
        return YES;
    }
    if (str.length == 0) {
        return YES;
    }
    return NO;
}


/**
 *  判断是否为手机号
 *
 *  @param mobileNumber 手机号
 *
 *  @return BOOL
 */
+ (BOOL)isMobileNumber:(NSString *)mobile
{
    // 空值判断
    if ([NSString isNull:mobile]) {
        return NO;
    }
    
    // 判断是否为1开头的11为数字
    NSString *MOBILE = @"^1\\d{10}$";

    //正则判断
    NSPredicate *regextestMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    BOOL result = [regextestMobile evaluateWithObject:mobile];

    return result;
}

/**
 *  判断字符串是否能转为浮点型
 *
 *  @param string 字符串
 *
 *  @return BOOL
 */
+ (BOOL)isPureFloat:(NSString*)string
{
    string = [NSString stringWithFormat:@"%@", string];
    NSScanner *scan = [NSScanner scannerWithString:string];
    double val;
    return[scan scanDouble:&val] && [scan isAtEnd];
}

/**
 *  判断字符串是否能转为整形
 *
 *  @param string 字符串
 *
 *  @return BOOL
 */
+ (BOOL)isPureInt:(NSString*)string
{
    string = [NSString stringWithFormat:@"%@", string];
    NSScanner *scan = [NSScanner scannerWithString:string];
    long long val;
    return[scan scanLongLong:&val] && [scan isAtEnd];
}


@end
