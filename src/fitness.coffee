ANN = require 'ann.coffee'
network = require './network'

ann = ANN.fromJSON network

fitness = (scheme) ->
    Math.random()

module.exports = fitness
