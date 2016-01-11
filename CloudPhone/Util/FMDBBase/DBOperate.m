//
//  DBOperate.m
//  Shopping
//
//  Created by zhu zhu chao on 11-3-22.
//  Copyright 2011 sal. All rights reserved.
//

#import "DBOperate.h"
#import "FileManager.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

#define dataBaseFile   @"cloudPhoneFmdb.db"

@implementation DBOperate


//创建表
+(BOOL)createTable{

	NSArray *tableListSql=[NSArray arrayWithObjects:C_T_chatMessage,C_T_personalInfo,C_T_addFriend,C_T_callRecords,C_T_callStatisticRecords,nil];

	NSArray *tableList=[NSArray arrayWithObjects:T_chatMessage,T_personalInfo,T_addFriend,T_callRecords,T_callStatisticRecords,nil];

	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	NSLog(@"dbFilePath:---------------- %@",dbFilePath);
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	if ([db open]) {
		[db setShouldCacheStatements:YES];
		for (int i = 0 ;i <[tableList count];i++) {
			NSString *checkTableSQL = [NSString stringWithFormat:@"SELECT name FROM sqlite_master WHERE type='table' AND name='%@'",[tableList objectAtIndex:i]];
			FMResultSet *rs = [db executeQuery:checkTableSQL];
			if (![rs next]) {
				[db executeUpdate:[tableListSql objectAtIndex:i]];
			}
		}
		
	}
	[db close];
	return YES;
}

//////插入一整行，array数组元素个数需与该表列数一致  忽略第一个字段id 因为已经设着它为自增
+(BOOL)insertData:(NSArray *)data tableName:(NSString *)aName{
	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	NSUInteger columCount=[data count];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	NSString *colum=@",?";
	for (NSInteger i=0; i<columCount-1; i++) {
		colum=[colum stringByAppendingString:@",?"];
	}
	if ([db open]) {
		[db setShouldCacheStatements:YES];
		
		[db beginTransaction];
		
		[db executeUpdate:[NSString stringWithFormat:@"insert into %@ values(NULL%@)",aName,colum] withArgumentsInArray:data];
		
		if ([db hadError]) {
			NSLog(@"Err %d %@",[db lastErrorCode],[db lastErrorMessage]);
			[db rollback];
			return NO;
		}
		[db commit];
		[db close];
		return YES;
	}else {
		NSLog(@"could not open dababase!");
		return NO;
	}
	
}

//插入一行不忽略第一个id字段
+(BOOL)insertDataWithnotAutoID:(NSArray *)data tableName:(NSString *)aName{
	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	NSUInteger columCount=[data count];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	NSString *colum=@"?";
	for (NSInteger i=0; i<columCount-1; i++) {
		colum=[colum stringByAppendingString:@",?"];
	}
	if ([db open]) {
		[db setShouldCacheStatements:YES];
		
		[db beginTransaction];
		
		[db executeUpdate:[NSString stringWithFormat:@"insert into %@ values(%@)",aName,colum] withArgumentsInArray:data];
		
		if ([db hadError]) {
			NSLog(@"Err %d %@",[db lastErrorCode],[db lastErrorMessage]);
			[db rollback];
			[db close];
			return NO;
		}
		
		[db commit];
		[db close];
		return YES;
	}else {
		NSLog(@"could not open dababase!");
		return NO;
	}
	
}

