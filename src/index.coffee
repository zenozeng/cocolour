colorsClustering = require "colors-clustering"

display = (colors) ->
  html = colors.map (color) ->
    unless color?
      color = [0, 0, 100]
    [h, s, l] = color
    "<div class='color' style='background: hsl(#{h}, #{s}%, #{l}%)'></div>"
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
  document.getElementById("colors").innerHTML = "Calculating..."
  event.preventDefault()
  url = URL.createObjectURL(event.dataTransfer.files[0])
  colorsClustering {src: url}, (clusters) ->
    console.log clusters
  box.style.backgroundImage = "url(#{url})"
