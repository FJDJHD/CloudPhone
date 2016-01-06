//
//  DBOperate.h
//  Shopping
//
//  Created by zhu zhu chao on 11-3-22.
//  Copyright 2011 sal. All rights reserved.
//

#import <Foundation/Foundation.h>
#define	WHOLE_COLUMN 0

//和哪些聊天好友聊天记录表
#define T_chatMessage     @"t_chatMessage"
#define C_T_chatMessage   @"create table t_chatMessage(jidStr TEXT,name TEXT,lastMessage TEXT,time TEXT,unreadMessage TEXT,mineNumber TEXT)"
enum chatMessage {
    message_id,
    message_name,
    message_lastMessage,
    message_time,
    message_unreadMessage,
    message_mineNumber
};

//个人信息表
#define T_personalInfo    @"t_personalInfo"
#define C_T_personalInfo  @"create table t_personalInfo(phoneNum TEXT,name TEXT,iconPath TEXT,sex TEXT,birthday TEXT,signature TEXT)"
enum personalInfo {
    info_phoneNum,
    info_name,
    info_iconPath,
    info_sex,
    info_birthday,
    info_signature
};

//添加自己好友的人
#define T_addFriend      @"t_addFriend"
#define C_T_addFriend    @"create table t_addFriend(jidStr TEXT,isAgree TEXT,isRead TEXT)"
enum addFriend {
    add_jidStr,
    add_isAgree,
    add_isRead
};

//电话记录表
#define T_callRecords     @"t_callRecords"
#define C_T_callRecords   @"create table t_callRecords(callResult TEXT,callerName TEXT,callerAddress TEXT,callTime TEXT)"
enum callRecords {
    record_callResult,
    record_callerName,
    record_callerAddress,
    record_callTime
};


@interface DBOperate : NSObject {
    
}

//创建表
+(BOOL)createTable;

//////插入一整行，array数组元素个数需与该表列数一致  忽略第一个字段id 因为已经设着它为自增
+(BOOL)insertData:(NSArray *)data tableName:(NSString *)aName;

//插入一行不忽略第一个id字段
+(BOOL)insertDataWithnotAutoID:(NSArray *)data tableName:(NSString *)aName;

//俩个条件
+(NSArray *)queryData:(NSString *)aName theColumn:(NSString *)aColumn equalValue:(id)aColumnValue theColumn:(NSString*)bColumn equalValue:(id)bColumnValue;

//俩个条件 一个否条件
+(NSArray *)queryData:(NSString *)aName theColumn:(NSString *)aColumn noEqualValue:(id)aColumnValue theColumn:(NSString*)bColumn equalValue:(id)bColumnValue;

////////查询整个表，或是查询某个条件下的一整行
+(NSArray *)queryData:(NSString *)aName theColumn:(NSString *)aColumn theColumnValue:(NSString *)aColumnValue withAll:(BOOL)yesNO;

//查询整个表 支持一个条件跟排序
+(NSMutableArray *)queryData:(NSString *)aName theColumn:(NSString *)aColumn theColumnValue:(NSString *)aColumnValue orderBy:(NSString *)orderByString orderType:(NSString *)orderTypeString withAll:(BOOL)yesNO;

//查询整个表 支持多个条件跟排序
+(NSMutableArray *)queryData:(NSString *)aName theColumn:(NSString *)aColumn theColumnValue:(NSString *)aColumnValue orderByOne:(NSString *)orderByStringOne orderTypeOne:(NSString *)orderTypeStringOne orderByTwo:(NSString *)orderByStringTwo orderTypeTwo:(NSString *)orderTypeStringTwo withAll:(BOOL)yesNO;
//查询整个表 支持多个条件跟排序2
+(NSMutableArray *)queryData:(NSString *)aName theColumn:(NSString *)aColumn theColumnValue:(NSString *)aColumnValue theColumn:(NSString *)bColumn theColumnValue:(NSString *)bColumnValue orderByOne:(NSString *)orderByStringOne orderTypeOne:(NSString *)orderTypeStringOne orderByTwo:(NSString *)orderByStringTwo orderTypeTwo:(NSString *)orderTypeStringTwo withAll:(BOOL)yesNO;

//////查询某列一个值或是返回一整列的值
+(NSArray *)selectColumn:(NSString *)theColumn 
			   tableName:(NSString *)aTableName 
			   conColumn:(NSString *)aColumn 
		  conColumnValue:(NSString *)aColumnValue 
		 withWholeColumn:(BOOL)yesNO;