//俩个条件
+(NSArray *)queryData:(NSString *)aName theColumn:(NSString *)aColumn equalValue:(id)aColumnValue theColumn:(NSString*)bColumn equalValue:(id)bColumnValue{
	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	
	if ([db open]){
		[db setShouldCacheStatements:YES];
		NSMutableArray *FinalArray=[NSMutableArray arrayWithCapacity:0];
		FMResultSet *rs=nil;
        
		rs=[db executeQuery:[NSString stringWithFormat:@"select * from %@ where %@=? and %@=?", aName,aColumn,bColumn],aColumnValue,bColumnValue];
		
		int col = sqlite3_column_count(rs.statement.statement); // sqlite3_column_count(rs.statement)
		while ([rs next]) {
			NSMutableArray *rsArray=[NSMutableArray arrayWithCapacity:0];
			for (int i=0; i<col; i++) {
				NSString *temp =[rs stringForColumnIndex:i];
				if (temp == nil) {
					[rsArray addObject:@""];
				}
				else {
					[rsArray addObject:temp];
				}
				
				
			}
			[FinalArray addObject:(NSMutableArray *)rsArray];
			//[rsArray removeAllObjects];
		}
		[rs close];
		[db close];
		return FinalArray;
		
	}else {
		NSLog(@"could not open dababase!");
		return nil;
	}
	
}

//两个条件 在区间内查找
+(NSArray *)queryData:(NSString *)aName oneColumn:(NSString *)aColumn equalValue:(id)aColumnValue twoColumn:(NSString*)bColumn equalValue:(id)bColumnValue {
	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	
	if ([db open]){
		[db setShouldCacheStatements:YES];
		NSMutableArray *FinalArray=[NSMutableArray arrayWithCapacity:0];
		FMResultSet *rs=nil;
        
		rs=[db executeQuery:[NSString stringWithFormat:@"select * from %@ where %@>=? and %@<?", aName,aColumn,bColumn],aColumnValue,bColumnValue];
		
		int col = sqlite3_column_count(rs.statement.statement); // sqlite3_column_count(rs.statement)
		while ([rs next]) {
			NSMutableArray *rsArray=[NSMutableArray arrayWithCapacity:0];
			for (int i=0; i<col; i++) {
				NSString *temp =[rs stringForColumnIndex:i];
				if (temp == nil) {
					[rsArray addObject:@""];
				}
				else {
					[rsArray addObject:temp];
				}
				
				
			}
			[FinalArray addObject:(NSMutableArray *)rsArray];
			//[rsArray removeAllObjects];
		}
		[rs close];
		[db close];
		return FinalArray;
		
	}else {
		NSLog(@"could not open dababase!");
		return nil;
	}
	
}

//三个条件 在区间内查找
+(NSArray *)queryData:(NSString *)aName oneColumn:(NSString *)aColumn equalValue:(id)aColumnValue twoColumn:(NSString*)bColumn equalValue:(id)bColumnValue threeColumn:(NSString *)cColumn equalValue:(id)cColumnValue{
	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	
	if ([db open]){
		[db setShouldCacheStatements:YES];
		NSMutableArray *FinalArray=[NSMutableArray arrayWithCapacity:0];
		FMResultSet *rs=nil;
        
		rs=[db executeQuery:[NSString stringWithFormat:@"select * from %@ where %@>=? and %@<? and %@=?", aName,aColumn,bColumn,cColumn],aColumnValue,bColumnValue,cColumnValue];
		
		int col = sqlite3_column_count(rs.statement.statement); // sqlite3_column_count(rs.statement)
		while ([rs next]) {
			NSMutableArray *rsArray=[NSMutableArray arrayWithCapacity:0];
			for (int i=0; i<col; i++) {
				NSString *temp =[rs stringForColumnIndex:i];
				if (temp == nil) {
					[rsArray addObject:@""];
				}
				else {
					[rsArray addObject:temp];
				}
				
				
			}
			[FinalArray addObject:(NSMutableArray *)rsArray];
			//[rsArray removeAllObjects];
		}
		[rs close];
		[db close];
		return FinalArray;
		
	}else {
		NSLog(@"could not open dababase!");
		return nil;
	}
	
}

