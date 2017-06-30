//
//  AppDelegate.h
//  Usth System
//
//  Created by Serx on 2017/5/15.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USOperationFactory.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) USOperationFactory *operationFactory;

@end

