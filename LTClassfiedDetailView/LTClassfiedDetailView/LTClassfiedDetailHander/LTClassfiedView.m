//
//  LTClassfiedView.m
//  LTClassfiedDetailView
//
//  Created by panyu_lt on 2018/2/8.
//  Copyright © 2018年 yimilan. All rights reserved.
//

#import "LTClassfiedView.h"

@interface LTClassfiedView()

@property (nonatomic, strong) NSMutableArray *classfiedViewArray;
@property (nonatomic, strong) NSMutableArray *classfiedViewFrameArray;

@end

@implementation LTClassfiedView

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
    self.bottomLineViewLeftOffset = 0;
    self.bottomLineViewHeight = 3;
    
}

-(void)setupSubviews
{
    [self addSubviews];
    
}

-(void)addSubviews
{
    UIView *superView = self;
    [superView addSubview:self.scrollView];
    [self.scrollView addSubview:self.bottomLineView];
    
    [self resetSubviewsLayout];
}

#pragma mark - event response

- (void)selectItemAction:(UIButton *)sender
{
    UIView *itemView = sender.superview;
    
    NSUInteger index = [self.classfiedViewArray indexOfObject:itemView];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(classfiedView:didSelectViewAtRow:)]) {
        [self.delegate classfiedView:self didSelectViewAtRow:index];
    }
    
    [self resetBottomLineViewPositionAtIndex:(int)index];
    
}

#pragma mark - public methods

- (void)moveBottomLineViewByFactor:(CGFloat)factor currentIndex:(int)currentIndex targetIndex:(int)targetIndex
{
    if (targetIndex < 0 || targetIndex >= self.classfiedViewFrameArray.count) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(classfiedView:factor:isMovingFrom:toRow:)]) {
        
        [self.delegate classfiedView:self factor:factor isMovingFrom:currentIndex toRow:targetIndex];
    }

    CGRect oriFrame = [self.classfiedViewFrameArray[currentIndex] CGRectValue];
    
    CGRect frame = [self.classfiedViewFrameArray[targetIndex] CGRectValue];
    
    CGFloat x = (frame.origin.x - oriFrame.origin.x) * factor + oriFrame.origin.x;
    CGFloat width = (frame.size.width - oriFrame.size.width) * factor + oriFrame.size.width;
    CGRect lineFrame = self.bottomLineView.frame;
    
    lineFrame.origin.x = x;
    lineFrame.size.width = width;
    
    self.bottomLineView.frame = lineFrame;
}

- (void)resetBottomLineViewPositionAtIndex:(int)index
{
    if (index < 0 && index >= self.classfiedViewFrameArray.count) {
        return;
    }
    NSValue *value = self.classfiedViewFrameArray[index];
    CGRect frame = [value CGRectValue];
    [UIView animateWithDuration:0.2 animations:^{
        self.bottomLineView.frame = CGRectMake(frame.origin.x,self.bounds.size.height - self.bottomLineViewHeight, frame.size.width, self.bottomLineViewHeight);
    } completion:^(BOOL finished) {
        [self setClassfiedViewSelectedAtIndex:index];
    }];
}

- (void)setClassfiedViewSelectedAtIndex:(int)index
{
    int targetIndex = index - 1;
    int count = (int)self.classfiedViewFrameArray.count;
    if (targetIndex >= count) {
        targetIndex = count - 1;
    }else if (targetIndex < 0) {
        targetIndex = 0;
    }
    
    NSValue *value = self.classfiedViewFrameArray[targetIndex];
    CGRect frame = [value CGRectValue];
    CGPoint targetPoint = CGPointMake(frame.origin.x - self.bottomLineViewLeftOffset, frame.origin.y);
    [self.scrollView scrollRectToVisible:CGRectMake(targetPoint.x, targetPoint.y, [UIScreen mainScreen].bounds.size.width, self.bounds.size.height) animated:YES];
    if (index != self.currentIndex) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(classfiedView:didScrollFrom:to:)]) {
            [self.delegate classfiedView:self didScrollFrom:self.currentIndex to:index];
        }
        
        self.currentIndex = index;
    }
    
}

- (void)reloadData
{
    [self.classfiedViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.classfiedViewArray removeAllObjects];
    
    NSInteger dataSourceCount = 0;
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfRowsInLTClassfiedView:)]) {
        dataSourceCount = [self.dataSource numberOfRowsInLTClassfiedView:self];
    }
    
    if (dataSourceCount <= 0) {
        return;
    }
    
    CGFloat padding = self.bottomLineViewLeftOffset;
    CGFloat totalWidth = 0;
    CGFloat height = self.bounds.size.height;

    for (NSInteger i = 0; i< dataSourceCount; i++) {
        UIView *itemView = nil;
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(classfiedView:viewForRow:)]) {
            itemView = [self.dataSource classfiedView:self viewForRow:i];
        }
        
        NSAssert(itemView != nil, @"itemView can not be nil");
        if (itemView) {
            [self.scrollView addSubview:itemView];
            [self.classfiedViewArray addObject:itemView];
            
            CGSize itemSize = CGSizeZero;
            if (self.dataSource && [self.dataSource respondsToSelector:@selector(classfiedView:sizeForRow:)]) {
                itemSize = [self.dataSource classfiedView:self sizeForRow:i];
            }
            CGFloat x = totalWidth + padding;
            
            CGFloat width = itemSize.width;
            height = itemSize.height;
            
            NSValue *value = [NSValue valueWithCGRect:CGRectMake(x, 0, width, height)];
            [self.classfiedViewFrameArray addObject:value];
            
            totalWidth = x + width;
            itemView.frame = CGRectMake(x, 0, width, height);
            
            [self addAButtonOnView:itemView];
            
        }
        totalWidth += padding;
        [self.scrollView setContentSize:CGSizeMake(totalWidth,height)];
        [self.scrollView addSubview:self.bottomLineView];
        [self resetBottomLineViewPositionAtIndex:0];
        
    }
}

- (UIView *)itemViewAtIndex:(NSUInteger)index
{
    if (index >= self.classfiedViewArray.count) {
        return nil;
    }
    
    return self.classfiedViewArray[index];
}

- (void)resetSubviewsLayout
{
    self.scrollView.frame = self.bounds;
}

#pragma mark - private methods

- (void)addAButtonOnView:(UIView *)view
{
    if (view && [view isKindOfClass:[UIView class]]) {
        
        UIButton *btn = [[UIButton alloc] init];
        
        [btn addTarget:self action:@selector(selectItemAction:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.frame = view.bounds;
        [view addSubview:btn];
        
    }
}

#pragma mark - getters and setters


- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
//        _scrollView.backgroundColor = [];
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(self.bottomLineViewLeftOffset, self.bounds.size.height - self.bottomLineViewHeight, 35, self.bottomLineViewHeight)];
//        _orangeLineView.backgroundColor = AppColor(255,169,105);
        _bottomLineView.backgroundColor = [UIColor greenColor];
        
    }
    return _bottomLineView;
}

- (NSMutableArray *)classfiedViewArray
{
    if (!_classfiedViewArray) {
        _classfiedViewArray = [NSMutableArray array];
    }
    return _classfiedViewArray;
}


- (NSMutableArray *)classfiedViewFrameArray
{
    if (!_classfiedViewFrameArray) {
        _classfiedViewFrameArray = [NSMutableArray array];
    }
    return _classfiedViewFrameArray;
}

@end