//俩个条件 一个否条件
+(NSArray *)queryData:(NSString *)aName theColumn:(NSString *)aColumn noEqualValue:(id)aColumnValue theColumn:(NSString*)bColumn equalValue:(id)bColumnValue{
	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	
	if ([db open]){
		[db setShouldCacheStatements:YES];
		NSMutableArray *FinalArray=[NSMutableArray arrayWithCapacity:0];
		FMResultSet *rs=nil;
        //		if ([aName isEqualToString:T_SEARCH_RECORD]) {
        //			NSString *searchInput = [NSString stringWithFormat:@"%@%%", bColumnValue];
        //			rs=[db executeQuery:[NSString stringWithFormat:@"select * from %@ where %@=? and %@ like ?", aName,aColumn,bColumn],aColumnValue,searchInput];
        //		}else {
        rs=[db executeQuery:[NSString stringWithFormat:@"select * from %@ where %@!=? and %@=?", aName,aColumn,bColumn],aColumnValue,bColumnValue];			
        //		}
        
		
		int col = sqlite3_column_count(rs.statement.statement); // sqlite3_column_count(rs.statement)
		while ([rs next]) {
			NSMutableArray *rsArray=[NSMutableArray arrayWithCapacity:0];
			for (int i=0; i<col; i++) {
				NSString *temp =[rs stringForColumnIndex:i];
				if (temp == nil) {
					[rsArray addObject:@""];
				}
				else {
					[rsArray addObject:temp];
				}
				
				
			}
			[FinalArray addObject:(NSMutableArray *)rsArray];
			//[rsArray removeAllObjects];
		}
		[rs close];
		[db close];
		return FinalArray;
		
	}else {
		NSLog(@"could not open dababase!");
		return nil;
	}
	
}

////////查询整个表，或是查询某个条件下的一整行
////select * from aName
////select * from aName where aColumn=aColumnValue
+(NSArray *)queryData:(NSString *)aName theColumn:(NSString *)aColumn theColumnValue:(NSString *)aColumnValue  withAll:(BOOL)yesNO{
	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	if ([db open]){
		[db setShouldCacheStatements:YES];
		NSMutableArray *FinalArray=[NSMutableArray arrayWithCapacity:0];
		FMResultSet *rs=nil;
		if (yesNO) 
		{
            rs=[db executeQuery:[NSString stringWithFormat:@"select * from %@ ", aName]];
		}
		else
		{
			rs=[db executeQuery:[NSString stringWithFormat:@"select * from %@ where %@=?", aName,aColumn],aColumnValue];
		}
		
		int col = sqlite3_column_count(rs.statement.statement); // sqlite3_column_count(rs.statement)
		while ([rs next]) {
			NSMutableArray *rsArray=[NSMutableArray arrayWithCapacity:0];
			for (int i=0; i<col; i++) {
				NSString *temp =[rs stringForColumnIndex:i];
				if (temp == nil) {
					[rsArray addObject:@""];
				}
				else {
					[rsArray addObject:temp];
				}
				
				
			}
			[FinalArray addObject:(NSMutableArray *)rsArray];
			//[rsArray removeAllObjects];
		}
		[rs close];
		[db close];
		return FinalArray;
		
	}else {
		NSLog(@"could not open dababase!");
		return nil;
	}
	
}

//查询整个表 支持一个条件跟排序
+(NSMutableArray *)queryData:(NSString *)aName theColumn:(NSString *)aColumn theColumnValue:(NSString *)aColumnValue orderBy:(NSString *)orderByString orderType:(NSString *)orderTypeString withAll:(BOOL)yesNO
{
    NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	if ([db open]){
		[db setShouldCacheStatements:YES];
		NSMutableArray *FinalArray=[NSMutableArray arrayWithCapacity:0];
		FMResultSet *rs=nil;
		if (yesNO) 
		{
            rs=[db executeQuery:[NSString stringWithFormat:@"select * from %@ order by %@ %@", aName,orderByString,orderTypeString]];
		}
		else
		{
			rs=[db executeQuery:[NSString stringWithFormat:@"select * from %@ where %@=? order by %@ %@", aName,aColumn,orderByString,orderTypeString],aColumnValue];
		}
		
		int col = sqlite3_column_count(rs.statement.statement); // sqlite3_column_count(rs.statement)
		while ([rs next]) {
			NSMutableArray *rsArray=[NSMutableArray arrayWithCapacity:0];
			for (int i=0; i<col; i++) {
				NSString *temp =[rs stringForColumnIndex:i];
				if (temp == nil) {
					[rsArray addObject:@""];
				}
				else {
					[rsArray addObject:temp];
				}
				
				
			}
			[FinalArray addObject:(NSMutableArray *)rsArray];
			//[rsArray removeAllObjects];
		}
		[rs close];
		[db close];
		return FinalArray;
		
	}else {
		NSLog(@"could not open dababase!");
		return nil;
	}
}

