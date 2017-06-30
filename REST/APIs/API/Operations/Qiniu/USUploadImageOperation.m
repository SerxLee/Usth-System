//
//  USUploadImageOperation.m
//  Usth System
//
//  Created by Serx on 2017/5/25.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import "USUploadImageOperation.h"
#import "QiniuSDK.h"

@implementation USUploadImageOperation

-(void)uploadImage:(UIImage *)image withName:(NSString *)fileName {
    NSData *data = UIImagePNGRepresentation(image);
    QNUploadManager * uploader = [QNUploadManager new];
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"headerToken"];
    [uploader putData:data key:fileName token: token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if (info.ok) {
            int error = [[resp objectForKey:@"err"] intValue];
            if (error == 0) {
                NSString *headerImageString = [resp objectForKey:@"data"];
                if ([self.delegate respondsToSelector:@selector(uploadImageSuccess:)]) {
                    [self.delegate uploadImageSuccess:headerImageString];
                }
            }
            else {
                NSString *errorReson = [resp objectForKey:@"reason"];
                NSLog(@"%@", errorReson);
            }
        }
        else {
            NSLog(@"error: %@", info.error.description);
        }
    } option:nil];
}

@end
