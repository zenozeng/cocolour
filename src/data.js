(function(AV) {
    var appID = "ub6plmew80eyd77dcq9p75iue0sywi9zunod1tuq94frmvix";
    var appKey = "rl6gggtdevzwvk7g5sbmqx1657giipy5x246dkbrx0t8k6tj";
    AV.initialize(appID, appKey);
    var TestObject = AV.Object.extend("TestObject");
    var testObject = new TestObject();
    testObject.save({foo: "bar"}, {
        success: function(object) {
            alert("AVOS Cloud works!");
        }
    });
})(window.AV);
