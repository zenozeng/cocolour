debug = on

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

calcCenter = (points) ->
  if points.length is 0
    return null
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

clustering = (points) ->
  points = points.map (point) ->
     [h, s, l] = point
     s *= 100
     l *= 100
     [h, s, l]
  # points = points.filter (points, i) -> i < 10000 # for testing
  n = 16
  # init centers
  centers = []
  clusters = []
  for h in [0, 45, 90, 135, 180, 225, 270, 315]
    for s in [50]
      for l in [25, 75]
        centers.push [h, s, l]
  for i in [0..15]
    clusters.push []
  display centers if debug
  calc = ->
    for point in points
      # 分配给最近 cluster
      minIndex = 0 # 最小距离的聚类
      minDistance = null
      for i in [0..15]
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
  calc()

window.clustering = clustering
