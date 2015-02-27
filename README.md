# Cocolour

Color schemes generator based on machine learning

## Development

```
sudo npm install -g grunt-cli
npm install
```

### Build

`grunt build`

### Watch

`grunt watch`

### Test

```
sudo npm install -g coffee-script
npm test
```

## FAQ

### Why HSL?

See also http://zh.wikipedia.org/wiki/HSL%E5%92%8CHSV%E8%89%B2%E5%BD%A9%E7%A9%BA%E9%97%B4

Section: HSL与HSV的比较

### 讨厌喜欢的分离

事实上，
似乎喜欢和讨厌的机制是很不一样的，
所以他们应该被丢到两个堆中去。

如果直接用单个score输出，正确率非常低，只有三十几。
如果用 [喜欢，不喜欢，一般] 输出，大概61%
如果用 [喜欢, 不喜欢]，大概68-69%

https://github.com/zenozeng/cocolour/issues/77

## 经验

### BP神经网络命中率波动非常厉害，而且很低？

可能是数据过拟合了，调整 iterations 和 errorThresh 看看会不会有帮助。

## License

```
Copyright (C) 2014-2015 Zeno Zeng

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
```

*This program incorporates work covered by the following copyright and permission notices:*

- jQuery

    Copyright 2005, 2014 jQuery Foundation, Inc. and other contributors

    Released under the MIT license

- color-convert

    Copyright (c) 2011 Heather Arthur <fayearthur@gmail.com>

    Released under the MIT license

- colors-clustering

    Copyright (c) 2014 Zeno Zeng

    Released under the MIT license

- gene-pool

    Copyright (c) 2014 Zeno Zeng

    Released under the MIT license

- brain

    Copyright (c) 2010 Heather Arthur

    Released under the MIT license

## 项目日程

### 2015-03-23 -- 2015-03-01

- UI 细节调整、加载速度优化

- 现在切分训练数据与验证数据时会保持 positive 和 negative 的比例

### 2015-02-16 -- 2015-02-22

- 网站 UI 的进一步重构

- 代码组织方式调整、重构

### 2015-02-09 -- 2015-02-15

- 一些前端小调整

- 重写神经网络预测率测试

    - 基于 cluster 模块，使用 process 的 message 通信

    - 输出测试结果的 max, min, mean, median 和 var

- 调整 iterations 和 errorThresh 来避免过拟合问题

    - 平均预测率基本可以到 71%

    - 而且现在输出结果不再发生大幅度波动了

    See also: https://github.com/zenozeng/cocolour/issues/92

- 移除色相、亮度、饱和度方差

    - 平均预测率现在可达 72%

    See also: https://github.com/zenozeng/cocolour/issues/78

- 输出讨厌和喜欢各自的预测率

    - 目前喜欢可达 80%，讨厌仅为 56%

    See also: https://github.com/zenozeng/cocolour/issues/90

- 尝试给估价函数增加一个 bias

    ```coffeescript
    bias = 0.38
    (positive - bias) * 1 / bias
    ```

    对喜欢的平均预测率现在可达 93%，虽然对讨厌的平均预测率现在降到了 39%，综合判断率下降

    See also: https://github.com/zenozeng/cocolour/issues/93

- 网站 UI 调整

### 2014-10-20 -- 2014-11-09

- 确定神经网络库的选择为 Brain

- 确定输入格式为一个 HSL 矩阵的 flatten: H1 S1 L1 H2 S2 L2 H3 S3 L3 H4 S4 L4 H5 S5 L5

    See also: https://github.com/zenozeng/cocolour/issues/72

- 一次概念验证性测试

    ```
    Length:  164
    Match Cound:  106
    Unmatch Cound:  58
    Rate(%):  64.63414634146342
    ```

    具体的测试详情：https://github.com/zenozeng/cocolour/issues/76

- 确定输出格式

    似乎喜欢和讨厌的机制是很不一样的，
    所以他们应该被丢到两个堆中去。

    如果直接用单个score输出，正确率非常低，只有30%-40%
    如果用 [喜欢，不喜欢，一般] 输出，大概60-61%，
    以及一般这一档的数据非常少，不怎么可靠。
    如果用 [喜欢, 不喜欢]，大概60-68%

    具体的测试详情：https://github.com/zenozeng/cocolour/issues/77

