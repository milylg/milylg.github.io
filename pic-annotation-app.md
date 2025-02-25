#### 图片标注软件（Android）

某些场景通过图片标注的方式更有利于提高沟通的效率，但这不是我开始这个项目的原因，启动这个小项目的动力来自一张充满艺术感的电子硬件介绍图。我先想做一个能接近这样效果的标注软件，现在只做最基础，最简单的功能接口，等功能接口表现效果接近自己认为理想的状态下，再进行工程优化和功能扩展。

<div><center><img src="pic-annotation-app/pico-addons-13_medium.webp" style="box-shadow:0 0 6px 0 #888;" alt="pico-addons-13_medium"></center></div><br>



一般对图像的处理方面的领域模型基本上相差不多，不管是HTML5还是Android，但是我没有接触过Canvas相关的绘图API，这是这个项目最大的成本来源（时间成本，项目初始需要对Canvas API进行调研和绘图功能的技术验证）。尽管有来自托管网站的开源项目和博客上的代码片段的说明，但是代码所处环境和效果的定制化，大部分代码实现并不能满足工程要求。开发过程中有些有参考意义的代码片段可读性非常差，我想进行一些代码结构上的优化，花费了一个上午和一个夜晚的功夫，不断进行编译调试，直到晚上八点多，才理解了设计意图和部分绘图API的用法后，终于明白它这样设计的意图在解决什么问题，没一会就完成了重构；有时我对一些Canvas API的理解不充分造成时间的巨大浪费。完成一个API的案例探究不会花费太多的工夫，但是将这些功能片段引入到一个代码结构中去，需要考虑到整体结构协调。大概花费了三天的时间基本上完成了一个MVP版本  [SketchBoard](sketch-board.md)

<div style="display:flex;flex-wrap:wrap;justify-content:center;">
<div style="width:320px;"><center><img src="projects/SketchBoard-Alpha.png" style="zoom:40%; box-shadow:0 0 2px 0 #888;" alt="SketchBoard Alpha"></center></div>
<div style="color:orange;width:400px;">






* 绘制图形（矩形，圆形，线段，箭头）
* 绘制文字（阴影，描边，正常）
* 手绘
* 风格配置🎨
  - 形状绘笔（颜色，粗细程度，实线虚线）
  - 文字绘笔（大小，颜色，加粗/正常）
  - 默认配置（风格列表选项）
* 撤销/重做
* 高级效果（放大镜，聚光灯）
* 另存为（标注不应改变源图片）
* 导入图片
* <del>尺寸裁剪</del>

</div>
</div><br>



> ##### 项目演进过程

<div><center><img src="pic-annotation-app/sketchboard-mvp-showcase.gif" style="box-shadow:0 0 4px 0 #888;" alt="sketchboard-mvp-showcase"><img src="pic-annotation-app/sketchboard-sec-showcase.gif" style="box-shadow:0 0 6px 0 #888;" alt="redo-undo-showcase.gif"><img src="pic-annotation-app/sketchboard_style.gif" style="box-shadow:0 0 6px 0 #888;" alt="sketchboard_style.gif"><img src="pic-annotation-app/sketchboard-text-save-import-showcase.gif" style="box-shadow:0 0 6px 0 #888;" alt="sketchboard-text-save-import-showcase.gif"></center></div>

