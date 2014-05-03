# 色彩聚类

Color clustering based on HSL.

## HSL vs HSV

HSL（色相、饱和度、亮度）的优点是它对称于亮与暗。

- 在HSL中，饱和度分量总是从完全饱和色变化到等价的灰色（在HSV中，在极大值V的时候，饱和度从全饱和色变化到白色，这可以被认为是反直觉的）。

- 在HSL中，亮度跨越从黑色过选择的色相到白色的完整范围（在HSV中，V分量只走一半行程，从黑到选择的色相）。

see http://zh.wikipedia.org/wiki/HSL%E5%92%8CHSV%E8%89%B2%E5%BD%A9%E7%A9%BA%E9%97%B4

## 测试图片

1000 * 562 JPEG

## Args

maxSize: 200 * 200

## RGB2HSL

### 速度测试 / 图像测试

see test/rgb2hsl.html

我这里测试大概 1000000 数据需要 3s。
