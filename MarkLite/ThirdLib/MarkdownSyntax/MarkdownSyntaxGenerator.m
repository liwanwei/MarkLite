//
// Created by azu on 2013/10/26.
//


#import "MarkdownSyntaxGenerator.h"
#import "HighLightModel.h"

#define regexp(reg,option) [NSRegularExpression regularExpressionWithPattern:@reg options:option error:NULL]

NSRegularExpression *NSRegularExpressionFromMarkdownSyntaxType(MarkdownSyntaxType v) {
    switch (v) {
        case MarkdownSyntaxHeaders://标题
            return regexp("^(#+)(.*)", NSRegularExpressionAnchorsMatchLines);
        case MarkdownSyntaxTitle://标题
            return regexp(".*\\n=+[(\\s)|=]+", 0);
        case MarkdownSyntaxLinks://链接
            return regexp("(\\[.+\\]\\([^\\)]+\\))|(<.+>)", 0);
        case MarkdownSyntaxImages://图片
            return regexp("!\\[[^\\]]+\\]\\([^\\)]+\\)", 0);
        case MarkdownSyntaxBold://粗体
            return regexp("(\\*\\*|__)(.*?)\\1", 0);
        case MarkdownSyntaxEmphasis://强调
            return regexp("\\s(\\*|_)(.*?)\\1\\s", 0);
        case MarkdownSyntaxDeletions://删除
            return regexp("\\~\\~(.*?)\\~\\~", 0);
        case MarkdownSyntaxQuotes://引用
            return regexp("\\:\\\"(.*?)\\\"\\:", 0);
        case MarkdownSyntaxInlineCode://內联代码块
            return regexp("`{1,2}[^`](.*?)`{1,2}", 0);
        case MarkdownSyntaxBlockquotes://引用块
            return regexp("\n(&gt;|\\>)(.*)",0);
        case MarkdownSyntaxSeparate://分割线
            return regexp("^-+$", NSRegularExpressionAnchorsMatchLines);
        case MarkdownSyntaxULLists://无序列表
            return regexp("^[\\s]*[-\\*\\+] +(.*)", NSRegularExpressionAnchorsMatchLines);
        case MarkdownSyntaxOLLists://有序列表
            return regexp("^[\\s]*[0-9]+\\.(.*)", NSRegularExpressionAnchorsMatchLines);
        case MarkdownSyntaxCodeBlock://```包围的代码块
            return regexp("```([\\s\\S]*?)```[\\s]?", 0);
        case MarkdownSyntaxImplicitCodeBlock://4个缩进也算代码块
            return regexp("^\n[ \f\r\t\v]*(( {4}|\\t).*(\\n|\\z))+", NSRegularExpressionAnchorsMatchLines);
        case NumberOfMarkdownSyntax:
            break;
    }
    return nil;
}

NSDictionary *AttributesFromMarkdownSyntaxType(MarkdownSyntaxType v) {
    HighLightModel *model = [[HighLightModel alloc]init];
    switch (v) {
        case MarkdownSyntaxHeaders:
            model.textColor = [UIColor cyanColor];
            model.size = 17;
            break;
        case MarkdownSyntaxTitle:
            model.textColor = [UIColor cyanColor];
            model.size = 17;
            break;
        case MarkdownSyntaxLinks:
            model.textColor = [UIColor blueColor];
            break;
        case MarkdownSyntaxImages:
            model.textColor = [UIColor magentaColor];
            break;
        case MarkdownSyntaxBold:
            model.strong = YES;
            break;
        case MarkdownSyntaxEmphasis:
            model.strong = YES;
            break;
        case MarkdownSyntaxDeletions:
            model.deletionLine = YES;
            break;
        case MarkdownSyntaxQuotes:
            model.textColor = [UIColor colorWithRed:5/255.0 green:177/255.0 blue:0.0 alpha:1];
            break;
        case MarkdownSyntaxBlockquotes:
            model.textColor = [UIColor colorWithRed:5/255.0 green:177/255.0 blue:0.0 alpha:1];
            break;
        case MarkdownSyntaxSeparate:
            return @{NSForegroundColorAttributeName : [UIColor purpleColor]};
        case MarkdownSyntaxULLists:
            model.textColor = [UIColor orangeColor];
            break;
        case MarkdownSyntaxOLLists:
            model.textColor = [UIColor orangeColor];
            break;
        case MarkdownSyntaxInlineCode:
            model.textColor = [UIColor brownColor];
            break;
        case MarkdownSyntaxCodeBlock:
            model.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1];
            model.textColor = [UIColor grayColor];
            break;
        case MarkdownSyntaxImplicitCodeBlock:
            model.textColor = [UIColor grayColor];
            model.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1];
            break;
        case NumberOfMarkdownSyntax:
            break;
    }
    return model.attribute;
}


@implementation MarkdownSyntaxGenerator

- (NSArray *)syntaxModelsForText:(NSString *) text {
    NSMutableArray *markdownSyntaxModels = [NSMutableArray array];
    for (MarkdownSyntaxType i = MarkdownSyntaxHeaders; i < NumberOfMarkdownSyntax; i++) {
        NSRegularExpression *expression = NSRegularExpressionFromMarkdownSyntaxType(i);
        NSArray *matches = [expression matchesInString:text
                                       options:0
                                       range:NSMakeRange(0, [text length])];
        for (NSTextCheckingResult *result in matches) {
            [markdownSyntaxModels addObject:[MarkdownSyntaxModel modelWithType:i range:result.range]];
        }
    }
    return markdownSyntaxModels;
}

@end