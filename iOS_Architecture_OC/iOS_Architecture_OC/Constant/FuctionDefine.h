//
//  FuctionDefine.h
//  iOS_Architecture_OC
//
//  Created by MountainX on 2018/7/4.
//  Copyright © 2018年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - NSIndexPath
#undef XIndexPath
#define XIndexPath(section, row) ([NSIndexPath indexPathForRow:row inSection:section])

#pragma mark - Image
#undef XImageNamed
#define XImageNamed(imageName) [UIImage imageNamed:imageName]

#pragma mark - NSUserDefaults
#undef USER_DEFAULT
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

#pragma mark - LOG
#ifdef DEBUG
/*
 __PRETTY_FUNCTION__  非标准宏。这个宏比__FUNCTION__功能更强,  若用g++编译C++程序, __FUNCTION__只能输出类的成员名,不会输出类名;而__PRETTY_FUNCTION__则会以 <return-type>  <class-name>::<member-function-name>(<parameters-list>) 的格式输出成员函数的详悉信息(注: 只会输出parameters-list的形参类型, 而不会输出形参名).若用gcc编译C程序,__PRETTY_FUNCTION__跟__FUNCTION__的功能相同.
 
 __LINE__ 宏在预编译时会替换成当前的行号
 
 __VA_ARGS__ 是一个可变参数的宏，很少人知道这个宏，这个可变参数的宏是新的C99规范中新增的，目前似乎只有gcc支持（VC6.0的编译器不支持）。宏前面加上##的作用在于，当可变参数的个数为0时，这里的##起到把前面多余的","去掉的作用,否则会编译出错
 */
//#define DLOG(...) NSLog(__VA_ARGS__);
#define DLOG(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define DLOG_METHOD NSLog(@"%s",__func__);
#define DERROR(fmt,...) NSLog((@"error:%s %d " fmt),__FUNCTION__,__LINE__,##__VA_ARGS__);
#else

#define DLOG(...) ;
#define DLOG_METHOD ;
#define DERROR(fmt,...) ;
#endif

#pragma mark - Assert
#define XAssert(expression, ...) \
do { if(!(expression)) { \
DLOG(@"%@", \
[NSString stringWithFormat: @"Assertion failure: %s in %s on line %s:%d. %@",\
#expression, \
__PRETTY_FUNCTION__, \
__FILE__, __LINE__,  \
[NSString stringWithFormat:@"" __VA_ARGS__]]); \
abort(); } \
} while(0)

#pragma mark - Weak Strong
// weakSelf 宏定义
#undef WS
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#undef SS
#define SS(strongSelf)  __strong __typeof(&*self)strongSelf = weakSelf;

#undef WeakObj
#define WeakObj(o) __weak typeof(o) o##Weak = o;

#pragma mark - Deprecated 方法禁用提示

#undef XDeprecated
#define XDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

#pragma mark - nil or NULL 空判断

//是否为空或是[NSNull null]
#define NotNilAndNull(_ref)  (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]))
#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

//字符串是否为空
#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))

//数组是否为空
#define IsArrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))


#pragma mark - Extern and Inline functions 内联函数&外联函数
/*／EXTERN 外联函数*/
#if !defined(X_EXTERN)
#  if defined(__cplusplus)
#   define X_EXTERN extern "C"
#  else
#   define X_EXTERN extern
#  endif
#endif

/*INLINE 内联函数*/
#if !defined(X_INLINE)
# if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 199901L
#  define X_INLINE static inline
# elif defined(__cplusplus)
#  define X_INLINE static inline
# elif defined(__GNUC__)
#  define X_INLINE static __inline__
# else
#  define X_INLINE static
# endif
#endif


#pragma mark - Decode
// NSDictionary -> NSString
X_EXTERN NSString* DecodeObjectFromDic(NSDictionary *dic, NSString *key);
// NSArray + index -> id
X_EXTERN id        DecodeSafeObjectAtIndex(NSArray *arr, NSInteger index);
// NSDictionary -> NSString
X_EXTERN NSString     * DecodeStringFromDic(NSDictionary *dic, NSString *key);
// NSDictionary -> NSString ？ NSString ： defaultStr
X_EXTERN NSString* DecodeDefaultStrFromDic(NSDictionary *dic, NSString *key,NSString * defaultStr);
// NSDictionary -> NSNumber
X_EXTERN NSNumber     * DecodeNumberFromDic(NSDictionary *dic, NSString *key);
// NSDictionary -> NSDictionary
X_EXTERN NSDictionary *DecodeDicFromDic(NSDictionary *dic, NSString *key);
// NSDictionary -> NSArray
X_EXTERN NSArray      *DecodeArrayFromDic(NSDictionary *dic, NSString *key);
X_EXTERN NSArray      *DecodeArrayFromDicUsingParseBlock(NSDictionary *dic, NSString *key, id(^parseBlock)(NSDictionary *innerDic));

#pragma mark - Encode
// (nonull Key: nonull NSString) -> NSMutableDictionary
X_EXTERN void EncodeUnEmptyStrObjctToDic(NSMutableDictionary *dic,NSString *object, NSString *key);
// nonull objec -> NSMutableArray
X_EXTERN void EncodeUnEmptyObjctToArray(NSMutableArray *arr,id object);
// (nonull (Key ? key : defaultStr) : nonull Value) -> NSMutableDictionary
X_EXTERN void EncodeDefaultStrObjctToDic(NSMutableDictionary *dic,NSString *object, NSString *key,NSString * defaultStr);
// (nonull Key: nonull object) -> NSMutableDictionary
X_EXTERN void EncodeUnEmptyObjctToDic(NSMutableDictionary *dic,NSObject *object, NSString *key);
