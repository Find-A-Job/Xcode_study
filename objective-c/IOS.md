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

<pre>
1、frame----------控件的位置和尺寸（以父控件的左上角为坐标原点（0,0）） 
2、center---------控件的中点（以父控件的左上角为坐标原点）
3、bounds---------控件的位置和尺寸（以自己的左上角为坐标原点（0,0））
4、transform------形变属性（旋转角度，缩放比例）
5、backgroundColor背景颜色
6、tag------------标识（父控件可以对应相应的标识找到子控件，同一父控件的子控件不要使用相同tag）
7、alpha----------透明度（0~1）
8、opaque---------不透明度（0~1）
9、superView------父控件
10、subviews------子控件
11、contendMode---内容显示的模式，拉伸自适应
12、hidden--------是否隐藏（YES、NO）
</pre>