- 增加数据到 813 组

- 数据分组成 train 和 verify 组的时候引入随机性

    https://github.com/zenozeng/cocolour/issues/81

    这个 Issue 会导致之前的测定结果存在一定的偏差

- 增加数据到 1378 组

- 调整 learningRate 到 0.1

    似乎结果的稳定性提升了一些、正确率也提升了一些

- 基于 master-slave 的多进程结果验证

    充分利用多核性能

- 尝试引入色相方差、饱和度方差、明度方差

- 调整学习速率到 0.05

### 2014-10-13 -- 2014-10-19

- Fix bugs in UI

- Script for fetching all color schemes in database

- 500+ more color schemes

- Normalize colors

### 2014-10-06 -- 2014-10-12

- 引入 AVOS Cloud SDK

- user.signup, user.login, user.logout & user.passwordReset

- DB: Class Scheme

- ACL for Scheme

- Log heart and trash

### 2014-08-18 -- 2014-08-24

- 神经网络库的选择讨论

    See also: https://github.com/zenozeng/cocolour/issues/53

- 界面增加动画

- 尝试引入遗传算法，以便在更短时间获得更好结果

- 构建遗传算法库

    https://github.com/zenozeng/gene-pool

- Move static/font-awesome to cdn.staticfile.org

- 各家 Baas 服务商的比较，打算使用 avoscloud

    https://cn.avoscloud.com/docs/js_guide.html

- 遗传算法可视化

    http://zenozeng.github.io/gene-pool/demo/

- 引入遗传算法 (gene-pool@0.0.4)

### 2014-08-11 -- 2014-08-17

- Go back using CoffeeScript

    See also https://github.com/zenozeng/cocolour/issues/37

- update header, fixes #41

- 聚类算法可视化 (D3)

    https://github.com/zenozeng/colors-clustering-visualization

### 2014-06-23 -- 2014-06-29

- About whether to use DBaaS or Baas

    See also https://github.com/zenozeng/cocolour/issues/46

    See also https://github.com/zenozeng/cocolour/issues/44

- Consider using Genetic Algorithms

    See also https://github.com/zenozeng/cocolour/issues/49

### 2014-06-16 -- 2014-06-22

- Consider using Web Worker

- New Arch Design (ClojureScript for Pure Calculation & CoffeeScript for UI and Communication)

### 2014-06-09 -- 2014-06-15

- 关于应用容器化的构想，及相关服务提供商的比较

    Linode + Ubuntu + Docker / DigitalOcean + Ubuntu + Docker / Stackdock / Tutum

### 2014-06-02 -- 2014-06-08

- New UI Design for colors clustering (in Zeno's loose notes 2014-06-08)

### 2014-05-12 -- 2014-05-18

- Simple JSON based user system

- Simple loging system for replaying requests later

### 2014-05-05 -- 2014-05-11

- New name: cocolour

- New domain: cocolour.com

- Deploy on Github Pages

- Move clustering/ to new repo: zenozeng/colors-clustering

- Use seeds from CSS Color Module Level 3

- Use CIEDE2000 for calc color difference

- Add RGBA Support for Colors Clustering

- Switch to CIE67 for perfermence

    see https://github.com/zenozeng/colors-clustering/issues/7

- Add nodejs support for colors-clustering

- Npm publish zenozeng/colors-clustering

- Rewrite cocolour using zenozeng/colors-clustering

- New UI for cocolour

- Use Grunt as task runner

- UI for 1920 * 1080

- New Repo: cocolour-server

### 2014-04-28 -- 2014-05-04

- 基于 K-Means 算法以及 HSL 色彩空间实现基本色彩聚类

- Init UI (based on HTML5 drag & drop API)

### 2014-03-17 -- 2014-04-27

- 基本调研

- 初始化项目

- 服务器基本部署

- 色彩聚类代码初步

### 2014-03-05 -- 2014-03-16

- Init Repo