//查询整个表 支持多个条件跟排序
+(NSMutableArray *)queryData:(NSString *)aName theColumn:(NSString *)aColumn theColumnValue:(NSString *)aColumnValue orderByOne:(NSString *)orderByStringOne orderTypeOne:(NSString *)orderTypeStringOne orderByTwo:(NSString *)orderByStringTwo orderTypeTwo:(NSString *)orderTypeStringTwo withAll:(BOOL)yesNO
{
    NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	if ([db open]){
		[db setShouldCacheStatements:YES];
		NSMutableArray *FinalArray=[NSMutableArray arrayWithCapacity:0];
		FMResultSet *rs=nil;
		if (yesNO) 
		{
            rs=[db executeQuery:[NSString stringWithFormat:@"select * from %@ order by %@ %@,%@ %@", aName,orderByStringOne,orderTypeStringOne,orderByStringTwo,orderTypeStringTwo]];
		}
		else
		{
			rs=[db executeQuery:[NSString stringWithFormat:@"select * from %@ where %@=? order by %@ %@,%@ %@", aName,aColumn,orderByStringOne,orderTypeStringOne,orderByStringTwo,orderTypeStringTwo],aColumnValue];
		}
		
		int col = sqlite3_column_count(rs.statement.statement); // sqlite3_column_count(rs.statement)
		while ([rs next]) {
			NSMutableArray *rsArray=[NSMutableArray arrayWithCapacity:0];
			for (int i=0; i<col; i++) {
				NSString *temp =[rs stringForColumnIndex:i];
				if (temp == nil) {
					[rsArray addObject:@""];
				}
				else {
					[rsArray addObject:temp];
				}
				
				
			}
			[FinalArray addObject:(NSMutableArray *)rsArray];
			//[rsArray removeAllObjects];
		}
		[rs close];
		[db close];
		return FinalArray;
		
	}else {
		NSLog(@"could not open dababase!");
		return nil;
	}
}

//查询整个表 支持多个条件跟排序1
+(NSArray *)queryData:(NSString *)aName theColumn:(NSString *)aColumn theColumnValue:(NSString *)aColumnValue theColumn:(NSString *)bColumn theColumnValue:(NSString *)bColumnValue orderByOne:(NSString *)orderByStringOne orderTypeOne:(NSString *)orderTypeStringOne withAll:(BOOL)yesNO
{
    NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	if ([db open]){
		[db setShouldCacheStatements:YES];
		NSMutableArray *FinalArray=[NSMutableArray arrayWithCapacity:0];
		FMResultSet *rs=nil;
		if (yesNO)
		{
            rs=[db executeQuery:[NSString stringWithFormat:@"select * from %@ order by %@ %@", aName,orderByStringOne,orderTypeStringOne]];
		}
		else
		{
			rs=[db executeQuery:[NSString stringWithFormat:@"select * from %@ where %@=? and %@=? order by %@ %@", aName,aColumn,bColumn,orderByStringOne,orderTypeStringOne],aColumnValue,bColumnValue];
		}
		
		int col = sqlite3_column_count(rs.statement.statement); // sqlite3_column_count(rs.statement)
		while ([rs next]) {
			NSMutableArray *rsArray=[NSMutableArray arrayWithCapacity:0];
			for (int i=0; i<col; i++) {
				NSString *temp =[rs stringForColumnIndex:i];
				if (temp == nil) {
					[rsArray addObject:@""];
				}
				else {
					[rsArray addObject:temp];
				}
				
				
			}
			[FinalArray addObject:(NSMutableArray *)rsArray];
			//[rsArray removeAllObjects];
		}
		[rs close];
		[db close];
		return FinalArray;
		
	}else {
		NSLog(@"could not open dababase!");
		return nil;
	}
}

