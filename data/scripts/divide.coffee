fs = require 'fs'

data = fs.readFileSync 'data/all.json'
data = JSON.parse data

# make data random
data.sort (a, b) -> Math.random() - 0.5

# remove score = 0
data = data.filter (elem) -> elem.score != 0

# classify data
likes = data.filter (elem) -> elem.score > 0
dislikes = data.filter (elem) -> elem.score < 0

# init collection
training = []
verify = []

# training : verify = rate : 1 - rate
rate = 0.7 # 7 : 3

dislikes.forEach (elem, i) ->
    if i < rate * dislikes.length
        training.push elem
    else
        verify.push elem

likes.forEach (elem, i) ->
    if i < rate * likes.length
        training.push elem
    else
        verify.push elem


# resort
verify = verify.sort -> Math.random() - 0.5
training = training.sort -> Math.random() - 0.5

view = (data, str) ->
    likes = data.filter (elem) -> elem.score > 0
    dislikes = data.filter (elem) -> elem.score < 0
    console.log str, { likes: likes.length, dislikes: dislikes.length, scale: likes.length / dislikes.length }

view data, 'data'
view training, 'training'
view verify, 'verify'

fs.writeFileSync 'data/training.json', JSON.stringify training
fs.writeFileSync 'data/verify.json', JSON.stringify verify
