# Cocolour Report

## 项目成果

### 实验数据

项目中产生的数据、简单数据获取与分组的脚本存放在 Github 上：

https://github.com/zenozeng/cocolour/tree/master/data

本项目目前共产生有效数据 *TODO* 条：
其中正向偏好数据 *TODO* 条，负向偏好数据 *TODO* 条。
共 *TODO* 个账号产生数据。

### 基于 K-Means，CIE76 以及 CSS Color Module Level 3 的图像提取算法

实验过程中我们发现基于 RGB 色彩空间的 K-Means 算法可以快速得到图像中的主要颜色。
然而 RGB 的色彩距离与对人类感知来说是不均匀的。
因此换用 CIE2000 这个色彩距离算法，然而由于我们的运行环境是浏览器，
性能相对还是比较敏感的，
最后我们换用效果稍逊但是性能更好的 CIE76 算法（较之 CIE2000 少了一些校正因子，就是朴素的 Lab 距离）。

### 算法可视化 Demo

### Repositories Created

- [act.js](https://github.com/zenozeng/act.js)

    Simple (in-browser) JavaScript to generate Adobe Color Table (.act)[^[Adobe Photoshop File Formats Specification](http://www.adobe.com/devnet-apps/photoshop/fileformatashtml/)] files using Uint8Array, Blob API and FileReader API.

    See also:

    - [Big endian and Little endian](http://www.cnblogs.com/luxiaoxun/archive/2012/09/05/2671697.html)

    - [actpalette](https://github.com/bdon/actpalette)

    - [Blob API](https://developer.mozilla.org/en-US/docs/Web/API/Blob)

    - [Is there a “default” MIME type?](http://stackoverflow.com/questions/12539058/is-there-a-default-mime-type)

    - [How to load color table in a indexed mode file??](https://forums.adobe.com/message/2205681#2205681)

    - [Color swatch file formats](http://www.selapa.net/swatches/colors/fileformats.php)
