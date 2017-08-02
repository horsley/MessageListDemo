//
//  LoadingCellNode.m
//  Sample
//
//  Created by horsley on 2017/8/2.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "LoadingCellNode.h"

@interface LoadingCellNode()
@property (nonatomic) UIActivityIndicatorView *indicator;
@property (nonatomic) ASDisplayNode *indicatorNode;
@end

@implementation LoadingCellNode
- (instancetype)init {
  self = [super init];
  if (self) {
    self.automaticallyManagesSubnodes = YES;
    
    _indicatorNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView * _Nonnull{
      _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
      _indicator.backgroundColor = [UIColor clearColor];
      return _indicator;
    }];
    _indicatorNode.style.preferredSize = CGSizeMake(30, 30);
  }
  return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
  return [ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringXY
                                                    sizingOptions:ASCenterLayoutSpecSizingOptionDefault
                                                            child:_indicatorNode];
}

- (void)didEnterVisibleState {
  [super didEnterVisibleState];
  [_indicator startAnimating];
}
@end
