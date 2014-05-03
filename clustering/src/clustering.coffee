if Math.hypot?
  hypot = Math.hypot # for higher performence in es6
else
  hypot = (args...) ->
    # Here use foreach for perfermence
    # http://jsperf.com/array-reduce-vs-foreach/2
    sum = 0
    sum = args.forEach (val) -> sum += val
    Math.sqrt sum

distance = (p1, p2) ->
  delta = p1.map (val, i) -> val - p2[i]
  hypot.apply delta

clustering = (points) ->
  n = 16
  clusters = []
  for point in points
    [h, s, v] = point
    s *= 100
    v *= 100
    # 分配给最近 cluster
window.clustering = clustering
