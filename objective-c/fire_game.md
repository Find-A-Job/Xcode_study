# 火纹游戏编写-随笔


+ 一些参数
```
每个方块单位占16x16像素
iPhone6展示尺寸640x320
iPhone6的尺寸是667x375，不足的部分用边框遮挡住了

层级zPosition，
-----1，在spritekit中，不管你在哪个节点下，zposition都是一视同仁，并且按照zposition的值排列，这个观点是错误的
-----2，假设某个节点的zposition是10，他有一个子节点的zposition是9，那么这个子节点会被其父节点遮挡，这个例子是错误的
-----3，若节点A（zposition=10）和节点B（zposition=20）各有若干个子节点，分别是节点AC（zposition=21），AC2（zposition=22），节点BC（zposition=19），BC2（zposition=22），则其排列如下（0， A， AC， AC2， B， BC， BC2， 99），也就是说，1.节点的z轴位置取决于父节点的z轴位置，2.同一个父节点下的节点才有比较的意义
-----还没有透彻理解zposition（和node层级之间）的规则
虚拟按键：99
人物信息状态栏：88
地形信息状态栏：88
系统菜单：88
人物行动列表菜单：88
物品菜单：88
光标：87
人物（待机，活动状态）：
人物（待机，灰态）：
人物（被选中时）：
人物（移动时）：
移动范围指示框：05
地图上的遮盖物：02
地图：01

--
-虚拟按键层：90-99

--
-状态栏层：80-89

--
-菜单层：70-79

--光标:61
-光标层：60-69

--army：7
--移动路径：5
--地图遮盖物：3
--地图：1
-地图层：0-19


```


+ 使用的技术
```
//利用【绘图设备】裁剪缩放图形
+(UIImage *)chippingImage:(UIImage *)img byRect:(CGRect)r
{
    //获取【绘图设备】，带选项（绘图设备尺寸，是否有不透明度，缩放），具体看apple文档
    UIGraphicsBeginImageContextWithOptions(r.size, NO, 0.0f);
    
    //绘制裁剪区域，并使用addClip进行裁剪
    UIBezierPath *path=[UIBezierPath bezierPathWithRect:r];
    [path addClip];
    
    //将img的对应点绘制到【绘图设备】上
    [img drawAtPoint:CGPointZero];
    
    //从当前【绘图设备】获取图形
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    
    //结束【绘图设备】使用
    UIGraphicsEndImageContext();
    
    return newImage;
}
+(UIImage *)scaleImage:(UIImage *)img scaleFactor:(CGFloat)f
{
    //开启【设备上下文】
    CGSize *newSize=CGSizeMake(img.size.width * f, img.size.height * f);
    UIGraphicsBeginImageContext(newSize);
    
    [img drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

//SKSpriteNode九宫格拉伸
-------------------------
|       |       |       |
|       |       |       |
h------------------------
|       |       |       |
|       |       |       |
y------------------------
|       |       |       |
|       |       |       |
A-------x-------w--------


SKSpriteNode *ssn= [SKSpriteNode spriteWithImageName:@""];
ssn.centerRect= CGRectMake(a, b, c, d);
上图A(0, 0)是原点,a是(A到x的距离)/原图片宽， b是(A到y的距离)/原图片高， c是(x到w的距离)/原图片宽， d是(y到h的距离)/原图片高

//sklabelnode
默认anchor在(0.5, 0)， 也就是中下的位置;
```

+ 碰到的问题
```
//关于node.position
[SKAction moveBy:CGVectorMake(0, 100) druation:0.1f]
//node执行完这个动作后，position会变化，这个变化在模拟器和真机上的结果不一致
//模拟器上，position会整数增加
//真机上，position会出现小数
//这时候采取的策略是，每次执行完动画，对position进行取整
CGPoint newPoint    = node.position;//1
newPoint.x          = (int)node.position.x;//2
newPoint.y          = (int)node.position.y;//3
node.position       = newPoint;//4

//但是步骤4好像不会执行，需要放在action里执行，但又会导致异步执行步骤4，达不到立即改变position的目的，所以改用以下method
[SKAction moveTo:CGPoint(node.position.x, node.position.y + 100) druation:0.1f]
```

+ 等待解决的问题
```
20190716
精灵图片在未被选中时会播放待机的动画，选中时会播放被选择的动画。
这时如果有多个这样的精灵，当其中一个精灵被选中然后再取消选中时，其他的精灵会和这个精灵播放的待机动画不同步，
需要让他们无论何时，播放的待机动画都是同步的

```
<br>
<br>