////////////删除某个条件下的某一行 如 delete from tableName where colunm=aValue
+(BOOL)deleteData:(NSString *)tableName tableColumn:(NSString *)column columnValue:(id)aValue;

//删除整个表数据
+(BOOL)deleteData:(NSString *)tableName;

//1个条件更新 数据
+(BOOL)updateData:(NSString *)tableName tableColumn:(NSString *)column columnValue:(NSString *)aValue 
  conditionColumn:(NSString *)conColumn conditionColumnValue:(id)conValue;

//2个条件更新 数据
+(BOOL)updateData:(NSString *)tableName tableColumn:(NSString *)column columnValue:(NSString *)aValue 
 conditionColumn1:(NSString *)conColumn1 conditionColumnValue1:(id)conValue1
 conditionColumn2:(NSString *)conColumn2 conditionColumnValue2:(id)conValue2;

///////按正序或倒序查询某表的某列前n条记录
+(NSArray *)selectTopNColumn:(NSString *)theColumn tableName:(NSString *)aTableName rowNum:(NSInteger)n;

///倒序或是正序查询一列
//select theColumn from aTableName where aColumn=aColumnValue order by ID descOrAsc
+(NSArray *)selectColumnWithOrder:(NSString *)theColumn 
						tableName:(NSString *)aTableName 
						conColumn:(NSString *)aColumn 
				   conColumnValue:(NSString *)aColumnValue 
						  orderBy:(NSString *)descOrAsc;


//add by zhanghao
+(NSArray *)getSearchIndex:(NSString *)tableName;

+(NSArray *)getContentForIndex:(NSString *)index InTable:(NSString *)tableName;

+(NSArray *)qureyWithTwoConditions:(NSString *)tabelName 
						 ColumnOne:(NSString *)columnOne 
						  valueOne:(NSString *)valueOne 
						 columnTwo:(NSString *)columnTwo
						  valueTwo:(NSString *)valueTwo;


+(BOOL)updateWithTwoConditions:(NSString *)tabelName 
					 theColumn:(NSString *)Column 
				theColumnValue:(NSString *)aValue 
					 ColumnOne:(NSString *)columnOne 
					  valueOne:(NSString *)valueOne 
					 columnTwo:(NSString *)columnTwo 
					  valueTwo:(NSString *)valueTwo;

+(BOOL)deleteDataWithTwoConditions:(NSString *)tableName 
						 columnOne:(NSString *)columnOne 
						  valueOne:(NSString *)valueOne 
						 columnTwo:(NSString *)columnTwo
						  valueTwo:(NSString *)valueTwo;

+(NSArray *)queryData:(NSString *)aName oneColumn:(NSString *)aColumn equalValue:(id)aColumnValue twoColumn:(NSString*)bColumn equalValue:(id)bColumnValue;

//两个条件 在区间内查找
+(NSArray *)queryData:(NSString *)aName oneColumn:(NSString *)aColumn equalValue:(id)aColumnValue twoColumn:(NSString*)bColumn equalValue:(id)bColumnValue;
+(NSArray *)queryData:(NSString *)aName oneColumn:(NSString *)aColumn equalValue:(id)aColumnValue twoColumn:(NSString*)bColumn equalValue:(id)bColumnValue threeColumn:(NSString *)cColumn equalValue:(id)cColumnValue;
//两个条件 在区间内删除
+(BOOL)deleteDataWithTwoConditions:(NSString *)tableName
						 oneColumn:(NSString *)columnOne
						  oneValue:(NSString *)valueOne
						 twoColumn:(NSString *)columnTwo
						  twoValue:(NSString *)valueTwo;
//三个条件 在区间内删除
+(BOOL)deleteDataWithTwoConditions:(NSString *)tableName
						 oneColumn:(NSString *)columnOne
						  oneValue:(NSString *)valueOne
						 twoColumn:(NSString *)columnTwo
						  twoValue:(NSString *)valueTwo
                       threeColumn:(NSString *)columnThree
                        threeValue:(NSString *)valueThree;
//查询整个表 支持多个条件跟排序1
+(NSArray *)queryData:(NSString *)aName theColumn:(NSString *)aColumn theColumnValue:(NSString *)aColumnValue theColumn:(NSString *)bColumn theColumnValue:(NSString *)bColumnValue orderByOne:(NSString *)orderByStringOne orderTypeOne:(NSString *)orderTypeStringOne withAll:(BOOL)yesNO;

//query 主要用户更新 删除
+(BOOL)querySql:(NSString *)sql;

@end
