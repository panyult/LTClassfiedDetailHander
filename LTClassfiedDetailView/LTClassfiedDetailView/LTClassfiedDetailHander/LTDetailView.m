//
//  LTDetailView.m
//  LTClassfiedDetailView
//
//  Created by panyu_lt on 2018/2/8.
//  Copyright © 2018年 yimilan. All rights reserved.
//

#import "LTDetailView.h"

@interface LTDetailView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

@implementation LTDetailView

#pragma mark - life cycle

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

-(void)setup
{
    
    [self setupDefaultValue];
    [self setupSubviews];
}

#pragma mark - layout subviews

-(void)setupDefaultValue {

}

-(void)setupSubviews
{
    UIView *superView = self;
    [superView addSubview:self.collectionView];
    [self resetSubviewsLayout];
}

#pragma mark - collectionView delegate and datasource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(detailView:numberOfItemsInSection:)]) {
        count = [self.dataSource detailView:self numberOfItemsInSection:section];
    }
    return count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(detailView:cellForItemAtIndexPath:)]) {
        cell = [self.dataSource detailView:self cellForItemAtIndexPath:indexPath];
    }
//    NSAssert(cell != nil, @"cell can't be nil");
//    if (!cell) {
//        cell = [[UICollectionViewCell alloc] init];
//    }
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGSize size = CGSizeZero;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(detailView:layout:sizeForItemAtIndexPath:)]) {
        size = [self.dataSource detailView:self layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }
    
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailView:didSelectItemAtIndexPath:)]) {
        
        [self.delegate detailView:self didSelectItemAtIndexPath:indexPath];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailViewDidScroll:)]) {
        [self.delegate detailViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailViewDidEndDecelerating:)]) {
        [self.delegate detailViewDidEndDecelerating:scrollView];
    }
}


#pragma mark - event response

#pragma mark - public methods

- (void)resetSubviewsLayout
{
    self.collectionView.frame = self.bounds;
}

#pragma mark - private methods

#pragma mark - getters and setters

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing =0;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource= self;
        CGFloat color = 185/255.0;
        _collectionView.backgroundColor = [UIColor colorWithRed:color green:color blue:color alpha:1];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

@end
