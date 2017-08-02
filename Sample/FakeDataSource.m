//
//  FakeDataSource.m
//  Sample
//
//  Created by horsley on 2017/8/2.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "FakeDataSource.h"

#define TotalItemCount 3000

@interface FakeDataSource()
@property (nonatomic) NSMutableArray *currentDataSource;
@property (nonatomic) NSMutableArray *fullDataSource;
@end

@implementation FakeDataSource
- (instancetype)init {
  self = [super init];
  if (self) {
    
    
    _fullDataSource = [NSMutableArray new];
    for (int i = 0; i < TotalItemCount; i++) {
      [_fullDataSource addObject:@(i)];
    }
    
    _currentDataSource = [NSMutableArray new];
    for (int i = PageSize; i > 0; i--) {
      [_currentDataSource addObject:[_fullDataSource objectAtIndex:_fullDataSource.count - i]];
    }
  }
  return self;
}

- (NSUInteger)count {
  return _currentDataSource.count;
}

- (NSNumber *)objectAtIndex:(NSUInteger)index {
  return [_currentDataSource objectAtIndex:index];
}

- (void)loadMore {
  NSMutableArray *newData = [NSMutableArray new];
  for (int i = PageSize + (int)_currentDataSource.count; i > 0; i--) {
    [newData addObject:[_fullDataSource objectAtIndex:_fullDataSource.count - i]];
  }
  _currentDataSource = newData;
}
@end
