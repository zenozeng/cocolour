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
  box.innerHTML = ""
  box.style.lineHeight = 0
  document.getElementById("colors").innerHTML = "Calculating..."
  event.preventDefault()
  url = URL.createObjectURL(event.dataTransfer.files[0])
  colorsClustering {src: url}, (clusters) ->
    display clusters
  img = new Image
  img.src = url
  box.appendChild img
