fs = require "fs"
AV = require('avoscloud-sdk').AV
AV.initialize "ub6plmew80eyd77dcq9p75iue0sywi9zunod1tuq94frmvix", "rl6gggtdevzwvk7g5sbmqx1657giipy5x246dkbrx0t8k6tj"
Scheme = AV.Object.extend "Scheme"

data = []

callback = (data) ->
    console.log "data", data.length
    data = data.map (elem) ->
        elem.attributes.colors = JSON.parse(elem.attributes.colors)
        obj = elem.attributes
        obj.createdAt = elem.createdAt
        obj.updatedAt = elem.updatedAt
        obj
    fs.writeFileSync('data/all.json', JSON.stringify(data))

iter = ->
    query = new AV.Query Scheme
    query.skip(data.length)
    query.limit(1000).find({
        success: (schemes) ->
            console.log "schemes", schemes.length
            data = data.concat schemes
            if schemes.length < 1000
                callback data
            else
                iter()
    })

iter()
