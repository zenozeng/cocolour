ctx = document.getElementById("canvas").getContext("2d")
url = "test.min.jpg"
img = new Image()
img.onload = ->

  image = this

  # todo calc scale based on w and h
  scale = 2.5

  [w, h] = [image.width, image.height].map (elem) -> parseInt (elem / scale)
  console.log {w: w, h: h}
  canvas.style.width = "#{w}px"
  canvas.style.height = "#{h}px"
  ctx.drawImage this, 0, 0, image.width, image.height, 0, 0, w, h

  imgData = ctx.getImageData(0, 0, w, h)
  points = []
  i = 0
  while( i < imgData.data.length )
    [r, g, b] = [imgData.data[i], imgData.data[i+1], imgData.data[i+2]]
    points.push window.rgb2hsl(r, g, b)
    i += 4
  console.log points.length
  window.clustering(points)
img.src = url
