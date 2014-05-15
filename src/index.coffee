if !Array.prototype.map
  window.location.href = "http://browsehappy.com/"

colorsClustering = require "colors-clustering"
$ = require "jquery"
window.$ = $

display = (clusters) ->
  html = clusters.map (cluster) ->
    color = cluster.color
    "<div class='color' style='background: rgb(#{color.join(',')})'></div>"
  html = "<div class='colors'>#{html.join('')}</div>"
  document.getElementById("colors").innerHTML = html

body = document.body
body.ondragover = (event) -> event.preventDefault()
body.ondragend = (event) -> event.preventDefault()
body.ondragenter = (event) -> event.preventDefault()
body.ondragleave = (event) -> event.preventDefault()
body.ondrag = (event) -> event.preventDefault()
body.ondrop = (event) ->
  event.preventDefault()
  box = document.getElementById("image")
  url = URL.createObjectURL(event.dataTransfer.files[0])
  config =
    src: url
    minCount: 7
  colorsClustering config, (clusters) ->
    clusters.sort (a, b) -> b.weight - a.weight
    display clusters
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
      "<div class='scheme' data-scheme='#{JSON.stringify(colors)}'>#{tmp.join('')}
        <i class='fa fa-heart-o button'></i>
        <i class='fa fa-trash-o button'></i></div>"
    document.getElementById("schemes").innerHTML = html.join('')
    (->
      getScore = ($scheme) ->
        if $scheme.find('.fa-heart-o').hasClass 'selected'
          1
        else if $scheme.find('.fa-trash-o').hasClass 'selected'
          -1
        else
          0
      setScore = ($scheme, score) ->
        $scheme.find('.fa-heart-o').toggleClass('selected', score > 0)
        $scheme.find('.fa-trash-o').toggleClass('selected', score < 0)
        url = "http://jp.zenozeng.com:26080"
        data =
          scheme: JSON.stringify($scheme.data('scheme'))
          score: score
        console.log data
        $.get url, data
      $('.scheme .fa-heart-o').click ->
        $scheme = $(this).parents('.scheme')
        if getScore($scheme) is 1
          setScore $scheme, 0
        else
          setScore $scheme, 1
      $('.scheme .fa-trash-o').click ->
        $scheme = $(this).parents('.scheme')
        if getScore($scheme) is -1
          setScore $scheme, 0
        else
          setScore $scheme, -1
          $scheme.appendTo($('#schemes'));
    )()
  img = new Image
  img.onload = ->
    box.style.lineHeight = 0
    box.innerHTML = ""
    box.appendChild img
  img.src = url
