//
//  UITextView+Base.h
//  Usth System
//
//  Created by Serx on 2017/5/30.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Base)

-(CGSize)commentTextViewAttributedTextWithCommentStr:(NSString *)commentStr andAuthorName:(NSString *)authorName withWidth:(CGFloat)width ;

+(CGSize)commentTextViewAttributedTextWithCommentStr:(NSString *)commentStr andAuthorName:(NSString *)authorName withWidth:(CGFloat)width ;


@end
