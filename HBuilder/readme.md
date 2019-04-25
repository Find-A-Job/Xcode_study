# HBuilder
----
### 用HBuilder本地打包后

> + 环境<br>
> iOS开发环境，Mac OS、XCode 7.2以上版本<br>

> + 需要的额外文件<br>
> 下载官示例，HBuilder-Hello（离线打包演示应用）<br>

> + 注意事项<br>
> > 离线打包的项目如果是uni-app 且是自定义组件模式，需要 在离线打包的工程里引入 ：离线sdk包里的liblibWeex.a库 和 weex-main-jsfm.js文件<br>
> uni-app:一个使用 Vue.js 开发跨平台应用的前端框架<br>
> 引入动作是在xcode里‘link lib and framework’进行，liblibWeex.a在离线sdk包的lib文件夹里，weex-main-jsfm.js在离线sdk包的Bundles文件夹里<br>

+ 配置编译工程<br>
从演示应用HBuilder-Hello创建工程<br>
解压SDK包，进入目录HBuilder-Hello, 双击“HBuilder-Hello.xcodeproj”文件打开工程：<br>
(建议不要将工程移出SDK目录，如需移动工程则要重新引入头文件和静态库文件到工程里) <br>
其中Bundle Identifier为苹果的AppID，必须与应用发布是配置的Profile关联的AppID一致；Version为应用版本号，在App Store中显示的版本号，推荐与manifest.json中version下的name值一致；Build为编译版本号，App Store判断升级使用，推荐与manifest.json中version下的code值一致<br>

+ 配置应用名称<br>
在工程导航界面，选择InfoPlist.strings文件，修改CFBundleDisplayName值为应用名字:<br>
InfoPlist.strings(English)为英文系统应用名,Simplified为中文简体系统应用名<br>
打开pandora -> apps 目录，将下面“HelloH5”目录名称修改为应用manifest.json中的id字段值，uni-app项目为manifest.json中的appid字段值（这步非常重要，否则会导致应用无法正常启动），并将所有应用资源拷贝到其下的www目录中 <br>

+ 配置应用信息<br>
打开工程目录下的control.xml文件，修改appid值：<br>
其中appid值为HBuilder应用的appid，必须与应用manifest.json中的id字段值（uni-app项目为manifest.json中的appid字段值）完全一致；appver为应用的版本号，用于应用资源的升级，必须保持与manifest.json中的version -> name值完全一致；version值为应用基座版本号（plus.runtime.innerVersion返回的值），不要随意修改。 <br>

+ 如何关闭广告<br>
5+SDK里默认打开了开屏广告，用户如果不需要开屏广告可在Appdelegate.m文件中注释如下部分，并删除ad库文件,即可关闭广告<br>
```
// 示例默认带开屏广告，如果不需要广告，可注释下面一行,  
#define ENABLEAD  
```

如果需要关闭其他类型的广告可在应用的manifest.json文件中增加如下配置
```
    "plus": {  
        "ads": {  
            "push":"false",       
            "splash":"false",     
            "rp":"false",          
            "spot":"false",       
        }  
    }  
```
说明可参考文档 Manifest.json文档说明 manifest配置ads部分 <br>

> 原文链接http://ask.dcloud.net.cn/article/41<br>
