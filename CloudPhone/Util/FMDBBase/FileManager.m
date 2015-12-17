//
//  FileManager.m
//  anyVideo
//
//  Created by  apple on 10-10-27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

+ (BOOL)isExistsFile:(NSString *)filepath{
	NSFileManager *filemanage = [NSFileManager defaultManager];
	return [filemanage fileExistsAtPath:filepath];
}

+ (void) removeFile:(NSString *)filename {
	NSFileManager *filemanage = [NSFileManager defaultManager];
	NSError *error;
	if (filename.length > 4) {
	
		if ([self isExistsFile:[self getFilePath:filename]]) {
			if ([filemanage removeItemAtPath:[self getFilePath:filename] error:&error] != YES)
			{
				NSLog(@"Unable to delete file: %@", [error localizedDescription]);
				return;
			}
		}
	}
}

+ (NSString *)getFilePath:(NSString *)filename{
    
    NSArray *paths = [[NSArray alloc] initWithArray:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)];
    NSString *documentsDirectory = [[NSString alloc] initWithString:[paths objectAtIndex:0]];
    NSString *filepath = [documentsDirectory stringByAppendingPathComponent:filename];
    return filepath;
    
//    //去除 / 这个符号 （base64_encode转出来的有时会带有/ 导致保存错误，这是临时解决方法）
//    NSArray *fileNameArray = [filename componentsSeparatedByString:@"/"];
//    NSString *fileNameString = [fileNameArray componentsJoinedByString:@""];
//    
//	NSArray *paths = [[NSArray alloc] initWithArray:NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)];
//	NSString *documentsDirectory = [[NSString alloc] initWithString:[paths objectAtIndex:0]];
//	NSString *filepath = [documentsDirectory stringByAppendingPathComponent:fileNameString];
//	return filepath;
}

//+ (BOOL) writeFileString:(NSString *)string fileName:(NSString *)filename{
//	[string writeToFile: [self getFilePath:filename] atomically: YES];
//	return YES;
//}


+ (void) createFile:(NSString *) filename {
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取路径
    //参数NSDocumentDirectory要获取那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    
    //更改到待操作的目录下
    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
	
    //创建文件fileName文件名称，contents文件的内容，如果开始没有内容可以设置为nil，attributes文件的属性，初始为nil
    [fileManager createFileAtPath:filename contents:nil attributes:nil];
	
}

+ (void) writeFileData:(NSString *)filename writeData:(NSString *)data {
	//写入数据：
	//获取文件路径
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
//	NSString *path = [documentsDirectory stringByAppendingPathComponent:filename];
    
    NSArray *paths = [[NSArray alloc] initWithArray:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)];
    NSString *documentsDirectory = [[NSString alloc] initWithString:[paths objectAtIndex:0]];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:filename];
    
    //待写入的数据
    NSString *temp = @"Hello friend";
    int data0 = 100000;
    float data1 = 23.45f;
    
    //创建数据缓冲
    NSMutableData *writer = [[NSMutableData alloc] init];
    
    //将字符串添加到缓冲中
    [writer appendData:[temp dataUsingEncoding:NSUTF8StringEncoding]];
	
    //将其他数据添加到缓冲中
    [writer appendBytes:&data0 length:sizeof(data0)];
    [writer appendBytes:&data1 length:sizeof(data1)];
	
    //将缓冲的数据写入到文件中
    [writer writeToFile:path atomically:YES];
}

+ (NSString *) readResFileData:(NSString *)filename {
	NSString *filepath = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
	NSString *string = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
	return string;
}

+ (NSString *) readLocalFileData:(NSString *)filename {
	//读取数据：
    int gData0;
    float gData1;
    NSString *gData2;
    NSString *temp;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
	NSString *path = [documentsDirectory stringByAppendingPathComponent:filename];
    NSData *reader = [NSData dataWithContentsOfFile:path];
    gData2 = [[NSString alloc] initWithData:[reader subdataWithRange:NSMakeRange(0, [temp length])]
								   encoding:NSUTF8StringEncoding];
    [reader getBytes:&gData0 range:NSMakeRange([temp length], sizeof(gData0))];
    [reader getBytes:&gData2 range:NSMakeRange([temp length] + sizeof(gData0), sizeof(gData1))];
    
    //NSLog(@"gData0:%@  gData1:%i gData2:%f", gData0, gData1, gData2);
	
	return gData2;//changed by zhanghao
}	

//==========
/*+ (NSString *)getDBFilePath{
	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory=[paths objectAtIndex:0];
	NSString *writableDBPath=[documentsDirectory stringByAppendingPathComponent:@"ShoppingDB.db"];
	return writableDBPath;
}*/

@end
