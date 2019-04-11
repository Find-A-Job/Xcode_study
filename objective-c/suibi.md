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
+ 一个控制器添加至另一个控制器中，同时视图也要相应地加入另一个控制器的视图
```
//*.m
...
//@property(strong, nonatomic) id control1;
//@property(strong, nonatomic) id control2;
...
UIViewController *u=[[UIViewController alloc] init];
UITableViewController *u2=[[UITableViewController alloc] init];
[u addChildViewController:u2];
[u.view addSubview:u2.view];
//如果还是有异常，应考虑一下对控制器赋值给属性进行强引用,避免内存提前释放
//self.control1=u;
//self.control2=u2;
...
```
### view跳转,控制器之间的跳转
+ presentViewController、presentedViewController 、presentingViewController 、dismissViewControllerAnimated
```
//A.presentedViewController      就是B控制器
//B.presentingViewController     就是A控制器
//presentViewController          跳转
//dismissViewControllerAnimated  返回

//*.m
//在UIViewController控制器中
UIViewController *view2=[[UIViewController alloc] init];
[self presentViewController:view2 animated:YES completion:nil]; //跳转到view2视图

//*.m
//view2控制器中
...
//如果这个页面是由A跳转过来的，那么以下语句就会跳回A
[self.presentingViewController dismissViewControllerAnimated:YES completion:nil]; //返回上个视图
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
