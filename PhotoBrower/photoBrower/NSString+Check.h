//
//  NSString+Check.h
//
//

#import <Foundation/Foundation.h>

@interface NSString (Check)

/**
 *  判断字符串是否为空
 *
 *  @param str 字符串
 *
 *  @return BOOL
 */
+ (BOOL)isNull:(NSString *)str;


/**
 *  判断是否为手机号
 *
 *  @param mobile 手机号
 *
 *  @return BOOL
 */
+ (BOOL)isMobileNumber:(NSString *)mobile;


/**
 *  判断字符串是否能转为浮点型
 *
 *  @param string 字符串
 *
 *  @return BOOL
 */
+ (BOOL)isPureFloat:(NSString*)string;


/**
 *  判断字符串是否能转为整形
 *
 *  @param string 字符串
 *
 *  @return BOOL
 */
+ (BOOL)isPureInt:(NSString*)string;


@end
