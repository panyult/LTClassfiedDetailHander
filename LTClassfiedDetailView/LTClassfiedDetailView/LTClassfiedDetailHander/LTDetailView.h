//
//  LTDetailView.h
//  LTClassfiedDetailView
//
//  Created by panyu_lt on 2018/2/8.
//  Copyright © 2018年 yimilan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LTDetailView;

@protocol LTDetailViewDataSource<NSObject>

-(NSInteger)detailView:(LTDetailView *)detailView numberOfItemsInSection:(NSInteger)section;
-(UICollectionViewCell *)detailView:(LTDetailView *)detailView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
-(CGSize)detailView:(LTDetailView *)detailView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol LTDetailViewDelegate<NSObject>

@optional

- (void)detailView:(LTDetailView *)detailView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)detailViewDidScroll:(UIScrollView *)scrollView;
- (void)detailViewDidEndDecelerating:(UIScrollView *)scrollView;

@end

@interface LTDetailView : UIView

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, weak  ) id<LTDetailViewDelegate> delegate;
@property (nonatomic, weak  ) id<LTDetailViewDataSource> dataSource;

@property (nonatomic, assign) int currentIndex;

- (void)resetSubviewsLayout;

@end
