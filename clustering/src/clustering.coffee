if Math.hypot?
  hypot = Math.hypot # for higher performence in es6
else
  hypot = (args) ->
    # Here use foreach for perfermence
    # http://jsperf.com/array-reduce-vs-foreach/2
    sum = 0
    args.forEach (val) -> sum += val * val
    Math.sqrt sum

calcDistance = (p1, p2) ->
  weights = [1, 0.8, 0.8] # 一个权重常数，暂时先用这个，注意是有平方关系的
  delta = p1.map (val, i) -> (val - p2[i]) * weights[i]
  hypot delta

clustering = (points, config) ->

  {debug, display} = config

  points = points.map (point) ->
     [h, s, l] = point
     s *= 100
     l *= 100
     [h, s, l]
  imagePixels = points
  N = 16

  calcCenter = (points) ->
    if points.length is 0
      # 这个中心点没有任何接近的值，从原图中随机找一个点
      center = imagePixels[parseInt(Math.random() * imagePixels.length)]
      console.log center
      return center
      # return points[parseInt(Math.random() * points.length)]
    # 该坐标系为圆柱坐标系
    L = math.mean points.map (point) -> point[2]
    x = math.mean points.map (point) ->
      [h, s, l] = point
      s * math.cos(math.unit(h, 'deg'))
    y = math.mean points.map (point) ->
      [h, s, l] = point
      s * math.sin(math.unit(h, 'deg'))
    S = Math.sqrt(x * x + y * y)
    atan = Math.atan(y / x)
    H = atan / Math.PI * 180
    H += 360 if H < 0
    [H, S, L].map (elem) -> parseInt elem
    # 取原先存在的最接近平均值的点来代替平均值
    newCenter = 0
    minDistance = null
    for point in points
      d = calcDistance(point, [H, S, L])
      if (! minDistance?) or (d < minDistance)
        minDistance = d
        newCenter = point
    newCenter

  # init centers
  centers = []
  clusters = []
  for h in [0, 45, 90, 135, 180, 225, 270, 315]
    for s in [50]
      for l in [25, 75]
        centers.push [h, s, l]
  for i in [0...N]
    clusters.push []
  display centers if debug
  # TODO: 受初始值影响非常大
  calc = ->
    for point in points
      # 分配给最近 cluster
      minIndex = 0 # 最小距离的聚类
      minDistance = null
      for i in [0...N]
        d = calcDistance(centers[i], point)
        if (! minDistance?) or (d < minDistance)
          minIndex = i
          minDistance = d
      clusters[minIndex].push point
    # 得到结果，取平均数
    centers = clusters.map (cluster) -> calcCenter cluster
    display centers if debug
  calc()
  calc()
  centers

clusteringWrapper = (config) ->
  {maxWidth, maxHeight, url, debug, display} = config

  img = new Image()
  img.onload = ->

    image = this

    # todo calc scale based on w and h
    scale = Math.max (image.width / maxWidth), (image.height / maxHeight), 1

    [w, h] = [image.width, image.height].map (elem) -> parseInt (elem / scale)

    canvas = document.createElement("canvas");
    canvas.width = w
    canvas.height = h
    ctx = canvas.getContext "2d"
    ctx.drawImage this, 0, 0, image.width, image.height, 0, 0, w, h

    imgData = ctx.getImageData(0, 0, w, h)
    points = []
    i = 0
    while( i < imgData.data.length )
      [r, g, b] = [imgData.data[i], imgData.data[i+1], imgData.data[i+2]]
      points.push window.rgb2hsl(r, g, b)
      i += 4
    centers = clustering(points, {debug: on, display: display})

  img.src = url

window.clustering = clusteringWrapper