//查询整个表 支持多个条件跟排序2
+(NSMutableArray *)queryData:(NSString *)aName theColumn:(NSString *)aColumn theColumnValue:(NSString *)aColumnValue theColumn:(NSString *)bColumn theColumnValue:(NSString *)bColumnValue orderByOne:(NSString *)orderByStringOne orderTypeOne:(NSString *)orderTypeStringOne orderByTwo:(NSString *)orderByStringTwo orderTypeTwo:(NSString *)orderTypeStringTwo withAll:(BOOL)yesNO
{
    NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	if ([db open]){
		[db setShouldCacheStatements:YES];
		NSMutableArray *FinalArray=[NSMutableArray arrayWithCapacity:0];
		FMResultSet *rs=nil;
		if (yesNO) 
		{
            rs=[db executeQuery:[NSString stringWithFormat:@"select * from %@ order by %@ %@,%@ %@", aName,orderByStringOne,orderTypeStringOne,orderByStringTwo,orderTypeStringTwo]];
		}
		else
		{
			rs=[db executeQuery:[NSString stringWithFormat:@"select * from %@ where %@=? and %@=? order by %@ %@,%@ %@", aName,aColumn,bColumn,orderByStringOne,orderTypeStringOne,orderByStringTwo,orderTypeStringTwo],aColumnValue,bColumnValue];
		}
		
		int col = sqlite3_column_count(rs.statement.statement); // sqlite3_column_count(rs.statement)
		while ([rs next]) {
			NSMutableArray *rsArray=[NSMutableArray arrayWithCapacity:0];
			for (int i=0; i<col; i++) {
				NSString *temp =[rs stringForColumnIndex:i];
				if (temp == nil) {
					[rsArray addObject:@""];
				}
				else {
					[rsArray addObject:temp];
				}
				
				
			}
			[FinalArray addObject:(NSMutableArray *)rsArray];
			//[rsArray removeAllObjects];
		}
		[rs close];
		[db close];
		return FinalArray;
		
	}else {
		NSLog(@"could not open dababase!");
		return nil;
	}
}

//////查询某列一个值或是返回一整列的值
//select theColumn from aTableName where aColumn＝aColumnValue
//select theColumn from aTableName
+(NSArray *)selectColumn:(NSString *)theColumn 
			   tableName:(NSString *)aTableName 
			   conColumn:(NSString *)aColumn 
		  conColumnValue:(NSString *)aColumnValue 
		 withWholeColumn:(BOOL)yesNO
{
	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	
	if ([db open]){
		[db setShouldCacheStatements:YES];
		FMResultSet *rs=nil;
		if (yesNO) {
			rs=[db executeQuery:[NSString stringWithFormat:@"select %@ from %@ ",theColumn, aTableName]];
		}else {
			rs=[db executeQuery:[NSString stringWithFormat:@"select %@ from %@ where %@=?", theColumn,aTableName,aColumn],aColumnValue];
		}
		NSMutableArray *rsArray=[NSMutableArray arrayWithCapacity:0];		
		while ([rs next]) {
			NSString *temp =[rs stringForColumn:theColumn];
			[rsArray addObject:temp];
		}
		[rs close];
		[db close];
		return rsArray;
		
	}else {
		NSLog(@"could not open dababase!");
		return nil;
	}
}

////////////删除某个条件下的某一行 如 delete from tableName where colunm=aValue
+(BOOL)deleteData:(NSString *)tableName tableColumn:(NSString *)column columnValue:(id)aValue{
	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	
	if ([db open]) {
		[db setShouldCacheStatements:YES];		
		[db beginTransaction];
		[db executeUpdate:[NSString stringWithFormat:@"delete from %@ where %@=?",tableName,column],aValue];		
		if ([db hadError]) {
			NSLog(@"Err %d %@",[db lastErrorCode],[db lastErrorMessage]);
			[db rollback];
			return NO;
		}
		[db commit];
		[db close];
		return YES;
	}else {
		NSLog(@"could not open dababase!");
		return NO;
	}
}

