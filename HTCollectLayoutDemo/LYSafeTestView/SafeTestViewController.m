//
//  SafeTestViewController.m
//  HTCollectLayoutDemo
//
//  Created by taotao on 2017/8/15.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "SafeTestViewController.h"
#import "HTTestFlowLayout.h"
#import "SafeTestItem.h"
#import "StateButton.h"

static NSString * CollectionCellID = @"SafeTestItemID";

@interface SafeTestViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong)NSDictionary *currentData;
@property (nonatomic,strong)HTTestFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet StateButton *noBtn;
@property (weak, nonatomic) IBOutlet UIView *stateView;
@property (weak, nonatomic) IBOutlet StateButton *yesBtn;
@end

#define  kLibPath               NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject

#define kSafeTestFileName          @"safeTest"

@implementation SafeTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    HTTestFlowLayout *flowLayout = [[HTTestFlowLayout alloc] init];
    self.flowLayout = flowLayout;
    UINib *collectionNib = [UINib nibWithNibName:@"SafeTestItem" bundle:nil];
    [self.collectionView setCollectionViewLayout:flowLayout];
    [self.collectionView registerNib:collectionNib forCellWithReuseIdentifier:CollectionCellID];
    NSArray *dataArray = [self localSavedTestDataWithName:kSafeTestFileName];
    if (dataArray == nil) {
        dataArray = [self datasWithName:kSafeTestFileName];
    }
    self.dataArray = dataArray;
    [self customeCollectionSCrollToIndex:0];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self writeTestToLocalWithArray:self.dataArray fileName:kSafeTestFileName];
}

#pragma mark - selectors
- (IBAction)tapNoBtn:(UIButton*)sender {
    if (sender.selected == NO) {
        sender.selected = YES;
        self.yesBtn.selected = NO;
    }
    [self.currentData setValue:@(0) forKey:@"state"];
}

- (IBAction)tapYesBtn:(UIButton*)sender {
    if (sender.selected == NO) {
        sender.selected = YES;
        self.noBtn.selected = NO;
    }
    [self.currentData setValue:@(1) forKey:@"state"];
}

#pragma mark - private scrollview scroll index methods
- (void)customeCollectionSCrollToIndex:(NSInteger)index
{
    self.currentData = [self.dataArray objectAtIndex:index];
    NSNumber *state = [self.currentData objectForKey:@"state"];
    if ([state boolValue] == YES) {
        [self tapYesBtn:self.yesBtn];
    }else{
        [self tapNoBtn:self.noBtn];
    }
}

#pragma mark - private data save read methods
//取出安全自测表模板数据
- (NSMutableArray*)datasWithName:(NSString*)fileName
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    NSArray *datas = [NSArray arrayWithContentsOfFile:filePath];
    datas = [self mutableContentsWith:datas];
    return [NSMutableArray arrayWithArray:datas];
}

//取出本地存储的用户的数据
- (NSArray*)localSavedTestDataWithName:(NSString*)fileName
{
    NSString *filePath = [kLibPath stringByAppendingPathComponent:fileName];
    if ([self fileExistWith:filePath]) {
        
        NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
        return [self mutableContentsWith:array];
    }else{
        return nil;
    }
}

//存储用户自测数据
- (void)writeTestToLocalWithArray:(id)data fileName:(NSString*)fileName
{
    NSString *filePath = [kLibPath stringByAppendingPathComponent:fileName];
    dispatch_queue_t queue = dispatch_queue_create("com.hai.wu", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [data writeToFile:filePath atomically:YES];
    });
}

//检查文件是否存在
- (BOOL)fileExistWith:(NSString*)filePath
{
    NSFileManager *fileMan = [NSFileManager defaultManager];
    return [fileMan fileExistsAtPath:filePath];
}

//将数据中的NSDictionary 转换为 NSMutableDictionary
- (NSArray*)mutableContentsWith:(NSArray*)array
{
    NSMutableArray *mutableArray;
    if ([array count] > 0) {
        mutableArray = [NSMutableArray array];
    }
    for (id obj in array) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:obj];
            [mutableArray addObject:dict];
        }
    }
    return mutableArray;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SafeTestItem *collectCell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionCellID forIndexPath:indexPath];
    NSDictionary *data = [self.dataArray objectAtIndex:indexPath.item];
    [collectCell updateWithData:data datas:self.dataArray];
    return collectCell;
}



#pragma mark - uiscrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.stateView.userInteractionEnabled = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSArray *visibleCells = [self.collectionView visibleCells];
    CGFloat delta = self.collectionView.frame.size.width * 0.5;
    CGFloat centerX = self.collectionView.contentOffset.x + delta;
    CGFloat minCenterX = centerX - [self.flowLayout itemWidth] * 0.5 * 0.8;
    CGFloat maxCenterX = centerX + [self.flowLayout itemWidth] * 0.5 * 0.8;
    for (UICollectionViewCell *item in visibleCells) {
        CGFloat visibleCenterX = item.center.x;
        if ((visibleCenterX >= minCenterX) && (visibleCenterX <= maxCenterX)) {
            NSInteger idx = [self.collectionView indexPathForCell:item].item;
            NSLog(@"idx  = %ld",idx);
            [self customeCollectionSCrollToIndex:idx];
        }
    }
    self.stateView.userInteractionEnabled = YES;
}


@end
