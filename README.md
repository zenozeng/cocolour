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

## 项目日程

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

- [TODO] 复用 img，允许传入 img 给 colors-clustering

- [TODO] Improve UI when drop file （缓和动画）

- [TODO] 重构配色产生方案，考虑距离因素，不要直接穷举，缩减可能性

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
