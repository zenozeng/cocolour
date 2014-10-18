_ = {}

_.print = (obj) ->
    str = JSON.stringify(obj)
    str = str.replace(new RegExp('\\[', 'g'), '\n')
    str = str.replace(new RegExp('[\\],]', 'g'), ' ')
    console.log str

module.exports = _
