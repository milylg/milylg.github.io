> ##### 标注画图板功能列表 `极简版本` `技术验证`

- 绘制图形（矩形，圆形，线段，箭头）
- 绘制文字（阴影，描边，正常）
- 手绘
- 高级效果
  - 放大镜
  - 聚光灯



?>使用须知：①关闭硬件加速。（聚光灯效果运行需要）②暂时继承ImageView, 等功能基本完成后，继承View，并完成相应的scaleType算法；调用invalidate方法时，onDraw重绘方法会被连续执行两次，也是继承类的原因，把继承ImageView改为View即可。



<details>
<summary>程序源码：SketchBoard</summary>

```java
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffXfermode;
import android.graphics.Rect;
import android.text.Layout;
import android.text.StaticLayout;
import android.text.TextPaint;
import android.util.AttributeSet;
import android.util.DisplayMetrics;
import android.view.MotionEvent;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.widget.AppCompatImageView;

import java.io.InputStream;

public class SketchBoard extends AppCompatImageView {

    private static final String TAG = "SketchBoard";
    private final static int DEFAULT_STROKE_WIDTH = 4;
    private final static int DEFAULT_CIRCLE_RADIUS = 80;
    private final static float POINT_CIRCLE_RADIUS = 2.5f;
    private final static double TRIANGLE_HEIGHT = 10;
    private final static double TRIANGLE_BASE_SIDE_HALF = 6;
    private final static float ZOOM_IN_RATE = 2f;
    private final static float MAGNIFIER_RADIUS = 80f;

    // TextPaint继承自Paint，也可以用于绘制形状。
    private final TextPaint paint;
    private float startX, startY, clickX, clickY;
    private Rect screenRect;
    private final Path zoomCircle;
    private final Matrix matrix;
    private int screenWidth;
    private int screenHeight;
    private Bitmap bitmap; // 底片

    private boolean moveUp;
    private boolean moving;
    private MarkType currentMark;
    private String textInputted;
    
    public enum MarkType {
        LINE,CIRCLE,RECT,ARROW,HAND_WRITING,TEXT,ZOOM_IN,SPOT_LIGHT
    }

    public SketchBoard(@NonNull Context context) {
        this(context, null);
    }

    public SketchBoard(@NonNull Context context,
                       @Nullable AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public SketchBoard(@NonNull Context context,
                       @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);

        zoomCircle = new Path();
        zoomCircle.addCircle(MAGNIFIER_RADIUS,
                MAGNIFIER_RADIUS, MAGNIFIER_RADIUS, Path.Direction.CW);

        matrix = new Matrix();
        matrix.setScale(ZOOM_IN_RATE, ZOOM_IN_RATE);

        paint = new TextPaint();
        paint.setAntiAlias(true); // 画笔反锯齿
        paint.setColor(Color.YELLOW);
        paint.setStrokeWidth(DEFAULT_STROKE_WIDTH); // 画笔粗细

        textInputted = "By Gen.L Release";
        // 图层混合模式必须禁止硬件加速
        setLayerType(LAYER_TYPE_SOFTWARE, null);
    }

    public void open(InputStream inputStream) {

        // 源图像是不能改变的，需要copy它
        bitmap = BitmapFactory.decodeStream(inputStream)
                .copy(Bitmap.Config.ARGB_8888, true);

        DisplayMetrics dm = getResources().getDisplayMetrics();
        screenWidth = dm.widthPixels;
        screenHeight = dm.heightPixels;
        screenRect = new Rect(0,0, screenWidth, screenHeight);

        paint.setTextSize(16 * dm.density);
        moving = false;
        moveUp = false;
        invalidate();
    }


    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        
        if (currentMark == MarkType.LINE) {
            // 即时重绘，不确定形状，等到PRESS UP时，更新bitmap = flash
            redrawCanvas(canvas, drawLine());
        } else if (currentMark == MarkType.CIRCLE) {
            redrawCanvas(canvas, drawCircle());
        } else if (currentMark == MarkType.RECT) {
            redrawCanvas(canvas, drawRect());
        } else if (currentMark == MarkType.ARROW) {
            redrawCanvas(canvas, drawArrow());
        } else if (currentMark == MarkType.HAND_WRITING) {
            redrawCanvas(canvas, handWriting());
        } else if (currentMark == MarkType.TEXT) {
            redrawCanvas(canvas, writeText());
        } else if (currentMark == MarkType.ZOOM_IN) {
            redrawCanvas(canvas, drawZoomIn());
        } else if (currentMark == MarkType.SPOT_LIGHT) {
            redrawCanvas(canvas, drawSpotLight());
        } else {
            redrawCanvas(canvas, bitmap);
        }
    }

    private void redrawCanvas(Canvas canvas,Bitmap bitmap) {
        canvas.drawBitmap(bitmap, 0,0, null);
    }

    private Bitmap flashBitmapCreated() {
        return Bitmap.createScaledBitmap(
                bitmap, screenWidth, screenHeight, true);
    }

    private Bitmap drawLine() {

        // 这里的bitmap是上一次确定的绘制形状，不是每次调用onDraw()都需要更新它，
        // 只有当TouchEvent -> UP 时，去更新图像Bitmap=> bitmap = flash bitmap;
        Bitmap flash = flashBitmapCreated();

        // FIXME: 零偏移量问题:默认初始化问题，初始化界面时，图片左上顶部绘制一个点（0,0）
        if (moving) {
            Canvas level = new Canvas(flash);
            // 画笔风格：FILL-填充，STROKE-描边，FILL_AND_STROKE:描边填充
            paint.setStyle(Paint.Style.FILL_AND_STROKE);
            level.drawCircle(startX, startY, POINT_CIRCLE_RADIUS, paint);
            level.drawLine(startX, startY, clickX, clickY, paint);
            level.drawCircle(clickX, clickY, POINT_CIRCLE_RADIUS, paint);
        }

        // 手指离开屏幕，保存此次绘制内容，作为下次绘制的基础bitmap。
        if (moveUp) {
            bitmap.recycle();
            bitmap = flash;
            moving = false;
        }

        // 当手指还在屏幕上滑动时，flash是某一个时间点的快照，需要绘制到Canvas上。
        return flash;
    }

    private Bitmap drawCircle() {

        Bitmap flash = flashBitmapCreated();

        if (moving) {
            float xOffset = clickX - startX;
            float yOffset = clickY - startY;
            float radius = (float) Math.sqrt(xOffset * xOffset + yOffset * yOffset);
            Canvas level = new Canvas(flash);
            paint.setStyle(Paint.Style.STROKE);
            level.drawCircle(startX, startY, radius, paint);
        }

        if (moveUp) {
            bitmap.recycle();
            bitmap = flash;
            moving = false;
        }

        return flash;
    }

    private Bitmap drawRect() {

        Bitmap flash = flashBitmapCreated();
        if (moving) {
            Canvas level = new Canvas(flash);
            paint.setStyle(Paint.Style.STROKE);
            level.drawRect(startX, startY, clickX, clickY, paint);
        }

        if (moveUp) {
            bitmap.recycle();
            bitmap = flash;
            moving = false;
        }

        return flash;
    }

    private Bitmap drawArrow() {

        Bitmap flash = flashBitmapCreated();
        // FIXME:这里有一个零偏移量问题,
        //       rotate函数传入参数不能为0，否则路径计算是无效的(0,0)
        if (moving) {
            Canvas level = new Canvas(flash);
            paint.setStyle(Paint.Style.STROKE);
            level.drawCircle(startX, startY, 2.5f, paint);
            level.drawLine(startX, startY, clickX, clickY, paint);
            level.drawPath(triangle(), paint);
        }

        if (moveUp) {
            bitmap.recycle();
            bitmap = flash;
            moving = false;
        }

        return flash;
    }

    /**
     *                   (clickX,clickY)
     *                          +
     *                        + | +
     *                      +   | ɑ +
     *                    +   H |     +
     *                  +       |       +
     * (leftX,leftY)  + + + + + + + + + + +  (rightX,rightY)
     *                          |<-     ->|
     *                               |
     *                                --BASE_SIDE_HALF
     */
    private Path triangle() {

        // 计算角ɑ的弧度值(0, 2PI)
        double radius = Math.atan(TRIANGLE_BASE_SIDE_HALF / TRIANGLE_HEIGHT);
        // 计算锐角三角形的腰长
        double waistLen = Math.sqrt(
                TRIANGLE_BASE_SIDE_HALF * TRIANGLE_BASE_SIDE_HALF + TRIANGLE_HEIGHT * TRIANGLE_HEIGHT);

        float xOffset = clickX - startX;
        float yOffset = clickY - startY;

        double[] pointRight = rotate(xOffset, yOffset, radius, waistLen);
        double[] pointLeft = rotate(xOffset, yOffset, -radius, waistLen);

        float rightX = (float) (clickX - pointRight[0]);
        float rightY = (float) (clickY - pointRight[1]);
        float leftX = (float) (clickX - pointLeft[0]);
        float leftY = (float) (clickY - pointLeft[1]);

        Path triangle = new Path();
        triangle.moveTo(clickX, clickY);
        triangle.lineTo(rightX, rightY);
        triangle.lineTo(leftX, leftY);
        triangle.close(); // 路径闭合

        return triangle;
    }

    // 矢量旋转函数，参数含义分别是x分量、y分量、旋转角、新长度
    private double[] rotate(float arrowOffsetX, float arrowOffsetY,
                            double angle, double newLen) {

        double[] point = new double[2];

        double pointX = arrowOffsetX * Math.cos(angle) - arrowOffsetY * Math.sin(angle);
        double pointY = arrowOffsetX * Math.sin(angle) + arrowOffsetY * Math.cos(angle);

        double d = Math.sqrt(pointX * pointX + pointY * pointY);
        pointX = pointX / d * newLen;
        pointY = pointY / d * newLen;

        point[0] = pointX;
        point[1] = pointY;

        return point;
    }


    private Bitmap handWriting() {

        Bitmap flash = flashBitmapCreated();
        Canvas level = new Canvas(flash);
        paint.setStyle(Paint.Style.STROKE);
        level.drawLine(startX, startY, clickX, clickY, paint);
        // 起点需要不断变化，否则画出来的是直线而不是手绘，因为起点一直不变
        startX = clickX;
        startY = clickY;

        // 需要实时保存记录
        bitmap.recycle();
        bitmap = flash;

        if (moveUp) {
            moving = false;
        }

        return flash;
    }

    private Bitmap writeText() {

        Bitmap flash = flashBitmapCreated();
        Canvas canvas = new Canvas(flash);
        canvas.translate(clickX, clickY);

        // 绘制背部阴影
        paint.setColor(Color.RED);
        paint.setDither(true);
        paint.setStyle(Paint.Style.STROKE);
        paint.setShadowLayer(8,0,0, Color.BLACK); // 加阴影
        paint.setStrokeWidth(4f);
        StaticLayout shadow = new StaticLayout(textInputted, paint,
                screenWidth * 3 / 4, Layout.Alignment.ALIGN_NORMAL, 1.0f, 0.0f, false);
        shadow.draw(canvas);

        // 绘制文字
        paint.setColor(Color.WHITE);
        paint.setStrokeWidth(2.0f);
        paint.clearShadowLayer();
        StaticLayout text = new StaticLayout(textInputted, paint,
                screenWidth * 3 / 4, Layout.Alignment.ALIGN_NORMAL, 1.0f, 0.0f, false);
        text.draw(canvas);

        // TODO:用户通过API接口去更新，不能通过PRESS UP决定。需要全局缓存flash，用于用户更新界面
        if (moveUp) {
            bitmap.recycle();
            bitmap = flash;
            paint.setColor(Color.YELLOW);// 复原风格
            paint.setStrokeWidth(DEFAULT_STROKE_WIDTH);
            moving = false;
        }

        return flash;
    }

    /**
     * TODO:用户通过API接口去更新，不能通过PRESS UP决定。需要全局缓存flash，用于用户更新界面
     *
     * FIXME:SRC中的图像没有参与放大，只有自己绘制的图像被放大了
     * RESOLVE:不使用IMAGEVIEW src属性，直接加载图片，转换成bitmap，绘制在canvas上、
     */
    private Bitmap drawZoomIn() {

        // 这里的bitmap是上一次确定的绘制形状，不是每次调用onDraw()都需要更新它，
        // 只有当TouchEvent -> UP 时，去更新图像Bitmap=> bitmap = flash bitmap;
        Bitmap flash = flashBitmapCreated();

        Canvas canvas = new Canvas(flash);
        // 剪切
        canvas.translate(clickX - MAGNIFIER_RADIUS * ZOOM_IN_RATE, clickY - MAGNIFIER_RADIUS * ZOOM_IN_RATE);
        canvas.clipPath(zoomCircle);
        // 放大
        canvas.translate(MAGNIFIER_RADIUS - clickX * ZOOM_IN_RATE, MAGNIFIER_RADIUS - clickY * ZOOM_IN_RATE);
        canvas.drawBitmap(flash, matrix, null);

        if (moveUp) {
            bitmap.recycle();
            bitmap = flash;
            moving = false;
        }

        // 当手指还在屏幕上滑动时，flash是某一个时间点的快照，需要绘制到Canvas上。
        return flash;
    }

    private Bitmap drawSpotLight() {

        // 这里的bitmap是上一次确定的绘制形状，不是每次调用onDraw()都需要更新它，
        // 只有当TouchEvent -> UP 时，去更新图像Bitmap=> bitmap = flash bitmap;
        Bitmap flash = flashBitmapCreated();
        Canvas canvas = new Canvas(flash);

        // canvas.saveLayer和restoreToCount必须被调用，否则DST_OUT失效，只有白色的圆
        int layer = canvas.saveLayer(
                0, 0, screenWidth, screenHeight, null);
        // 绘制阴影蒙层
        paint.setXfermode(null);
        paint.setColor(Color.argb(100, 50, 50, 50));
        paint.setStyle(Paint.Style.FILL_AND_STROKE);
        canvas.drawRect(screenRect, paint);

        paint.setColor(Color.WHITE);
        paint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.DST_OUT));
        canvas.drawCircle(clickX, clickY, DEFAULT_CIRCLE_RADIUS, paint);
        canvas.restoreToCount(layer);

        if (moveUp) {
            bitmap.recycle();
            bitmap = flash;
            paint.setColor(Color.YELLOW);
            paint.setXfermode(null);
            moving = false;
        }

        return flash;
    }

    private void drawSpotLight(Canvas canvas) {
        // canvas.saveLayer和restoreToCount必须被调用，否则DST_OUT失效，只有白色的圆
        int layer = canvas.saveLayer(0, 0, screenWidth, screenHeight, null);
        // 绘制阴影蒙层
        paint.setXfermode(null);
        paint.setColor(Color.argb(100, 50, 50, 50));
        canvas.drawRect(screenRect, paint);

        paint.setColor(Color.WHITE);
        paint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.DST_OUT));
        canvas.drawCircle(clickX, clickY, DEFAULT_CIRCLE_RADIUS, paint);
        canvas.restoreToCount(layer);
    }



    @Override
    public boolean onTouchEvent(MotionEvent event) {
        int action = event.getAction();
        clickX = event.getX();
        clickY = event.getY();
        if (action == MotionEvent.ACTION_DOWN) {
            moveUp = false;
            moving = true;
            startX = clickX;
            startY = clickY;
            invalidate();
        } else if (action == MotionEvent.ACTION_MOVE) {
            moveUp = false;
            moving = true;
            invalidate();
        } else if (action == MotionEvent.ACTION_UP) {
            moveUp = true;
            invalidate(); // 通知View重新绘制
        }
        // 消费掉此次事件，不在进行事件处理传递，
        // 在DOWN返回TRUE, 否则MOVE和UP事件不会传递到onTouchEvent方法中
        return true;
    }

    public void changeMark(@NonNull MarkType type) {
        this.currentMark = type;
    }
}
```

</details>

