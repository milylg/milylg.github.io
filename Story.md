## 项目故事 (Story of Toy Project)

> #### Crazy 游戏程序

本想开发这个游戏当作毕业设计的，这个想法从实习的时候产生的，某天晚上躺在床上想起初中玩的一款游戏------疯狂鼹鼠。游戏很精巧，也很耐玩，不管玩多长时间都玩不腻，每天早上醒来都打开老式摩托罗拉手机（大概2010年左右）开始这个游戏。真的很佩服设计这款游戏的工程师，设计的如此精妙绝伦！我在网上多次尝试获取这款游戏的jar包，但都一无所获。我发现贴吧里也有人同样迷恋这款游戏，这款游戏带给他们一个美好的童年。

<div><center><img src="Story/tieba_crazy.jpg" style="zoom:50%;"><img src="Story/crazy_plus.jpg" style="zoom:60%;"></center></div>

2019年，我初步评估了实现这个项目可能会面对哪些技术上的困难，其中有一个山坡的绘制以及鼹鼠的大炮在山坡上移动的功能在swing上无法实现，尤其是大炮在炮坑毛刺上行驶难有头绪，或者说是实现起来比较困难，android端被我忽视了，当时我没有寻找解决方法，想想还是太麻烦了，放弃作为毕业设计了。

直到2021年5月末，把以前的小行星项目翻出来了，尝试复刻一下crazy游戏，但是事与愿违，我总是避免图像绘制这方面的困扰，因此设计成了现在这个样子。阅读国外大学的课程项目代码，提取出架构图，应用到我自己设计的游戏中。事实上，开发了五天左右，一个简单的演示版本就做出来了，开发完以后，我就对这个项目没有兴趣了，但仍然对这款摩托罗拉的游戏痴迷，我无法制作开发出这样的游戏！

![image-20230904102238627](Story/image-20230904102238627.png)

![image-20230904102503254](Story/image-20230904102503254.png)

<center>Asteroids! - a Java asteroids implementation in OpenGL for Dave Straayer's CS142 class.</center>

<center>
<video width="640" height="480" controls align-items="center;" justify-content="center;">
  <source src="Story/asteroids.mp4" type="video/mp4">
您的浏览器不支持Video标签。
</video></center>

<center>Course Project: Asteroids Show Case</center>








> #### **Audio** 英语听力播放器

开发这个项目的初衷是我发现了一个很适合练习听力的材料，想为这份资源写一个应用程序。我忘记花费多长时间完成这个项目，但我记得应该在疫情封控期间写的。我把之前所接触的MVVM架构在这个项目中实践起来了。

<div><center><img src="Story/IMG_20230808_213133.jpg" style="zoom:12%;"></center></div>

<center>Audio 界面设计草图 </center>



> #### LightEditText 富文本编辑器

在开发这些项目的同时，我也在进行DailyNotes手机应用程序的开发，但是进展非常不顺利，富文本编辑器是Android留的一个大坑，我陷入这个坑太久了，尝试了多个文本编辑器开源项目，都不符合我的期望。我希望编辑器提供简单的风格样式，不必提供多而杂的功能，其实大多数情况下，它们都用不上。记录的第一要义是文本输入，而不是风格呈现。这个项目我花费了太多的时间去尝试和试错，直到它成为现在这样的状态。回顾整个过程，我发现寻找做什么所花费的时间和精力是多于确定方向后把它实现出来的。

<div><center><img src="Story/IMG_20230808_204436.jpg" style="zoom:12%;"></center></div>

<center>添加链接特性 设计草图</center><br><br>



<div><center><img src="Story/Screenshot_20221227-171823.png" style="zoom:60%;"><img src="Story/Screenshot_20221227-223253.png" style="zoom:60%;"></center></div>

<center>新特性尝试：文本中插入图片</center><br><br>

> #### DailyNotes 备忘录项目

让我开始这个项目，是使用了两年半的手机一直停留再开机界面，让我丢失了两年以来所有的记录。送到手机维修店，结果是主板坏了，我感到沮丧，开始了这场漫长的旅程。

<div><center><img src="Story/Screenshot_20220519-225336.png" style="zoom:50%;"><img src="Story/Screenshot_20221026-152055.png" style="zoom:50%;"><img src="Story/Screenshot_20221108-164900.png" style="zoom:50%;"></center></div><br><br>

<center>被丢弃的应用程序 <br>频繁迭代的DailyNotes项目让我感到疲惫不堪，这里仅展示了冰山一角</center><br><br>



2021年9月，尝试使用Android开发备忘录应用程序，好几个不同的界面都没有让我感到满意！曾经多次放弃这个项目，总是在沮丧中寻找继续开发这个项目的意义。空闲的时候搜索更多关于备忘录相关的应用程序，参考它们是如何设计的。我期望界面设计得让自己有记录的冲动，经过长时间多次的修改，我明白功能并不是需要现在全部实现，最好的计划是设计出总体的界面框架，并让每一个功能变得实用和精巧，优化体验感觉，再完善界面和功能特性，接着慢慢添加自己想要的功能特性。

