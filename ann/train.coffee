fs = require 'fs'
ANN = require './ann.coffee'

data = fs.readFileSync '../data/training.json'
data = JSON.parse data

verifyData = fs.readFileSync '../data/verify.json'
verifyData = JSON.parse verifyData

ann = new ANN
ann.train data
ann.verify verifyData
