# 配色的好坏判断函数
# 临时先放一下，以后应该要用神经网络生成的函数代替掉

ANN = require 'ann.coffee'

ann = ANN.fromJSON json

fitness = (scheme) ->
    Math.random()

module.exports = fitness
