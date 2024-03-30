//
//  RegexConst.m
//  Gamfun
//
//  Created by mac on 2022/6/2.
//

// 用户名正则表达式
NSString * const kUserNameRegexp = @"^[0-9a-zA-Z-_]{4,20}$";
// 用户名单字符正则表达式
NSString * const kUserNameSingleCharacterRegexp = @"^[0-9a-zA-Z-_]+$";
// 密码正则表达式
NSString * const kPasswordRegexp = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,15}$";
// 密码正则表达式
NSString * const kPwdRegexp = @"^(?=.*[a-zA-Z0-9].*)(?=.*[a-zA-Z\\W].*)(?=.*[0-9\\W].*).{6,36}$";
// 密码单字符正则表达式
NSString * const kPasswordSingleCharacterRegexp = @"^[0-9A-Za-z]?$";
// 手机号正则表达式
NSString * const kPhoneRegexp = @"^\\d{11}$";
// 手机号单字符正则表达式
NSString * const kPhoneSingleCharacterRegexp = @"^\\d?$";
// Emoji表情正则表达式
NSString * const kEmojiRegexp = @"^[\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]$";
// 数字正则表达式
NSString * const kNumberRegexp = @"^[0-9]+$";
// 含两位小数的数字正则表达式
NSString * const kTwoDecimalNumberRegexp = @"^([0-9]{1,5})|([0-9]{1,5}\\.{1}[0-9]{0,2})$";
// 中英文、括号()、横线-、下划线_、冒号：、点.、空格正则表达式
NSString * const kRegularRegexp = @"^[a-zA-Z0-9\\u4e00-\\u9fa5-_:\\.()\\s]+$";
// 小数单字符正则表达式
NSString * const kDecimalNumSingleRegexp = @"^[0-9\\.]$";
// 小数正则表达式
NSString * const kDecimalNumRegexp = @"^[0-9]+\\.?[0-9]{0,2}$";

// 字母数字正则表达式
NSString * const kLetterNumberRegexp = @"^[0-9A-Za-z]$";

// 非中文正则表达式
NSString * const kNoChineseRegexp = @"^[^\\u4e00-\\u9fa5]+$";

