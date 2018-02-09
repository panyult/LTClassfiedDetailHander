//
//  ViewController.m
//  LTClassfiedDetailView
//
//  Created by panyu_lt on 2018/2/8.
//  Copyright © 2018年 yimilan. All rights reserved.
//

#import "ViewController.h"
#import "LTClassfiedDetailHander.h"

static NSString *const LTClassfiedDetailHanderCell = @"LTClassfiedDetailHanderCell";

@interface ViewController ()<LTClassfiedViewDataSource,LTDetailViewDataSource,LTClassfiedDetailHanderDelegate>
@property (nonatomic, strong) LTClassfiedDetailHander *handler;
@property (nonatomic, assign) int dataSourceCount;

@end

@implementation ViewController
#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigation];
    [self setupDefaultValue];
    [self setupSubviews];
    
    [self.handler reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)setupNavigation
{
    
}

-(void)setupDefaultValue
{
    self.dataSourceCount = 10;
    
    self.handler = [[LTClassfiedDetailHander alloc] init];
    self.handler.delegate = self;
    self.handler.classfiedView.dataSource = self;
    self.handler.detailView.dataSource = self;
    
    [self.handler.detailView.collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:LTClassfiedDetailHanderCell];
}

-(void)setupSubviews
{
    [self addSubviews];
    [self setupSubviewsConstraints];
}
#pragma mark - layout subviews

-(void)addSubviews
{
    [self.view addSubview:self.handler.classfiedView];
    [self.view addSubview:self.handler.detailView];
}

-(void)setupSubviewsConstraints {
    
}


#pragma mark - LTClassfiedViewDataSource

- (NSUInteger)numberOfRowsInLTClassfiedView:(LTClassfiedView *)classfiedView
{
    return self.dataSourceCount;
}

- (UIView *)classfiedView:(LTClassfiedView *)classfiedView viewForRow:(NSUInteger)row
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (40+row%2*60), 50)];
    label.text = [NSString stringWithFormat:@"%ld",row];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = (row%2 == 1) ? [UIColor whiteColor]:[UIColor purpleColor];
    label.userInteractionEnabled = YES;
    return label;
}

- (CGSize)classfiedView:(LTClassfiedView *)classfiedView sizeForRow:(NSUInteger)row
{
    CGSize size = CGSizeMake((40+row%2*60), 50);
    return size;
}

#pragma mark - LTDetailViewDataSource

- (NSInteger)detailView:(LTDetailView *)detailView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSourceCount;
}

- (UICollectionViewCell *)detailView:(LTDetailView *)detailView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [detailView.collectionView dequeueReusableCellWithReuseIdentifier:LTClassfiedDetailHanderCell forIndexPath:indexPath];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 30, 30)];
    label.text = [NSString stringWithFormat:@"%ld",indexPath.item];
    cell.backgroundColor = indexPath.item % 2 == 1 ? [UIColor whiteColor]:[UIColor redColor];
    [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [cell addSubview:label];
    
    return cell;
}

- (CGSize)detailView:(LTDetailView *)detailView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return detailView.bounds.size;
}

#pragma mark - LTClassfiedDetailHanderDelegate

- (void)classfiedDetailHander:(LTClassfiedDetailHander *)classfiedDetailHander factor:(CGFloat)factor isMovingFrom:(NSUInteger)fromRow toRow:(NSUInteger)toRow
{
    UIView *itemView = [classfiedDetailHander.classfiedView itemViewAtIndex:toRow];
    if (itemView && [itemView isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)itemView;
        UIColor *color = fromRow % 2 == 1 ? [UIColor redColor] : [UIColor blueColor];
        label.backgroundColor = [color colorWithAlphaComponent:factor];
    }
    
}

- (void)classfiedDetailHander:(LTClassfiedDetailHander *)classfiedDetailHander didScrollFrom:(NSUInteger)fromRow to:(NSUInteger)toRow
{
  
    UIView *itemView = [classfiedDetailHander.classfiedView itemViewAtIndex:fromRow];
    
    if (itemView && [itemView isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)itemView;
        UIColor *color = fromRow % 2 == 1 ? [UIColor whiteColor] : [UIColor purpleColor];
        label.backgroundColor = color;
    }

}

#pragma mark - event response

#pragma mark - load data

#pragma mark - public methods

#pragma mark - private methods

#pragma mark - getters and setters



@end
