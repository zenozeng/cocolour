# Cocolour Report

## 项目成果

### Experimental Data

We use `LeanCould` as our database.
And the data can be downloaded from our Github Repository.

https://github.com/zenozeng/cocolour/tree/master/data

本项目目前共产生有效数据 *TODO* 条：
其中正向偏好数据 *TODO* 条，负向偏好数据 *TODO* 条。
共 *TODO* 个账号产生数据。

### Colors Extracting Algorithm based on K-Means，CIE76 and CSS Color Module Level 3

实验过程中我们发现基于 RGB 色彩空间的 K-Means 算法可以快速得到图像中的主要颜色。
然而 RGB 的色彩距离与对人类感知来说是不均匀的。
因此换用 CIE2000 这个色彩距离算法，然而由于我们的运行环境是浏览器，
性能相对还是比较敏感的，
最后我们换用效果稍逊但是性能更好的 CIE76 算法（较之 CIE2000 少了一些校正因子，就是朴素的 Lab 距离）。

K-Means 的算法特点决定了其结果会非常严重的受到初始值的影响。比如如果取了一个距离多个色比较近的色，这些色彩都会聚合到那个cluster里头去，就会导致严重的色彩损失。为了应对这个现象，增加了初始中心点的数量，然后采用CSS Color Module Level 3 (W3C Recommendation 07 June 2011) 里的颜色关键字来作为种子。这样可以覆盖大多数常见的颜色。事实上效果也相当不错。

一开始使用RGB / HSL距离，但是结果不是很理想。后来去找了业界的色彩公式，换用 CIE2000 来计算。但是时间开销过大。最后采用折中的CIE76（也就是直接计算LAB色彩空间距离），虽然效果没有CIE2000好，但是时间成本却变得可以承受。

Note that images should be scaled to a reasonable size, otherwise it will take a long time to extract colors.

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

- [gene-pool](https://github.com/zenozeng/gene-pool)

    Genetic algorithms in a given gene pool.

    Also, a visualization demo was created: http://zenozeng.github.io/gene-pool/demo/

- [colors-clustering](https://github.com/zenozeng/colors-clustering)

    Colors clustering based on K-means algorithm & CIE76.
    The seeds are extended color keywords from CSS Color Module Level 3 (W3C Recommendation 07 June 2011).

    Visualization Demo (but in RGB & K-Means): http://zenozeng.github.io/colors-clustering-visualization/
