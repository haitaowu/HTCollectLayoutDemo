//
//  ViewController.m
//  HTCollectLayoutDemo
//
//  Created by taotao on 2017/8/14.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "ViewController.h"
#import "HTTestFlowLayout.h"
#import "SafeTestItem.h"
#import "SafeTestViewController.h"



static NSString * CollectionCellID = @"SafeTestItemID";

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    HTTestFlowLayout *flowLayout = [[HTTestFlowLayout alloc] init];
    UINib *collectionNib = [UINib nibWithNibName:@"SafeTestItem" bundle:nil];
    [self.collectionView setCollectionViewLayout:flowLayout];
    [self.collectionView registerNib:collectionNib forCellWithReuseIdentifier:CollectionCellID];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)clickMe:(id)sender {
    SafeTestViewController *testControl = [[SafeTestViewController alloc] init];
    [self.navigationController pushViewController:testControl animated:YES];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SafeTestItem *collectCell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionCellID forIndexPath:indexPath];
//    NSDictionary *data = [self.dataArray objectAtIndex:indexPath.item];
//    collectCell.data = data;
    return collectCell;
}







@end