//删除整个表数据
+(BOOL)deleteData:(NSString *)tableName {
	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	
	if ([db open]) {
		[db setShouldCacheStatements:YES];		
		[db beginTransaction];
		[db executeUpdate:[NSString stringWithFormat:@"delete from %@ ",tableName]];		
		if ([db hadError]) {
			NSLog(@"Err %d %@",[db lastErrorCode],[db lastErrorMessage]);
			[db rollback];
			return NO;
		}
		[db commit];
		[db close];
		return YES;
	}else {
		NSLog(@"could not open dababase!");
		return NO;
	}
}

//1个条件更新 数据
+(BOOL)updateData:(NSString *)tableName tableColumn:(NSString *)column columnValue:(NSString *)aValue 
  conditionColumn:(NSString *)conColumn conditionColumnValue:(id)conValue
{
	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	
	if ([db open]) {
		[db setShouldCacheStatements:YES];		
		[db beginTransaction];
		[db executeUpdate:[NSString stringWithFormat:@"update %@ set %@=? where %@=?",tableName,column,conColumn],aValue,conValue];
		if ([db hadError]) {
			NSLog(@"Err %d %@",[db lastErrorCode],[db lastErrorMessage]);
			[db rollback];
			return NO;
		}
		[db commit];
		[db close];
		return YES;
	}else {
		NSLog(@"could not open dababase!");
		return NO;
	}
}

//2个条件更新 数据
+(BOOL)updateData:(NSString *)tableName tableColumn:(NSString *)column columnValue:(NSString *)aValue 
 conditionColumn1:(NSString *)conColumn1 conditionColumnValue1:(id)conValue1
 conditionColumn2:(NSString *)conColumn2 conditionColumnValue2:(id)conValue2
{
	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	
	if ([db open]) {
		[db setShouldCacheStatements:YES];		
		[db beginTransaction];
		//	NSLog([NSString stringWithFormat:@"update %@ set %@=%@ where %@=%@",tableName,column,aValue,conColumn,conValue]);
		//	[db executeUpdate:@"update ? set ?=? where ?=?",tableName,column,aValue,conColumn,conValue];
		//NSLog(@"sql %@",[NSString stringWithFormat:@"update %@ set %@=? where %@=?",tableName,column,conColumn]);
		[db executeUpdate:[NSString stringWithFormat:@"update %@ set %@=? where %@=? and %@=?",tableName,column,conColumn1,conColumn2],aValue,conValue1,conValue2];
		if ([db hadError]) {
			NSLog(@"Err %d %@",[db lastErrorCode],[db lastErrorMessage]);
			[db rollback];
			return NO;
		}
		[db commit];
		[db close];
		return YES;
	}else {
		NSLog(@"could not open dababase!");
		return NO;
	}
}

