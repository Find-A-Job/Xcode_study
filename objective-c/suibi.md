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

//设置分割线长度，颜色
table.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);//上，左，下，右，都是正数
table.separatorColor=[UIColor blueColor];

// 这句话在单元格的最后显示一个箭头
cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

//--- 点击cell的时候 cell不会产生高亮状态 ---
cell.selectionStyle = UITableViewCellSelectionStyleNone;

//设置cell背景透明
cell.backgroundColor=[UIColor clearColor];

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
//用hidesBottomBarWhenPushed属性设置隐藏tabbar
n.hidesBottomBarWhenPushed = YES;

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
### UIScrollView
+ 当有一部分被遮挡，滑不出来的时候，试试增加额外滚动区域
```
// 增加额外的滚动区域（逆时针，上、左、下、右）
// top  left  bottom  right
scrollView.contentInset = UIEdgeInsetsMake(20, 20, 20, 20);
```
### UITextfield
+ 键盘， 键盘上面有个放候选字的框，高度未知（暂时没找到相关的解释， 试了一下差不多是64）
```
//键盘事件
-(void)keyboardUp:(NSNotification *)sender;
-(void)keyboardDown:(NSNotification *)sender;

//注册键盘事件进行监听
//keyboardUp:和keyboardDown:是自定义的函数
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardUp:) name:UIKeyboardWillShowNotification object:nil];
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDown:) name:UIKeyboardWillHideNotification object:nil];

//键盘弹起时，获取键盘高度，调整textfiled高度， 显示
//self.tfEditBox是个UITextfield类型控件
-(void)keyboardUp:(NSNotification *)sender{
    NSValue *keyboard=[(NSDictionary *)[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    if ([sender.name isEqualToString:UIKeyboardWillShowNotification]) {
        CGRect keyboardRect=[keyboard CGRectValue];
        [self.tfEditBox setCenter:CGPointMake(keyboardRect.size.width/2.0f, keyboardRect.origin.y-self.tfEditBox.bounds.size.height/2.0f-64)];
    }
}
```
+ 限制输入框
```
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL result=YES;
    NSLog(@"editField:%@", string);
    if(textField.tag == 302){//设置了该框的tag，便于识别是哪个框
        //超过11位，则限制
        unsigned long oldStringLength=(unsigned long)textField.text.length;
        unsigned long newStringLength=(unsigned long)string.length;

        NSLog(@"oldStringLength:%lu, newStringLength:%lu", oldStringLength, newStringLength);//使用apple自带的复制粘贴，会比你复制的字符长度多1，比如复制“12”，则会变成“ 12”
        if (newStringLength <= 0) {
            //允许删除操作
            return YES;
        }
        if ((oldStringLength + newStringLength) > 11) {
            NSLog(@"超过最大长度");
            return NO;
        }
        

        
        //旧方案
//        NSCharacterSet *temSet=[NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
//        for (int i=0; i<string.length; ++i) {
//            NSString *s=[string substringWithRange:NSMakeRange(i, 1)];
//            NSRange r=[s rangeOfCharacterFromSet:temSet];
//            if(r.length == 0){
//                result=NO;
//                break;
//            }
//        }
        
        //方案一,一个一个比较
//        NSString *targetString=@"0123456789";
//        for (int i=0; i<string.length; ++i) {
//            NSString *oneWord=[string substringWithRange:NSMakeRange(i, 1)];
//            if (![targetString  containsString:oneWord]) {
//                result=NO;
//            }
//        }
        
        //方案二,characterset
        NSCharacterSet *digitSet=[NSCharacterSet decimalDigitCharacterSet];
        NSArray *stringArr=[string componentsSeparatedByCharactersInSet:digitSet];
        NSString *finishString=[stringArr componentsJoinedByString:@""];
        NSLog(@"finishString: %@", finishString);
        if (finishString.length != 0 || ![finishString isEqualToString:@""]) {
            NSLog(@"输入的内容是非数字字符");
            result=NO;
        }
    }
    
    return result;
}
```
+ 设置输入框为密码模式
```
//设置完成后，键盘会自动限制为只能输入数字·字母·特殊字符，输入的字符在展示的时候会用圆点代替
UITextField *ut=[[UITextField alloc] init];
ut.secureTextEntry=YES;
```
### UISearchBar
+ 搜索框，很容易发生被状态栏和导航栏遮挡的问题，要注意position
```
UISearchBar *search=[[UISearch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
[search setSearchBarStyle:UISearchBarStyleMinimal];//背景透明
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
### UIScrollView
+ 滚动条
```
[self setShowsVerticalScrollIndicator:NO];//隐藏右侧滚动条
[self setShowsHorizontalScrollIndicator:NO];//隐藏底侧滚动条
```
### UIImage
+ 设置图片9宫格拉伸stretchableImageWithLeftCapWidth
```
//两个参数用来指定不需要拉伸的边缘范围
UIView *bkView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 667)];
UIImage *uimg=[UIImage imageNamed:@"xiaoxikuang.png"];
uimg=[uimg stretchableImageWithLeftCapWidth:uimg.size.width*0.3 topCapHeight:uimg.size.height*0.3]; 
UIImageView *bkImgView=[[UIImageView alloc] initWithFrame:bkView.bounds];
bkImgView.image=uimg;
[bkView addSubview:bkImgView];
//参考自：https://blog.csdn.net/zsk_zane/article/details/46915931
```
### 强大的UIApplication
+ 
```
//设置icon上的数字 ,iOS 8之后需要注册‘推送功能’
[UIApplication sharedApplication].applicationIconBadgeNumber = 4; 

