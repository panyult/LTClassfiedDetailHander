//
//  LTClassfiedDetailHander.h
//  LTClassfiedDetailView
//
//  Created by panyu_lt on 2018/2/9.
//  Copyright © 2018年 yimilan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTClassfiedView.h"
#import "LTDetailView.h"

@class LTClassfiedDetailHander;

@protocol LTClassfiedDetailHanderDelegate<NSObject>
@optional
- (void)classfiedDetailHander:(LTClassfiedDetailHander *)classfiedDetailHander factor:(CGFloat)factor isMovingFrom:(NSUInteger)fromRow toRow:(NSUInteger)toRow;
- (void)classfiedDetailHander:(LTClassfiedDetailHander *)classfiedDetailHander  didScrollFrom:(NSUInteger)fromRow to:(NSUInteger)toRow;
@end

@interface LTClassfiedDetailHander : NSObject

@property (nonatomic, strong) LTClassfiedView *classfiedView;
@property (nonatomic, strong) LTDetailView *detailView;
@property (nonatomic, weak  ) id<LTClassfiedDetailHanderDelegate> delegate;

- (void)reloadData;
@end
