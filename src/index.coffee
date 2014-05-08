colorsClustering = require "colors-clustering"

display = (clusters) ->
  html = clusters.map (cluster) ->
    color = cluster.color
    "<div class='color' style='background: rgb(#{color.join(',')})'></div>"
  html = "<div class='colors'>#{html.join('')}</div>"
  document.getElementById("colors").innerHTML = html

box = document.getElementById("image")
box.ondragover = (event) ->
  this.className = 'hover'
  event.preventDefault()
box.ondragend = (event) ->
  this.className = ''
  event.preventDefault()
box.ondrop = (event) ->
  box.style.lineHeight = 0
  document.getElementById("colors").innerHTML = "Calculating..."
  event.preventDefault()
  url = URL.createObjectURL(event.dataTransfer.files[0])
  config =
    src: url
    minCount: 7
  colorsClustering config, (clusters) ->
    display clusters
    clusters.sort (a, b) -> b.weight - a.weight
    colorMatchings = []
    # 列出选择排列的所有可能性
    C = (arr, n) ->
      results = []
      iter = (t, arr, n) ->
        if n is 0
          results.push t
        else
          for i in [0..(arr.length - n)]
            iter t.concat(arr[i]), arr.slice(i+1), (n - 1)
      iter [], arr, n
      results
    # schemes = C([0...clusters.length], 5).map (scheme) ->
    #   scheme.map (i) -> clusters[i].color
    # console.log schemes

    # 目前只用了前 7 种颜色进行组合
    schemes = C([0...7], 5).map (scheme) ->
      scheme.map (i) -> clusters[i].color

    html = schemes.map (colors) ->
      tmp = colors.map (color) ->
        "<div class='color' style='background: rgb(#{color.join(',')})'></div>"
      "<div class='scheme'>#{tmp.join('')}</div>"
    document.getElementById("schemes").innerHTML = html.join('')
  img = new Image
  img.src = url
  img.onload = ->
    box.innerHTML = ""
    box.appendChild img
