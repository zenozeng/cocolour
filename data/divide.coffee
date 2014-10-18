fs = require 'fs'

data = fs.readFileSync 'all.json'
data = JSON.parse data

data.sort (a, b) -> (new Date(a.createdAt)) - (new Date(b.createdAt))

training = data.filter (elem, index) -> index < 400
test = data.filter (elem, index) -> index >= 400

console.log 'training.json', training.length
console.log 'verify.json', test.length

fs.writeFileSync 'training.json', JSON.stringify training
fs.writeFileSync 'verify.json', JSON.stringify test
