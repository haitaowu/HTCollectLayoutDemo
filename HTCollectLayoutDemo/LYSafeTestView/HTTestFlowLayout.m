//
//  HTTestFlowLayout.m
//  HTCollectionLayoutDemo
//
//  Created by taotao on 2017/7/28.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "HTTestFlowLayout.h"




@implementation HTTestFlowLayout

#pragma mark - public methods
- (CGPoint)offsetForItemIdx:(NSInteger)idx
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
    //    UICollectionViewCell *item =  [self.collectionView cellForItemAtIndexPath:indexPath];
    CGFloat itemWidth = [self itemWidth];
    CGFloat delta = (self.collectionView.frame.size.width - itemWidth) * 0.5;
    UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:indexPath];
    CGFloat offsetX = (attribute.frame.origin.x - delta);
    return  CGPointMake(offsetX, 0);
}

- (CGFloat)itemWidth
{
    return 300;
}

- (CGFloat)itemHeight
{
    CGFloat ratio = 1.2;
    return ([self itemWidth]  * ratio);
}

#pragma mark - override methods
- (void)prepareLayout
{
    [super prepareLayout];
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat itemWidth = [self itemWidth];
    CGFloat itemHeight = [self itemHeight];
    CGFloat inset = (self.collectionView.frame.size.width - itemWidth) * 0.5;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
    self.minimumLineSpacing = itemWidth * 0.06;
    self.itemSize = CGSizeMake(itemWidth, itemHeight);
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGRect proposedF ;
    proposedF.origin = proposedContentOffset;
    proposedF.size = self.collectionView.frame.size;
    NSArray *visibleAttris = [self layoutAttributesForElementsInRect:proposedF];
    CGFloat centerItemX = proposedContentOffset.x + (self.collectionView.frame.size.width - [self itemWidth]) * 0.5;
    CGFloat deltaOffsetX = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attribute in visibleAttris) {
        if (ABS(attribute.frame.origin.x - centerItemX) < ABS(deltaOffsetX)) {
            deltaOffsetX = attribute.frame.origin.x - centerItemX;
        }
    }
    NSLog(@"propose x = %f",proposedF.origin.x);
    return CGPointMake(proposedContentOffset.x + deltaOffsetX, proposedContentOffset.y);
}


- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    CGPoint offset = self.collectionView.contentOffset;
    CGRect visibleFrame = self.collectionView.frame;
    visibleFrame.origin = offset;
    CGFloat centerX = (int)(offset.x + visibleFrame.size.width * 0.5);
    
    NSArray *attris = [super layoutAttributesForElementsInRect:rect];
    NSArray *copied = [self deepCopyWithArray:attris];
    for (UICollectionViewLayoutAttributes *attribute in copied) {
        CGFloat itemWidth = [self itemWidth];
        if (CGRectIntersectsRect(visibleFrame, attribute.frame)) {
            // 每一个item的中点x
            CGFloat itemCenterX = attribute.center.x;
            // 根据跟屏幕最中间的距离计算缩放比例
            CGFloat collectionViewWidth = self.collectionView.frame.size.width * 0.5;
            CGFloat distance = ABS(itemCenterX - centerX);
            ;
            CGFloat scale = 1 + (1 -  (distance / collectionViewWidth)) * 0.01999999;
            attribute.alpha = (1 -  (distance / collectionViewWidth) * 0.3);
            
            CGFloat distanceValue = itemCenterX - centerX;
//            NSLog(@"scale === %.6f distanceValue = %f ",scale,distanceValue);
            
            attribute.transform = CGAffineTransformMakeScale(scale, scale);
        }
    }
    return copied;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

#pragma mark - private methods
- (NSArray*)deepCopyWithArray:(NSArray*)array
{
    NSMutableArray *copys = [NSMutableArray arrayWithCapacity:array.count];
    for (UICollectionViewLayoutAttributes *attribute in array) {
        id copyAttri = [attribute copy];
        [copys addObject:copyAttri];
    }
    return copys;
}

@end
