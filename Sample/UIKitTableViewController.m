//
//  UIKitTableViewController.m
//  Sample
//
//  Created by horsley on 2017/8/2.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "UIKitTableViewController.h"
#import "FakeDataSource.h"
#import "ASDKViewController.h"

@interface UIKitTableViewController ()
@property (nonatomic) FakeDataSource *dataSource;
@property (nonatomic) BOOL loading;
@end

@implementation UIKitTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  _dataSource = [FakeDataSource new];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"try ASTableView"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(pushASDKTableView)];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)pushASDKTableView {
  [self.navigationController pushViewController:[ASDKViewController new] animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  dispatch_async(dispatch_get_main_queue(), ^{ //有navigation的时候 如果不dispatch到下一次执行 将不能滚动到最底
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_dataSource.count - 1 inSection:1]
                          atScrollPosition:UITableViewScrollPositionBottom animated:NO];
  });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return section == 0 ? 1 : _dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReuseID"];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReuseID"];
  }
  
  if (indexPath.section == 0) {
    cell.textLabel.text = @"loading...";
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
  } else {
    NSNumber *data = [_dataSource objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.text = [NSString stringWithFormat:@"%@", data];
  }
  // Configure the cell...
  
  return cell;
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
  
  
  
  CGFloat bottomOffset = self.tableView.contentSize.height - self.tableView.contentOffset.y;
  [UIView setAnimationsEnabled:NO];
  [self.tableView beginUpdates];
  [self.tableView insertRowsAtIndexPaths:idps withRowAnimation:UITableViewRowAnimationNone];
  
  [self.tableView endUpdates];
  dispatch_async(dispatch_get_main_queue(), ^{ //如果不dispatch到下一次，contentSize还是老的
    self.tableView.contentOffset = CGPointMake(0, self.tableView.contentSize.height - bottomOffset);
    
    [UIView setAnimationsEnabled:YES];
    
    _loading = NO;
  });
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