///////按正序或倒序查询某表的某列前n条记录
+(NSArray *)selectTopNColumn:(NSString *)theColumn tableName:(NSString *)aTableName rowNum:(NSInteger)n 
{
	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	
	if ([db open]){
		[db setShouldCacheStatements:YES];
		FMResultSet *rs=nil;
		if (n==WHOLE_COLUMN) {
			rs=[db executeQuery:[NSString stringWithFormat:@"select %@ from %@ ORDER BY id DESC  ",theColumn, aTableName]];
		}else {
			NSLog(@"%@",[NSString stringWithFormat:@"select %@ from %@ ORDER BY id DESC limit 0,%d ",theColumn, aTableName,(int)n]);
			rs=[db executeQuery:[NSString stringWithFormat:@"select %@ from %@ ORDER BY id DESC limit 0,%d ",theColumn, aTableName,(int)n]];
		}
		NSMutableArray *rsArray=[NSMutableArray arrayWithCapacity:0];		
		while ([rs next]) {
			NSString *temp =[rs stringForColumn:theColumn];
			[rsArray addObject:temp];
		}
		[rs close];
		[db close];
		return rsArray;
		
	}else {
		NSLog(@"could not open dababase!");
		return nil;
	}
	
}
///倒序或是正序查询一列
//select theColumn from aTableName where aColumn=aColumnValue order by ID descOrAsc
+(NSArray *)selectColumnWithOrder:(NSString *)theColumn 
						tableName:(NSString *)aTableName 
						conColumn:(NSString *)aColumn 
				   conColumnValue:(NSString *)aColumnValue 
						  orderBy:(NSString *)descOrAsc
{
	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	
	if ([db open]){
		[db setShouldCacheStatements:YES];
		FMResultSet *rs=[db executeQuery:[NSString stringWithFormat:@"select %@ from %@ where %@ = '%@' order by ID %@",theColumn, aTableName,aColumn,aColumnValue,descOrAsc]];
		NSMutableArray *rsArray=[NSMutableArray arrayWithCapacity:0];		
		while ([rs next]) {
			NSString *temp =[rs stringForColumn:theColumn];
			[rsArray addObject:temp];
		}
		[rs close];
		[db close];
		return rsArray;
		
	}else {
		NSLog(@"could not open dababase!");
		return nil;
	}
}



//add by zhanghao
+(NSArray *)getSearchIndex:(NSString *)tableName
{
	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];	
	if ([db open]){
		[db setShouldCacheStatements:YES];
		NSString *string;
		NSMutableArray *rsArray=[NSMutableArray arrayWithCapacity:0];
		FMResultSet *rs=nil;
		rs=[db executeQuery:[NSString stringWithFormat:@"select distinct(searchIndex) from %@",tableName]];
		while ([rs next]) {			
			string=[rs stringForColumnIndex:0];
			[rsArray addObject:string];
		}
		[rs close];
		[db close];
		return rsArray;
		
	}else {
		NSLog(@"could not open dababase!");
		return nil;
	}
	
}
+(NSArray *)getContentForIndex:(NSString *)index InTable:(NSString *)tableName{
	
	return [self queryData:tableName theColumn:@"searchIndex" theColumnValue:index withAll:NO];
}

+(NSArray *)qureyWithTwoConditions:(NSString *)tabelName 
						 ColumnOne:(NSString *)columnOne 
						  valueOne:(NSString *)valueOne 
						 columnTwo:(NSString *)columnTwo
						  valueTwo:(NSString *)valueTwo
{
	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	
	if ([db open]){
		[db setShouldCacheStatements:YES];
		NSMutableArray *FinalArray=[NSMutableArray arrayWithCapacity:0];
		FMResultSet *rs=nil;
		rs=[db executeQuery:[NSString stringWithFormat:@"select * from %@ where %@=? and %@=?", tabelName,columnOne,columnTwo],valueOne,valueTwo];
		int col = sqlite3_column_count(rs.statement.statement); // sqlite3_column_count(rs.statement)
		while ([rs next]) {
			NSMutableArray *rsArray=[NSMutableArray arrayWithCapacity:0];
			for (int i=0; i<col; i++) {
				NSString *temp =[rs stringForColumnIndex:i];
				[rsArray addObject:temp];
			}
			[FinalArray addObject:(NSMutableArray *)rsArray];
		}
		[rs close];
		[db close];
		return FinalArray;
	}else {
		NSLog(@"could not open dababase!");
		return nil;
	}
	
	
	
	
}


