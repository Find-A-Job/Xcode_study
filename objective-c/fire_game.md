# 火纹游戏编写-随笔

+ 进度
```
20190805之前：
1.绘制了背景地图
2.绘制了虚拟按钮
3.绘制了光标
4.绘制了地图上的人物
5.实现了简单的两点路径（根据给定的两个点，绘制一条由起点到终点的箭头）
6.实现了移动范围指示器（根据起点和给定长度，绘制以起点为原点的菱形方块）
7.
20190805:
暂停当前进度，改为先实现攻击动画
在转到攻击动画场景时，有一个遮罩动画，一开始中间透明（透明框的尺寸和整个屏幕一样大，且锚点也在他的中心点），
然后透明区域逐渐缩小（沿屏幕中心点缩放），没有被这个（不透明）区域遮挡的地方会显示为地图
（被破坏的东西或玩家放置在地图上的障碍物也会显示），且人物和状态栏、光标等会被遮盖
20190806:
战斗动画简单实现完，战斗场景细节还没有完善，缺少场景素材，所以决定暂停动画进度

```

+ 一些参数
```
每个方块单位占16x16像素
iPhone6展示尺寸640x320
iPhone6的尺寸是667x375，不足的部分用边框遮挡住了

层级zPosition，
-----1，在spritekit中，不管你在哪个节点下，zposition都是一视同仁，并且按照zposition的值排列，
        这个观点是错误的
-----2，假设某个节点的zposition是10，他有一个子节点的zposition是9，那么这个子节点会被其父节点遮挡，
        这个例子是错误的
-----3，若节点A（zposition=10）和节点B（zposition=20）各有若干个子节点，分别是节点AC（zposition=21），
        AC2（zposition=22），节点BC（zposition=19），BC2（zposition=22），
        则其排列如下（0， A， AC， AC2， B， BC， BC2， 99），也就是说，
        1.节点的z轴位置取决于父节点的z轴位置，
        2.同一个父节点下的节点才有比较的意义，
        这个例子是错误的
-----4，节点按z序，从小到大排列，值越小越容易被遮挡，值越大越不容易被遮挡，节点A的子节点a，
        其zposition会以A的zposition为基础再加上a本身的zposition，最终所有的节点都可以进行比较，
        也就是说，子节点有可能被父节点遮挡，z序大的节点可能被z序小的节点的子节点所遮挡（zposition可以为负数）
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

---选中状态下army：8
--默认状态下army：7
--移动路径：5
--地图遮盖物：3
* --地图：1
-地图层：0-19

*号前缀表示弃用

层级问题
1.地图是z轴最底层
2.人物的默认层级在箭头层级下，但是选中状态下的人物层级会在箭头层级上

```


+ 使用的技术
```
数据和ui分离
先把绘图所需的数据计算完成，再进行ui界面绘制，使其两者分离，代码美观简洁
```
```
//--显示node数量和FPS--
SKView *sv;
sv.showsFPS= YES;
sv.showNodeCount= YES;

//--去多点触控--
SKScene *ss;
ss.view.multipleTouchEnabled= NO;

//UIImage是不可变对象，一旦创建就无法修改属性，所以是线程安全的thread-safe

//--利用【绘图设备】裁剪缩放图形--
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

//--sklabelnode--
默认anchor在(0.5, 0)， 也就是中下的位置;


//--翻转图片--
[UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:UIImageOrientationLeftMirrored];
如果需要一个对原图进行放大并翻转，请先翻转再放大。最后一个参数决定是否翻转（参数可以设置为水平翻转，垂直翻转，旋转）
UIImageOrientationUpMirrored是水平翻转,例：qp

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
情景：有多个sprite节点，它们都执行一组类似的三帧动画，创建时，播放速度和播放的进度都一致（同一时间播放第一帧，然后同时播放第二帧，然后第三帧，然后重复），
当某个sprite节点被选中时，这个节点会播放另一组动作，当取消选中时，会播放之前的动画（也就是未被选中时的动画），
这时，这个重新执行的动画，会跟其他的sprite节点动作不一致（不是速度不一致，而是不同步）.
举个例子，两个人1000m跑，出发地点和跑步速度都一致，也就是齐头并进，这时其中一个人（A）被叫去做其他事，被迫暂停，另一个人（B）没有停下而是继续跑步。过了一会儿，A处理完事情回来跑步，依然从起点出发，跑步速度和之前一样。
现在的情况是，
1.A和B不在一个点
2.B恰巧跑完一圈也在起点，A和B在一起
第一种情况就是我现在的问题，两个人不再同步，虽然跑步速度没变，但是不整齐了（没有并排跑）
第二种情况是期望的结果，但是比较难达到
那么如何在不改动B的情况下，使A和B能并排跑呢???

解决方案一：
当A回归时，从B的当前位置开始跑
（放到sprite里来说，获取当前的图片帧（应该怎样获取呢？暂时想不到））
解决方案二：
当A被叫去办事时，委托另一个人帮忙去办，自己继续跑步，办完事情的时候回来通知一声
（放到sprite里来说，创建一个sprite副本，原sprite继续执行动画，并设置为hide，副本sprite执行新的动画，并覆盖在原sprite的位置，
等副本sprite结束动作后，再将副本sprite设置为hide，将原sprite设置为show）
这个方案只适合一开始就创建好了所有的sprite，对于中途添加进来的sprite就无效
解决方案三：
是方案一的一种实现，根据跑步的时间和跑步的速度来计算B当前的位置，然后A从该位置开跑
（记录开始播放的时间，和播放速度。但如果是缓动动作呢？如果因性能问题导致计算时卡了0.1s呢？计算出的结果还精确吗？）



```

+ 推翻重写
```
第一次推翻
原因：各个节点之间关系错综复杂，看着很乱

20190729,第二次推翻
原因：节点都继承自object，仔细思考后觉得继承自SKSpriteNode比较好，直接在之前的版本上修改太累了，而且重写一遍可以再理整理一下思路
```
<br>
<br>
