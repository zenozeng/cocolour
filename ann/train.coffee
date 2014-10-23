fs = require 'fs'
ANN = require './ann.coffee'

data = fs.readFileSync '../data/training.json'
data = JSON.parse data

verifyData = fs.readFileSync '../data/verify.json'
verifyData = JSON.parse verifyData

test = ->
    ann = new ANN
    ann.train data
    ann.verify verifyData

len = 0
passed = 0
for i in [0..20]
    result = test()
    fs.writeFileSync "logs/#{i}", JSON.stringify(result)
    len += result.length
    passed += result.passed
    console.log "Total test: #{len}"
    console.log "Passed test: #{passed}"
    console.log "Rate: #{passed / len}"
