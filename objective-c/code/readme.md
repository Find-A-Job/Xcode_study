## 介绍
+ helptofind是我自己用OC写的iOS程序
```
不足之处：不同分辨率的适配有问题，不能自适应
值得夸奖的地方：第一次写的OC程序
```

+ 20190617是基本完成的版本
```
不足之处：
1.自适应仍然没有解决
2.‘+’号按钮uiview动画，使用tag手势来处理动画，但是当页面中有uibutton时，tag手势的优先级却比btn的优先级低

值得夸奖的地方：
1.使用了uiview动画
2.使用了nsnotificationcenter消息通知
3.使用了hittest，做超出父视图的控件响应
4.使用了delegate代理
5.使用了KVC，key-value-code，来在运行时替换值（中心思想就是可以修改readonly属性的值）
6.使用了nsuserdefaults，偏好设置来进行数据持久化
7.使用了nsthread来进行多线程操作，具体就是开启新线程来进行网络访问，避免因网络延迟导致的ui卡顿
8.使用了[[uiapplication sharedapplication] openurl:[nsurl urlwithstring:@""] options:@{} completionhandler:nil]调用系统功能。如：拨打电话，发送短信
9.使用controller控制类进行视图跳转，有navigatecontroller的pushviewcontroller和任意controller的presentviewcontroller
10.使用了oc原生的网络请求类nsurlsession，进行http通讯(post)
11.自定义uitableviewcell
12.使用了uiimagepickercontroller来访问本地相册
13.实现了一个简易版的droplist，其中涉及到uitableview和hittest
14.使用了uialertcontroller进行弹窗告警
创新的设置图片缓存机制，使[[[uiimage imagewithdata] datawithurl] urlwithstring@""]下载的图片保存，不必每次都发起网络请求
```
