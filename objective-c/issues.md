# 在学习iOS的过程中的疑惑
> [控制器问题](#controlIssue)


+ ### 控制器问题{#controlIssue}
刚开始学习iOS的UIKit框架，不明白控制器和视图之间的关系<br>
比如UIView和UIViewController，UIView本身就可以创建视图了，为什么还需要用UIViewController创建<br>
理解<br>
像string和char的关系一样，char已经可以满足需求了，但是把一些操作char的函数和char封装在一起，功能更强大<br>

+ ### UINavigationBar
一直不知道在哪里设置标题<br>
解决<br>
UINavigationBar只是一个类似view一样的空白，需要往里面添加UINavigationItem,然后设置这个item的title就可以了<br>
