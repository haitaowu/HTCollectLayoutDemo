//
//  SafeTestItem.m
//  lepregt
//
//  Created by taotao on 2017/7/27.
//  Copyright © 2017年 Singer. All rights reserved.
//

#import "SafeTestItem.h"

@interface SafeTestItem()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation SafeTestItem

- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - public methods
- (void)updateWithData:(NSDictionary*)data datas:(NSArray*)dataArray
{
    self.data =  data;
    NSInteger idx = [dataArray indexOfObject:data] + 1;
    NSString *indexStr = [NSString stringWithFormat:@"%ld/%ld",idx,[dataArray count]];
    self.indexLabel.text = indexStr;
    NSString *title = [data objectForKey:@"title"];
    self.titleLabel.text = title;
    NSString *content = [data objectForKey:@"content"];
    self.contentLabel.text = content;
}


@end
