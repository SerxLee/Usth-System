//
//  USUploadImageOperation.h
//  Usth System
//
//  Created by Serx on 2017/5/25.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol USUploadImageOperationDelegate <NSObject>

-(void)uploadImageSuccess: (NSString *)imgURLStr;

@end

@interface USUploadImageOperation : NSObject

@property (weak, nonatomic) id<USUploadImageOperationDelegate> delegate;

-(void)uploadImage: (UIImage *)image withName: (NSString *)fileName;

@end
