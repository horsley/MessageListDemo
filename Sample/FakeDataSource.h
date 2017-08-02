//
//  FakeDataSource.h
//  Sample
//
//  Created by horsley on 2017/8/2.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PageSize 20

@interface FakeDataSource : NSObject
@property (nonatomic, readonly) NSUInteger count;

- (NSNumber *)objectAtIndex:(NSUInteger)index;

- (void)loadMore;
@end
