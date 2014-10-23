fs = require 'fs'

data = fs.readFileSync 'all.json'
data = JSON.parse data

data.sort (a, b) -> (new Date(a.createdAt)) - (new Date(b.createdAt))

data = data.filter (elem) -> elem.score != 0

n = 700

training = data.filter (elem, index) -> index < n
test = data.filter (elem, index) -> index >= n

console.log 'training.json', training.length
console.log 'verify.json', test.length

fs.writeFileSync 'training.json', JSON.stringify training
fs.writeFileSync 'verify.json', JSON.stringify test
