//
//  LTClassfiedDetailHander.m
//  LTClassfiedDetailView
//
//  Created by panyu_lt on 2018/2/9.
//  Copyright © 2018年 yimilan. All rights reserved.
//

#import "LTClassfiedDetailHander.h"

@interface LTClassfiedDetailHander()<LTClassfiedViewDelegate,LTDetailViewDelegate>

@property (nonatomic, assign) BOOL isTriggeredByClassfiedViewClick;
@property (nonatomic, assign) int currentIndex;
@end

@implementation LTClassfiedDetailHander

#pragma mark - life cycle

-(instancetype)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

-(void)setup
{
    
}

#pragma mark - LTClassfiedViewDelegate

- (void)classfiedView:(LTClassfiedView *)classfiedView didSelectViewAtRow:(NSUInteger)row
{
    self.isTriggeredByClassfiedViewClick = YES;
    self.currentIndex = (int)row;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:0];
    [self.detailView.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
}

- (void)classfiedView:(LTClassfiedView *)classfiedView factor:(CGFloat)factor isMovingFrom:(NSUInteger)fromRow toRow:(NSUInteger)toRow
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(classfiedDetailHander:factor:isMovingFrom:toRow:)]) {
        [self.delegate classfiedDetailHander:self factor:factor isMovingFrom:fromRow toRow:toRow];
    }
}

- (void)classfiedView:(LTClassfiedView *)classfiedView didScrollFrom:(NSUInteger)fromRow to:(NSUInteger)toRow
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(classfiedDetailHander:didScrollFrom:to:)]) {
        [self.delegate classfiedDetailHander:self didScrollFrom:fromRow to:toRow];
    }
}

#pragma mark - LTDetailViewDelegate

- (void)detailViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat perPageWidth = scrollView.frame.size.width;
    if (self.isTriggeredByClassfiedViewClick) {
        int temp = (int)offsetX % (int)perPageWidth;
        if (temp == 0) {
            self.isTriggeredByClassfiedViewClick = NO;
        }
        return;
    }
    int tempIndex = (int)offsetX/(int)perPageWidth;
    
    CGFloat tempOffset = (offsetX - tempIndex * perPageWidth)/perPageWidth;
    
    int targetIndex = tempOffset < 0 ? (tempIndex - 1) : (tempIndex +1);
    
    if (tempOffset < 0) {
        tempOffset = -tempOffset;
    }
    
    [self.classfiedView moveBottomLineViewByFactor:tempOffset currentIndex:tempIndex targetIndex:targetIndex];
    
}

- (void)detailViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat perPageWidth = scrollView.frame.size.width;
    
    int index = (int)offsetX / (int)perPageWidth;
    
    self.currentIndex = index;
    [self.classfiedView resetBottomLineViewPositionAtIndex:index];
}


#pragma mark - event response

#pragma mark - public methods

- (void)reloadData
{
    [self.classfiedView reloadData];
    [self.detailView.collectionView reloadData];
}

#pragma mark - private methods

#pragma mark - getters and setters

- (LTClassfiedView *)classfiedView
{
    if (!_classfiedView) {
        _classfiedView = [[LTClassfiedView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        _classfiedView.delegate = self;
        _classfiedView.backgroundColor = [UIColor yellowColor];

    }
    return _classfiedView;
}

- (LTDetailView *)detailView
{
    if (!_detailView) {
        _detailView = [[LTDetailView alloc] initWithFrame:CGRectMake(0, 50, 320, 518)];
        _detailView.delegate = self;
        _detailView.backgroundColor = [UIColor greenColor];
    }
    return _detailView;
}


@end
