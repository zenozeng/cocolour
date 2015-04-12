ANN = require './ann.coffee'
network = require './network'

ann = ANN.fromJSON network

fitness = (scheme) -> ann.rate({colors:scheme})
# fitness = (scheme) -> 0 # default order

module.exports = fitness
