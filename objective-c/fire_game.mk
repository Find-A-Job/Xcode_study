# 火纹游戏编写-随笔<br>
<br>
<br>
+ 一些参数<br>
```
每个方块单位占15x15像素
iPhone6展示尺寸640x320
iPhone6的尺寸是667x375，不足的部分用边框遮挡住了
```
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
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
```
<br>
<br>
<br>
+ 碰到的问题
```
//关于node.position
//[SKAction moveBy:CGVectorMake(0, 100) druation:0.1f]
//node执行完这个动作后，position会变化，这个变化在模拟器和真机上的结果不一致
//模拟器上，position会整数增加
//真机上，position会出现小数
//这时候采取的策略是，每次执行完动画，对position进行取整
CGPoint newPoint    = node.position;
newPoint.x          = (int)node.position.x;
newPoint.y          = (int)node.position.y;
node.position       = newPoint;
```
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>