//
//  USStoreEntity.h
//  MRQFrame
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 marenqing. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface USStoreEntity : NSManagedObject

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSData * value;
@property (nonatomic, retain) NSDate * create_at;
@property (nonatomic, retain) NSDate * update_at;
@property (nonatomic, retain) NSNumber * is_valid;
@property (nonatomic, retain) NSNumber * overdue_time;

// 获取缓存值，过期后同样只返回nil
+ (NSData*)valueWithKey:(NSString*)key;

// 设置缓存,重复的key会覆盖
+ (USStoreEntity*)setValue:(NSData*)value withKey:(NSString*)key;
// overdueTime:秒,0相当于没设置
+ (USStoreEntity*)setValue:(NSData*)value withKey:(NSString*)key andOverdueTime:(double)overdueTime;

// 模糊删除缓存
+ (void)deleteStoreKeyLike:(NSString*)likeString;

// 模糊获取缓存大小
+(float)storeSizeKeyLike:(NSString*)likeString;

@end
