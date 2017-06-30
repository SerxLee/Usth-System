//
//  USStoreEntity.m
//  MRQFrame
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 marenqing. All rights reserved.
//

#import "USStoreEntity.h"
#import "AppDelegate.h"

#define DEFAULT_OVERDUE_TIME 60*60*2
NSString* const NBCacheEntityErrorDomain = @"USStoreEntityDomain";

@implementation USStoreEntity

@dynamic key;
@dynamic value;
@dynamic create_at;
@dynamic update_at;
@dynamic is_valid;
@dynamic overdue_time;

#pragma mark - Methods
+ (BOOL) isBlankString:(NSString *)string{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

+ (USStoreEntity*)setValue:(NSData*)value withKey:(NSString*)key andOverdueTime:(double)overdueTime{
    NSAssert(![USStoreEntity isBlankString: key],@"输入的key不能为空");
    if([USStoreEntity isBlankString: key]){
        return nil;
    }

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    AppDelegate *myAppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSEntityDescription* storeEntity=[NSEntityDescription entityForName:@"StoreEntity" inManagedObjectContext:myAppDelegate.managedObjectContext];
    [request setEntity:storeEntity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key=%@",key];
    [request setPredicate:predicate];
    
    NSMutableArray* mutableFetchResult=[[myAppDelegate.managedObjectContext executeFetchRequest:request error:nil] mutableCopy];
    
    if (([mutableFetchResult count] == 0)||(mutableFetchResult == nil)) {
        //数据得插入
        USStoreEntity* storeData = (USStoreEntity*)[NSEntityDescription insertNewObjectForEntityForName:@"StoreEntity" inManagedObjectContext:myAppDelegate.managedObjectContext];
        [storeData setCreate_at:[NSDate date]];
        [storeData setIs_valid:[NSNumber numberWithBool:true]];
        [storeData setOverdue_time:[NSNumber numberWithDouble:overdueTime]];
        [storeData setUpdate_at:[NSDate date]];
        [storeData setKey:key];
        [storeData setValue:value];
        [myAppDelegate.managedObjectContext save:nil];
        return storeData;
    }else{
        //要进行保存，否则没更新
        USStoreEntity* store = (USStoreEntity*)mutableFetchResult[0];
        [store setUpdate_at:[NSDate date]];
        [store setOverdue_time:[NSNumber numberWithDouble:overdueTime]];
        [store setValue:value];
        [myAppDelegate.managedObjectContext save:nil];
        return store;
    }
}




+ (USStoreEntity*)setValue:(NSData*)value withKey:(NSString*)key{
   return [USStoreEntity setValue:value withKey:key andOverdueTime:0];
}

+ (NSData*)valueWithKey:(NSString*)key {
    NSAssert(![USStoreEntity isBlankString: key],@"输入的key不能为空");
    if([USStoreEntity isBlankString: key]){
        return nil;
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    AppDelegate *myAppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSEntityDescription* storeEntity=[NSEntityDescription entityForName:@"StoreEntity" inManagedObjectContext:myAppDelegate.managedObjectContext];
    [request setEntity:storeEntity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key=%@",key];
    [request setPredicate:predicate];
    
    
    NSMutableArray* mutableFetchResult=[[myAppDelegate.managedObjectContext executeFetchRequest:request error:nil] mutableCopy];

    if (([mutableFetchResult count] == 0)||(mutableFetchResult == nil)) {
        return nil;
    }
    
    
    //判断是否过期
    
    USStoreEntity *store= (USStoreEntity*)mutableFetchResult[0];
   
    NSDate *datenow = [NSDate date];
    NSTimeInterval now=[datenow timeIntervalSince1970]*1;
    NSTimeInterval update = [store.update_at timeIntervalSince1970]*1;
    
    return store.value;
}


+ (void)deleteStoreKeyLike:(NSString*)likeString {
    AppDelegate *myAppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSEntityDescription* storeEntity=[NSEntityDescription entityForName:@"StoreEntity" inManagedObjectContext:myAppDelegate.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:storeEntity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key  LIKE %@",[NSString stringWithFormat:@"*%@*",likeString]];
    [request setPredicate:predicate];
    
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[myAppDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if(!error){
        for(USStoreEntity *object in mutableFetchResult) {
            [myAppDelegate.managedObjectContext deleteObject:object];
        }
    }
    
    if([myAppDelegate.managedObjectContext hasChanges]) {
        [myAppDelegate.managedObjectContext save:&error];
    }
}


+(float)storeSizeKeyLike:(NSString*)likeString{
    AppDelegate *myAppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSEntityDescription* cacheEntity=[NSEntityDescription entityForName:@"StoreEntity" inManagedObjectContext:myAppDelegate.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:cacheEntity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key  LIKE %@",[NSString stringWithFormat:@"*%@*",likeString]];
    [request setPredicate:predicate];
    
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[myAppDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    float totalSize = 0.0;
    if(!error){
        for(USStoreEntity *object in mutableFetchResult) {
            totalSize = totalSize + object.value.length;
        }
    }
    
    return totalSize;
}

@end
