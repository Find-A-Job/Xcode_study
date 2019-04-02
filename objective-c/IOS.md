## 常用
> + 获取状态栏宽高<br>
> [[UIApplication sharedApplication] statusBarFrame].size.width;<br>
> [[UIApplication sharedApplication] statusBarFrame].size.height;<br>

> + 获取导航栏宽高<br>
> [[self navigationController] navigationBar].frame.size.width;<br>
> [[self navigationController] navigationBar].frame.size.height;<br>

> + 屏幕中央的弹窗<br>
> UIAlertController* alert = 
[UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];<br>
> UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleDefault handler:nil];<br>
> [alert addAction:defaultAction];<br>
> [self presentViewController:alert animated:YES completion:nil];<br>

> + TabBar<br>
> TabBarZmx *tbz=[[TabBarZmx alloc] init];//TabBarZmx是个继承自UITabBarController的自定义类<br>
> tbz.selectedIndex=1;\t\t\t//将默认下标定位在1的位置（从0开始计数）<br>