//设置摇动手势的时候，是否支持redo,undo操作 
[UIApplication sharedApplication].applicationSupportsShakeToEdit =YES; 

//判断程序运行状态 
/* UIApplicationStateActive UIApplicationStateInactive UIApplicationStateBackground */ 
if([UIApplication sharedApplication].applicationState ==UIApplicationStateInactive)
{ NSLog(@"程序在运行状态"); } 

//阻止屏幕变暗进入休眠状态 
[UIApplication sharedApplication].idleTimerDisabled =YES; 

//显示联网状态 
[UIApplication sharedApplication].networkActivityIndicatorVisible =YES; 

//在map上显示一个地址，其实就是利用了openURL这个方法 
NSString* addressText =@"1 Infinite Loop, Cupertino, CA 95014"; 
// URL encode the spaces 
addressText = [addressText stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]; 
NSString* urlText = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", addressText]; 
[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]]; 

//发送电子邮件，也是利用openURL 
NSString *recipients =@"mailto:first@example.com?cc=second@example.com,third@example.com&subject=Hello from California!";
NSString *body =@"&body=It is raining in sunny California!";
NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body]; 
email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
[[UIApplication sharedApplication] openURL:[NSURLURLWithString:email]]; 

//打电话到一个号码，依然是利用openURL 
// Call Google 411 
[[UIApplication sharedApplication] openURL:[NSURLURLWithString:@"tel://8004664411"]]; 

//发送短信，万能的openURL啊 
// Text to Google SMS 
[[UIApplication sharedApplication] openURL:[NSURLURLWithString:@"sms://466453"]]; 

//打开一个网址，openURL的常规操作 
// Lanuch any iPhone developers fav site 
[[UIApplication sharedApplication] openURL:[NSURLURLWithString:@"http://itunesconnect.apple.com"]];
--------------------- 
原文：https://blog.csdn.net/youshaoduo/article/details/86645502 
```
### e
+ hittest
```
//子视图的frame超出父视图frame，子视图会显示，但无法接收响应

// 在view中重写以下方法，其中self.button就是那个希望被触发点击事件的按钮
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    
    //超出父视图范围，会返回nil，捕捉这个返回值
    if (view == nil) {
        // 转换坐标系
        CGPoint newPoint = [self.button convertPoint:point fromView:self];
        // 判断触摸点是否在button上
        if (CGRectContainsPoint(self.button.bounds, newPoint)) {
            view = self.deleteButton;
        }
    }
    return view;
}

