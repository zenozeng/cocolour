fs = require 'fs'
ANN = require '../ann.coffee'

data = fs.readFileSync '../../data/training.json'
data = JSON.parse data

verifyData = fs.readFileSync '../../data/verify.json'
verifyData = JSON.parse verifyData

ann = new ANN {logPeriod: 1000}
ann.train data
ann.verify verifyData
