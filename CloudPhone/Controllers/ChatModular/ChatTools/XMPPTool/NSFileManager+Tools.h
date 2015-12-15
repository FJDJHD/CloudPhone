#import <Foundation/Foundation.h>

@interface NSFileManager(Tools)

// 在缓存目录创建指定名称的文件夹
// 提示：如果文件夹不存在，往文件夹中写入文件，没有提示，不会报错，也没有写入
+ (NSString *)createDirInCachePathWithName:(NSString *)name;


/**
 *	@brief	文档目录
 *
 *	@return	返回文档的路径
 */
- (NSString *)applicationDocumentsDirectory;

/**
 *	@brief	库目录
 *
 *	@return	返回库路径
 */
- (NSString *)applicationLibraryDirectory;

/**
 *	@brief	音乐目录
 *
 *	@return	返回音乐目录
 */
- (NSString *)applicationMusicDirectory;

/**
 *	@brief	视频目录
 *
 *	@return	返回视频路径
 */
- (NSString *)applicationMoviesDirectory;

/**
 *	@brief	图片路径
 *
 *	@return	返回图片
 */
- (NSString *)applicationPicturesDirectory;

/**
 *	@brief	临时目录
 *
 *	@return	返回临时目录
 */
- (NSString *)applicationTemporaryDirectory;

/**
 *	@brief	缓存目录
 *
 *	@return	返回缓存
 */
- (NSString *)applicationCachesDirectory;

@end
