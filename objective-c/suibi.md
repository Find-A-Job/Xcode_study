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
+ tableView常用操作
```
//刷新tableView
[self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];

//这句话不显示多余的单元格
self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

// 这句话不显示单元格之间的分割线
_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

// 这句话在单元格的最后显示一个箭头
cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

//--- 点击cell的时候 cell不会产生高亮状态 ---
cell.selectionStyle = UITableViewCellSelectionStyleNone;

// --- 写在viewdidload里面cell自适应高度 ----
tableView.rowHeight = UITableViewAutomaticDimension; // 自适应单元格高度
tableView.estimatedRowHeight = 50; //先估计一个高度

// 去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

// 获取手势点击的是哪一个cell的坐标
NSIndexPath *indexPath = [self.tableView indexPathForCell:((UITableViewCell *)longPress.view)];

// 局部刷新
//一个section刷新    
NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];    
[tableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];    

//一个cell刷新   
NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];   
[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone]; 

// 关于UITableView如何跳转到最后一行或者任意指定行。
其实现如下：
[self.chatTableView scrollToRowAtIndexPath:
[NSIndexPath indexPathForRow:[self.chatArray count]-1 inSection:0] atScrollPosition: UITableViewScrollPositionBottom animated:NO];

// 点击button时获取button所在的cell的indexpath
UIButton *button = sender;
HeroDermaTableViewCell *cell = (HeroDermaTableViewCell *)[[button superview] superview];
NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
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
//如果从A跳转到B，那么
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
### UINavigationController
+ 跳转发生在控制器之间，只有控制器可以进行跳转，view想要达到跳转效果只能用addSubvie进行遮盖--延伸思考，视图切换就是控制器之间的切换
```
//
//1--当前页面要是想使用pushViewController，那必须以UINavigationController类型进入当前页面(view)
//2--pushViewController跳转的前提条件是，当前的controller必须是UINavigationController
//解释一下1和2，假设当前主页面是UITabbarController,其中一个tab是UITableViewControl
//先将UITabbarController加入根视图控制器
UITabbarController *utc=[[UITabbarController alloc] init];
self.window.rootViewController = utc;
//接着将UITableViewControl包装成UINavigationController
UITableViewControl *table=[[UITableViewControl alloc] init];
UINavigationController *unc=[[UINavigationController alloc] initWithRootViewController:table];
unc.tabBarItem.title=@"123";//标签标题
UITableViewControl *table2=[[UITableViewControl alloc] init];
table2.tabBarItem.title=@"234";
...
utc.viewControllers=@[unc, table2];//①
...
//①的位置是重点，table和table2做对比
//table:将UINavigationController类型的控制器加入，后续则可以使用pushViewController来跳转
//tbale2:加入的不是UINavigationController类型，后续操作哪怕是再使用
//UINavigationController *unc=[[UINavigationController alloc] initWithRootViewController:self];
//或者UINavigationController *unc=[[UINavigationController alloc] initWithRootViewController:table2];
//都是不可以使用pushViewController来跳转

//跳转代码,anotherController是其他类型的控制器，只要目标是控制器类型都可以完成跳转
[self.navigationController pushViewController:anotherController animated:true];

//使用模态跳转这一步和utc.viewControllers=@[unc, table2]是一个意思
//目标控制器是navigationController，那跳转后的这个页面就可以使用pushViewController
[self presentViewController:unc animated:YES completion:nil];
```
+ 属性设置
```
//导航栏中间的title
[self.navigationItem setTitle:@""];
//左按钮
UIBarButtonItem *leftButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:nil];
[self.navigationItem setLeftBarButtonItem:leftButton];
//背景色,如果发现没有效果，那就‘在哪里创建了UINavagationController,就在哪里设置’
[self.navigationBar setBarTintColor:[UIColor blackColor]];
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
### 网络
+ NSURLSession,默认会话实现get
```
//url地址
NSString *url=@"";
//进行URL编码
url=[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//创建会话对象
NSURLRequest *request=[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
//创建默认会话对象
NSURLSession *session=[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
//获得数据任务
NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
    //响应头在response中
    //响应体（响应数据）在data中
    //如果JSON之类的数据就需要转码
    //[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments]
    if(!error)
    {
        //未发生错误
    }
}];
//任务创建完成后默认是不执行的，需要显式调用执行任务
[task resume]
```
+ 从网络获取图片资源
```
[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@""]]];
```
