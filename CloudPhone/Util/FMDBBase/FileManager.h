//
//  FileManager.h
//  anyVideo
//
//  Created by  apple on 10-10-27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FileManager : NSObject {
	
}

//+ (BOOL) writeFileString:(NSString *)string fileName:(NSString *)filename;
+ (BOOL) isExistsFile:(NSString *) filepath;
+ (void) createFile:(NSString *) filename;
+ (void) writeFileData:(NSString *)filename writeData:(NSString *)data;
+ (void) removeFile:(NSString *)filename;

+ (NSString *)getFilePath:(NSString *)filename;
+ (NSString *) readResFileData:(NSString *)filename;
+ (NSString *) readLocalFileData:(NSString *)filename;


@end
