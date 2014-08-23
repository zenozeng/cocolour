# Cocolour

Color schemes generator based on machine learning

## Intro

### Clustering

#### Resize

based on `maxWidth` and `maxHeight`

#### RGB 2 Lab

#### k-means algorithm & CIE76

### [TODO] Machine Learning

## Development

```
sudo npm install -g grunt-cli
npm install
```

### Build

`grunt build`

### Watch

`grunt watch`

## Production

```
npm install --production
```

## License

```
Copyright (C) 2014 Zeno Zeng

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

- colors-clustering

    Copyright (C) 2014 Zeno Zeng

    Released under the MIT license

## 项目日程

### 2014-08-18 -- 2014-08-24

- 神经网络库的选择讨论

    See also: https://github.com/zenozeng/cocolour/issues/53

- 界面增加动画

- 尝试引入遗传算法，以便在更短时间获得更好结果

- 构建遗传算法库

    https://github.com/zenozeng/gene-pool

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
