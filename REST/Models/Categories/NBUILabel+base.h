//
//  NBUILabel+base.h
//  noodleBlue
//
//  Created by susiqian on 16/7/18.
//  Copyright © 2016年 noodles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Base)
- (CGSize)boundingRectWithSize:(CGSize)size;


- (void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing;

//评论添加作者名字



/**
 计算label高度

 @param labWidth label宽度
 @param textStr text
 @param lineSpaceing 行间距
 @return size
 */
-(CGSize)calculateLabelHeightWithWidth:(CGFloat)labWidth
                               textStr:(NSString *)textStr
                          lineSpaceing:(CGFloat)lineSpaceing;

@end
