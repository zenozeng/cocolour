canvas = document.getElementById("canvas")
img = document.getElementById("img")
ctx = canvas.getContext("2d")
ctx.drawImage(img, 0, 0)
imgData = ctx.getImageData(0, 0, canvas.width, canvas.height)
hsv = []
i = 0
while( i < imgData.data.length )
  [r, g, b] = [imgData.data[i], imgData.data[i+1], imgData.data[i+2]]
  hsv.push window.rgb2hsl(r, g, b)
  i += 4
console.log hsv
window.clustering(points)