+(BOOL)updateWithTwoConditions:(NSString *)tabelName 
					 theColumn:(NSString *)Column 
				theColumnValue:(NSString *)aValue 
					 ColumnOne:(NSString *)columnOne 
					  valueOne:(NSString *)valueOne 
					 columnTwo:(NSString *)columnTwo 
					  valueTwo:(NSString *)valueTwo
{
	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	
	if ([db open]) {
		[db setShouldCacheStatements:YES];		
		[db beginTransaction];	
		[db executeUpdate:[NSString stringWithFormat:@"update %@ set %@=? where %@=? and %@=?",tabelName,Column,columnOne,columnTwo],aValue,valueOne,valueTwo];
		if ([db hadError]) {
			NSLog(@"Err %d %@",[db lastErrorCode],[db lastErrorMessage]);
			[db rollback];
			return NO;
		}
		[db commit];
		[db close];
		return YES;
	}else {
		NSLog(@"could not open dababase!");
		return NO;
	}
	
	
}



+(BOOL)deleteDataWithTwoConditions:(NSString *)tableName 
						 columnOne:(NSString *)columnOne 
						  valueOne:(NSString *)valueOne 
						 columnTwo:(NSString *)columnTwo
						  valueTwo:(NSString *)valueTwo
{
	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	
	if ([db open]) {
		[db setShouldCacheStatements:YES];		
		[db beginTransaction];
		[db executeUpdate:[NSString stringWithFormat:@"delete from %@ where %@=? and %@=?",tableName,columnOne,columnTwo],valueOne,valueTwo];		
		if ([db hadError]) {
			NSLog(@"Err %d %@",[db lastErrorCode],[db lastErrorMessage]);
			[db rollback];
			return NO;
		}
		[db commit];
		[db close];
		return YES;
	}else {
		NSLog(@"could not open dababase!");
		return NO;
	}
	
}

//两个条件 在区间内删除
+(BOOL)deleteDataWithTwoConditions:(NSString *)tableName
						 oneColumn:(NSString *)columnOne
						  oneValue:(NSString *)valueOne
						 twoColumn:(NSString *)columnTwo
						  twoValue:(NSString *)valueTwo
{
	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	
	if ([db open]) {
		[db setShouldCacheStatements:YES];
		[db beginTransaction];
		[db executeUpdate:[NSString stringWithFormat:@"delete from %@ where %@>=? and %@<?",tableName,columnOne,columnTwo],valueOne,valueTwo];
		if ([db hadError]) {
			NSLog(@"Err %d %@",[db lastErrorCode],[db lastErrorMessage]);
			[db rollback];
			return NO;
		}
		[db commit];
		[db close];
		return YES;
	}else {
		NSLog(@"could not open dababase!");
		return NO;
	}
	
}

//三个条件 在区间内删除
+(BOOL)deleteDataWithTwoConditions:(NSString *)tableName
						 oneColumn:(NSString *)columnOne
						  oneValue:(NSString *)valueOne
						 twoColumn:(NSString *)columnTwo
						  twoValue:(NSString *)valueTwo
                         threeColumn:(NSString *)columnThree
						  threeValue:(NSString *)valueThree
{
	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	
	if ([db open]) {
		[db setShouldCacheStatements:YES];
		[db beginTransaction];
		[db executeUpdate:[NSString stringWithFormat:@"delete from %@ where %@>=? and %@<? and %@=?",tableName,columnOne,columnTwo,columnThree],valueOne,valueTwo,valueThree];
		if ([db hadError]) {
			NSLog(@"Err %d %@",[db lastErrorCode],[db lastErrorMessage]);
			[db rollback];
			return NO;
		}
		[db commit];
		[db close];
		return YES;
	}else {
		NSLog(@"could not open dababase!");
		return NO;
	}
	
}

//query 主要用户更新 删除
+(BOOL)querySql:(NSString *)sql
{
	NSString *dbFilePath=[FileManager getFilePath:dataBaseFile];
	FMDatabase *db=[FMDatabase databaseWithPath:dbFilePath];
	if ([db open])
    {
		[db setShouldCacheStatements:YES];
		[db beginTransaction];
		[db executeUpdate:sql];
		if ([db hadError])
        {
			NSLog(@"Err %d %@",[db lastErrorCode],[db lastErrorMessage]);
			[db rollback];
			return NO;
		}
		[db commit];
		[db close];
		return YES;
	}
    else
    {
		NSLog(@"could not open dababase!");
		return NO;
	}
}

@end
