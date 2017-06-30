//
//  NBUILabel+base.m
//  noodleBlue
//
//  Created by susiqian on 16/7/18.
//  Copyright © 2016年 noodles. All rights reserved.
//

#import "NBUILabel+base.h"

@implementation UILabel (Base)
- (CGSize)boundingRectWithSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    
    CGSize retSize = [self.text boundingRectWithSize:size
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize;
}


//行间距
-(void)setText:(NSString *)text lineSpacing:(CGFloat)lineSpacing {
    if (lineSpacing < 0.01 || !text) {
        self.text = text;
        return;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, [text length])];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [paragraphStyle setLineBreakMode:self.lineBreakMode];
    [paragraphStyle setAlignment:self.textAlignment];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    
    self.attributedText = attributedString;
}

-(CGSize)calculateLabelHeightWithWidth:(CGFloat)labWidth textStr:(NSString *)textStr lineSpaceing:(CGFloat)lineSpaceing {
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:textStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpaceing];
    
    UIFont *font = self.font;
    
    [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, textStr.length)];
    [attributeStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, textStr.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attributeStr boundingRectWithSize:CGSizeMake(labWidth, CGFLOAT_MAX) options:options context:nil];
    
    self.attributedText = attributeStr;
    return rect.size;
}

@end
