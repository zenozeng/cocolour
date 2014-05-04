window.math = new mathjs

display = (colors) ->
  html = colors.map (color) ->
    unless color?
      color = [0, 0, 100]
    [h, s, l] = color
    "<div class='color' style='background: hsl(#{h}, #{s}%, #{l}%)'></div>"
  html = "<div class='colors'><h2>Clusters</h2>#{html.join('')}</div>"
  document.getElementById("colors").innerHTML += html

url = "test3.jpg"
clustering {maxWidth: 100, maxHeight: 100, url: url, debug: on, display: display}
