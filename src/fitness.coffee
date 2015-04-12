ANN = require './ann.coffee'
network = require './network'

ann = ANN.fromJSON network

fitness = (scheme) -> ann.rate(scheme)

module.exports = fitness
