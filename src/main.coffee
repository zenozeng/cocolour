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
  file = event.dataTransfer.files[0]
  reader = new FileReader
  reader.onload = (event) ->
    dataURL = event.target.result
    clustering {maxWidth: 50, maxHeight: 50, url: dataURL, debug: off}, (centers) ->
      display centers
    box.style.backgroundImage = "url(#{dataURL})"
  reader.readAsDataURL file
