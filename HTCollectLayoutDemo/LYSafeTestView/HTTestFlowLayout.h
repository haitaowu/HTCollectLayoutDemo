//
//  HTTestFlowLayout.h
//  HTCollectionLayoutDemo
//
//  Created by taotao on 2017/7/28.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define kVaccineItemWH                 50

@interface HTTestFlowLayout : UICollectionViewFlowLayout

- (CGPoint)offsetForItemIdx:(NSInteger)idx;

- (CGFloat)itemWidth;
- (CGFloat)itemHeight;

@end
