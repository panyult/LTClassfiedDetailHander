//
//  LTClassfiedView.h
//  LTClassfiedDetailView
//
//  Created by panyu_lt on 2018/2/8.
//  Copyright © 2018年 yimilan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LTClassfiedView;

@protocol LTClassfiedViewDataSource<NSObject>

- (NSUInteger)numberOfRowsInLTClassfiedView:(LTClassfiedView *)classfiedView;
- (UIView *)classfiedView:(LTClassfiedView *)classfiedView viewForRow:(NSUInteger)row;
- (CGSize)classfiedView:(LTClassfiedView *)classfiedView sizeForRow:(NSUInteger)row;

@end

@protocol LTClassfiedViewDelegate<NSObject>
@optional
- (void)classfiedView:(LTClassfiedView *)classfiedView didScrollFrom:(NSUInteger)fromRow to:(NSUInteger)toRow;
- (void)classfiedView:(LTClassfiedView *)classfiedView didSelectViewAtRow:(NSUInteger)row;

- (void)classfiedView:(LTClassfiedView *)classfiedView factor:(CGFloat)factor isMovingFrom:(NSUInteger)fromRow toRow:(NSUInteger )toRow;

@end

@interface LTClassfiedView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bottomLineView;

@property (nonatomic, weak  ) id<LTClassfiedViewDataSource> dataSource;
@property (nonatomic, weak  ) id<LTClassfiedViewDelegate> delegate;

@property (nonatomic, assign) int currentIndex;
@property (nonatomic, assign) CGFloat bottomLineViewWidth;
@property (nonatomic, assign) CGFloat bottomLineViewLeftOffset;
@property (nonatomic, assign) CGFloat bottomLineViewHeight;

- (void)reloadData;
- (void)moveBottomLineViewByFactor:(CGFloat)factor currentIndex:(int)currentIndex targetIndex:(int)targetIndex;
- (void)resetBottomLineViewPositionAtIndex:(int)index;
- (void)setClassfiedViewSelectedAtIndex:(int)index;

- (UIView *)itemViewAtIndex:(NSUInteger)index;

- (void)resetSubviewsLayout;

@end
