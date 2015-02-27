fs = require 'fs'

data = fs.readFileSync 'all.json'
data = JSON.parse data

# make data random
data.sort (a, b) -> Math.random() > 0.5

# remove score = 0
data = data.filter (elem) -> elem.score != 0

# classify data
likes = data.filter (elem) -> elem.score > 0
dislikes = data.filter (elem) -> elem.score < 0

# init collection
training = []
verify = []

# training : verify = 7 : 3
rate = 0.7

likes.forEach (elem, i) ->
    if i < rate * likes.length
        training.push elem
    else
        verify.push elem

dislikes.forEach (elem, i) ->
    if i < rate * dislikes.length
        training.push elem
    else
        verify.push elem


view = (data, str) ->
    likes = data.filter (elem) -> elem.score > 0
    dislikes = data.filter (elem) -> elem.score < 0
    console.log str, { likes: likes.length, dislikes: dislikes.length, scale: likes.length / dislikes.length }

view data, 'data'
view training, 'training'
view verify, 'verify'

fs.writeFileSync 'training.json', JSON.stringify training, null, 4
fs.writeFileSync 'verify.json', JSON.stringify verify, null, 4
