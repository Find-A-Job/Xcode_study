### UITableView
+ 自定义cell,重写tableViewCell后，利用tag来调用自己在cell上新添加的控件，其中myCell是继承自UITableViewCell的自定义子类，并重写了initWithStyle方法
```
//遵守UITableViewDelegate协议的*.m文件
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
 
    if(!cell)
    {
        cell=[[myCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"MyIdentifier"];
    }
    UILabel *label;
    label = (UILabel *)[cell viewWithTag:1];
    label.text = [NSString stringWithFormat:@"%d", indexPath.row];
 
    label = (UILabel *)[cell viewWithTag:2];
    label.text = [NSString stringWithFormat:@"%d", NUMBER_OF_ROWS - indexPath.row];
 
    return cell;
}
```
+ 刷新tableView
```
[self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
```
+ 设置代理,代理未执行时注意检测是否赋值对应协议
```
//UITableView需要遵守的协议是UITableViewDelegate和UITableViewDataSource
//ViewController.m文件
...
UITableView *a=[[UITable alloc] init];
a.delegate=self;
a.datasource=self;
[self.view addSubview:a];
...
```
### UIScrollViewDelegate代理
+ 完全停止
```
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
```
+ 手指离开屏幕
```
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
```
### UIColor
+ 通过rgb取色
```
[self.view setBackgroundColor:[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0f]];
```
