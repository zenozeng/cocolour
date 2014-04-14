(function() {
    var canvas = document.getElementById("canvas");
    var img = document.getElementById("img");
    var ctx = canvas.getContext("2d");
    var ctx2 = document.getElementById("canvas2").getContext('2d');
    ctx.drawImage(img, 0, 0);
    var imgData = ctx.getImageData(0, 0, canvas.width, canvas.height)
    // colors test
    for (var i=0;i<imgData.data.length;i+=4)
    {
        var r = imgData.data[i];
        var g = imgData.data[i+1];
        var b = imgData.data[i+2];
        var hsl = window.rgb2hsl(r, g, b);
        var h = hsl[0];
        var s = hsl[1];
        var l = hsl[2];
        var y = parseInt(i / 4 / 100);
        var x = i / 4 - y * 100;
        var hsla = "hsla("+h+","+s*100+"%,"+l*100+"%, 1)";
        ctx2.fillStyle = hsla;
        ctx2.fillRect(x, y, 1, 1);
    }
    // time test
    var timestamp = (new Date()).getTime();
    for (var i = 0; i < 1000000; i++) {
        window.rgb2hsl(123, 44, 52);
    }
    console.log("1,000,000 rgb2hsl TEST: " + ((new Date()).getTime() - timestamp));
})();