```
### 访问本地
+ 访问相册
```
//从本地相册选择图片
//遵守UIImagePickerControllerDelegate, UINavigationControllerDelegate协议
-(void)chooseImgClick:(id)sender{
    //访问相册
    
    NSUInteger sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    UIImagePickerController *imgPicker=[[UIImagePickerController alloc] init];
    imgPicker.sourceType=sourceType;
    imgPicker.delegate=self;//协议代理
    
    [self presentViewController:imgPicker animated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //取消时
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    NSLog(@"选择图片");
    
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    [self.imgBtn setBackgroundImage:image forState:UIControlStateNormal];//imgBtn是一个按钮
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

```
### 随意粘贴
+ 属性
```
[sortType setTitleTextAttributes:[[NSDictionary alloc] initWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
```
+ 标签警示
```
//条目分段（xcode编辑器上方文件目录，最后一个条目，点击一下会显示，不知道怎么称呼，暂称为条目）
#pragma mark - UITableViewDataSources
//条目不分段
#pragma mark  UITableViewDataSources

//警告
#warning "msg"
```
+ hittest
```

//参考https://www.linuxidc.com/Linux/2015-08/121270.htm
#pragma mark - hittest

//还需要传递给子视图时，return [popView hitTest:popViewPoint withEvent:event];
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if (self.isHidden == NO) {
        
        UIView *popView=(UIView *)[self viewWithTag:222];
        
        CGPoint newPoint = [self convertPoint:point toView:self.centerBtn];
        CGPoint popViewPoint = [self convertPoint:point toView:popView];
        
        if ( [self.centerBtn pointInside:newPoint withEvent:event]) {
            return self.centerBtn;
        }
        else if ([popView pointInside:popViewPoint withEvent:event])
        {
            return [popView hitTest:popViewPoint withEvent:event];
        }
        else{
            
            return [super hitTest:point withEvent:event];
        }
    }
    
    else {
        return [super hitTest:point withEvent:event];
    }
}

//最终返回值是某个视图
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if (self.isHidden == NO) {
        UIView *fbswView=(UIView *)[self viewWithTag:45];
        UIView *fbzlView=(UIView *)[self viewWithTag:46];


        CGPoint fbswPoint = [self convertPoint:point toView:fbswView];
        CGPoint fbzlPoint = [self convertPoint:point toView:fbzlView];


        if ( [fbswView pointInside:fbswPoint withEvent:event]) {
            return fbswView;
        }
        else if ( [fbzlView pointInside:fbzlPoint withEvent:event]) {
            return fbzlView;
        }
        else{


            return [super hitTest:point withEvent:event];
        }
    }


    else {
        return [super hitTest:point withEvent:event];
    }
}
```
+ 遮罩
```
//在任何视图下执行这个，添加视图到Z轴最顶层,maksView
UIView *maksView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
maksView.backgroundColor = [UIColor blackColor];
maksView.alpha = 0.6;
[[UIApplication sharedApplication].keyWindow addSubview:maskView];
```
+ 判断 点位置，尺寸大小，矩形大小，点与矩形的位置
```
// 1.判断两个点的位置是否相等
    BOOL pointIsEqual = CGPointEqualToPoint(CGPointMake(50, 100), CGPointMake(100, 50));
    NSLog(@"%d",pointIsEqual);
    
    // 2.判断尺寸大小是否相等
    BOOL sizeIsEqual = CGSizeEqualToSize(CGSizeMake(50, 100), CGSizeMake(50, 100));
    NSLog(@"%d",sizeIsEqual);
    
    
    // 第一种写法：坐标为(20,20)宽高分别为50和100
    CGRect rect1 = {{20,50},{50,100}};
    // 第二种写法：坐标为(20,20)宽高分别为50和100
    NSPoint point = CGPointMake(20, 20);
    NSSize size = CGSizeMake(50, 100);
    CGRect rect2  = {point,size};
    
    
    // 3.判断两个矩形是否相等
    BOOL rectIsEqual = CGRectEqualToRect(rect1, rect2);
    NSLog(@"%d",rectIsEqual);
    
    
    // 4.判断一个点是否在矩形上面
    BOOL isContent = CGRectContainsPoint(rect1, CGPointMake(20, 50));
    NSLog(@"%d",isContent);
```
+ 字符操作
```
    //////////////////////////////////////////////////////begin
    
    NSString *longString=@"今天我们来学习NSCharacterSet我们快乐";
    
    //自己一个一个筛选
    NSString *se=@"今我s";
    NSMutableString *muString=[[NSMutableString alloc] init];
    for (int i=0; i<longString.length; ++i) {
        NSString *temp=[longString substringWithRange:NSMakeRange(i, 1)];//取出一个字符
        if (![se containsString:temp]) {//判断是否包含关系
            [muString appendString:temp];
        }
        [se containsString:se];
    }
    NSLog(@"完成后:%@", muString);
    //完成后:天们来学习NSCharacterSet们快乐
    
    //用characterset
    NSCharacterSet *cs=[NSCharacterSet characterSetWithCharactersInString:@"今我s"];//分离标准，分离条件
    NSArray *arr23=[longString componentsSeparatedByCharactersInSet:cs];//分离器，分离字符。分离后的数组，其中的分离规律暂不清楚
    NSString *ressss=[arr23 componentsJoinedByString:@""];//替换，或者说拼接
    NSLog(@"完成后:%@", ressss);
    //完成后:天们来学习NSCharacterSet们快乐
    
    //////////////////////////////////////////////////////end
```

