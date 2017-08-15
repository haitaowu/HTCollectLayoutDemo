//
//  SafeTestItem.h
//  lepregt
//
//  Created by taotao on 2017/7/27.
//  Copyright © 2017年 Singer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SafeTestItem : UICollectionViewCell
@property (nonatomic,strong)NSDictionary *data;
- (void)updateWithData:(NSDictionary*)data datas:(NSArray*)dataArray;
@end
