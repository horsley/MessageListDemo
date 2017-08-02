//
//  ASDKViewController.m
//  Sample
//
//  Copyright (c) 2014-present, Facebook, Inc.  All rights reserved.
//  This source code is licensed under the BSD-style license found in the
//  LICENSE file in the root directory of this source tree. An additional grant
//  of patent rights can be found in the PATENTS file in the same directory.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
//  FACEBOOK BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
//  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "ASDKViewController.h"

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <AsyncDisplayKit/ASAssert.h>
#import "LoadingCellNode.h"
#import "FakeDataSource.h"
#import "UIKitTableViewController.h"

typedef enum : NSUInteger {
  ReloadData,
  ReloadRows,
  ReloadSections,
  ReloadTypeMax
} ReloadType;

@interface ASDKViewController () <ASTableDelegate, ASTableDataSource>
@property (nonatomic) ASTableNode *tableView;
@property (nonatomic) FakeDataSource *dataSource;

@property (nonatomic) BOOL loading;
@end


@implementation ASDKViewController

- (instancetype)init
{
  if (!(self = [super init]))
    return nil;

  _tableView = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
  _tableView.dataSource = self;
  _tableView.delegate = self;
  
  _dataSource = [FakeDataSource new];
  
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  _tableView.frame = self.view.bounds;
  [self.view addSubnode:_tableView];
  //self.view.layer.speed = 0.1f;
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"try UITableView"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(pushUIKitTableView)];
}

- (void)viewWillAppear:(BOOL)animated {
  
}

- (void)viewWillLayoutSubviews
{
  [_tableView.view layoutIfNeeded];
  [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_dataSource.count - 1 inSection:1]
                    atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}


- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  //[self thrashTableView];
}

- (void)pushUIKitTableView {
  [self.navigationController pushViewController:[UIKitTableViewController new] animated:YES];
}


- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode
{
  return 2;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section
{
  return section == 0 ? 1 : _dataSource.count;
}

- (ASCellNode *)tableNode:(ASTableNode *)tableNode nodeForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section == 0) {
    return [LoadingCellNode new];
  } else {
    ASTextCellNode *textCellNode = [ASTextCellNode new];
    NSNumber *data = [_dataSource objectAtIndex:indexPath.row];
    textCellNode.text = [NSString stringWithFormat:@"%@", data];
    
    return textCellNode;
  }
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  [self scrollViewDidEndDragging:scrollView willDecelerate:NO];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  if (decelerate) {
    return;
  }
  if (scrollView.contentOffset.y > 20) {
    return;
  }
  if (_loading) {
    return;
  }
  _loading = YES;
  
  [_dataSource loadMore];
  
  NSMutableArray *idps = [NSMutableArray new];
  for (int i=0; i<PageSize; i++) {
    [idps addObject:[NSIndexPath indexPathForRow:i inSection:1]];
  }
  
  
  
  CGFloat bottomOffset = _tableView.view.contentSize.height - _tableView.view.contentOffset.y;
  [UIView setAnimationsEnabled:NO];
  [_tableView performBatchAnimated:NO updates:^{
    [_tableView insertRowsAtIndexPaths:idps withRowAnimation:UITableViewRowAnimationNone];
    
  } completion:^(BOOL finished) {
    dispatch_async(dispatch_get_main_queue(), ^{ //如果不dispatch到下一次，contentSize还是老的
      _tableView.view.contentOffset = CGPointMake(0, _tableView.view.contentSize.height - bottomOffset);
      
      [UIView setAnimationsEnabled:YES];
      
      _loading = NO;
    });
  }];
}
@end
