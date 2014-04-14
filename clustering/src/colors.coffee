# 基于 wikipedia 上的算法
# http://zh.wikipedia.org/wiki/HSL%E5%92%8CHSV%E8%89%B2%E5%BD%A9%E7%A9%BA%E9%97%B4

# r, g, b [0, 255]
# return h [0, 360], s [0, 1], v [0, 1]
rgb2hsl = (r, g, b) ->
  [r, g, b] = [r, g, b].map (elem) -> elem / 255

  max = Math.max r, g, b
  min = Math.min r, g, b

  # 计算色相
  if max is min
    h = 0
  else if max is r and g >= b
    h = 60 * (g - b) / (max - min)
  else if max is r and g < b
    h = 60 * (g - b) / (max - min) + 360
  else if max is g
    h = 60 * (b - r) / (max - min) + 120
  else
    h = 60 * (r - g) / (max - min) + 240

  # 计算饱和度
  l = (max + min) / 2

  # 计算亮度
  if max is min or l is 0
    s = 0
  else if l > 0 and l <= 0.5
    s = (max - min) / (max + min)
  else
    s = (max - min) / (2 - (max + min))

  h = parseInt(h)
  [s, l] = [s, l].map (elem) -> Math.round(elem * 100) / 100
  return [h, s, l]

window.rgb2hsl = rgb2hsl
