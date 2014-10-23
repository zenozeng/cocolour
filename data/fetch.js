var fs = require('fs');

var AV = require('avoscloud-sdk').AV;
AV.initialize("ub6plmew80eyd77dcq9p75iue0sywi9zunod1tuq94frmvix", "rl6gggtdevzwvk7g5sbmqx1657giipy5x246dkbrx0t8k6tj");
var Scheme = AV.Object.extend("Scheme");
var query = new AV.Query(Scheme);
query.limit(1000).find({
    success: function(data) {
        data = data.map(function(elem) {
            elem.attributes.colors = JSON.parse(elem.attributes.colors);
            var obj = elem.attributes;
            obj.createdAt = elem.createdAt;
            obj.updatedAt = elem.updatedAt;
            return obj;
        });
        data = JSON.stringify(data);
        fs.writeFileSync('all.json', data);
    }
});
