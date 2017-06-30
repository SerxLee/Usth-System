//
//  UITextView+Base.m
//  Usth System
//
//  Created by Serx on 2017/5/30.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import "UITextView+Base.h"

@implementation UITextView (Base)

-(CGSize)commentTextViewAttributedTextWithCommentStr:(NSString *)commentStr andAuthorName:(NSString *)authorName withWidth:(CGFloat)width {
    NSMutableAttributedString *authorNameAttributeText = [NSMutableAttributedString new];
    if (![authorName isEqualToString:@""]) {
        NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
        style.lineSpacing = 2.0;
        style.paragraphSpacing = 4.0;
        [authorNameAttributeText appendAttributedString: [[NSAttributedString alloc] initWithString:authorName attributes: @{NSFontAttributeName: [UIFont systemFontOfSize:18.0], NSForegroundColorAttributeName: [UIColor blackColor], NSParagraphStyleAttributeName: style}]];
    }
    if (![commentStr isEqualToString:@""]) {
        
        if (authorNameAttributeText.length > 0) {
            [authorNameAttributeText appendAttributedString: [[NSAttributedString alloc] initWithString:@"\n"]];
        }
        
        NSMutableParagraphStyle *contentStyle = [NSMutableParagraphStyle new];
        contentStyle.lineSpacing = 2.0;
        contentStyle.paragraphSpacing = 2.0;
        [authorNameAttributeText appendAttributedString:[[NSAttributedString alloc] initWithString:commentStr attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0], NSForegroundColorAttributeName: [UIColor blackColor], NSParagraphStyleAttributeName: contentStyle}]];
    }
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [authorNameAttributeText boundingRectWithSize:CGSizeMake(width - 16.0, CGFLOAT_MAX) options:options context:nil];
    self.attributedText = authorNameAttributeText;
    return rect.size;
}

+(CGSize)commentTextViewAttributedTextWithCommentStr:(NSString *)commentStr andAuthorName:(NSString *)authorName withWidth:(CGFloat)width {
    NSMutableAttributedString *authorNameAttributeText = [NSMutableAttributedString new];
    if (![authorName isEqualToString:@""]) {
        NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
        style.lineSpacing = 2.0;
        style.paragraphSpacing = 4.0;
        [authorNameAttributeText appendAttributedString: [[NSAttributedString alloc] initWithString:authorName attributes: @{NSFontAttributeName: [UIFont systemFontOfSize:18.0], NSForegroundColorAttributeName: [UIColor blackColor], NSParagraphStyleAttributeName: style}]];
    }
    if (![commentStr isEqualToString:@""]) {
        
        if (authorNameAttributeText.length > 0) {
            [authorNameAttributeText appendAttributedString: [[NSAttributedString alloc] initWithString:@"\n"]];
        }
        
        NSMutableParagraphStyle *contentStyle = [NSMutableParagraphStyle new];
        contentStyle.lineSpacing = 2.0;
        contentStyle.paragraphSpacing = 2.0;
        [authorNameAttributeText appendAttributedString:[[NSAttributedString alloc] initWithString:commentStr attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0], NSForegroundColorAttributeName: [UIColor blackColor], NSParagraphStyleAttributeName: contentStyle}]];
    }
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [authorNameAttributeText boundingRectWithSize:CGSizeMake(width - 16.0, CGFLOAT_MAX) options:options context:nil];
    return rect.size;
}

@end
