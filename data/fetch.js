AV.initialize("ub6plmew80eyd77dcq9p75iue0sywi9zunod1tuq94frmvix", "rl6gggtdevzwvk7g5sbmqx1657giipy5x246dkbrx0t8k6tj");
var Scheme = AV.Object.extend("Scheme");
var query = new AV.Query(Scheme);
query.count({
    success: function(count) {
        console.log(count);
    }
});
query.limit(1000).find({
    success: function(data) {
        data = data.map(function(elem) {
            elem.attributes.colors = JSON.parse(elem.attributes.colors);
            return elem.attributes;
        });
        console.log(data.length);
        data = JSON.stringify(data);
        // window.location.href = "data:application/json;charset=UTF-8," + data;
    }
});
