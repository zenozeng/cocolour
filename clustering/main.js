(function() {
    var canvas = document.getElementById("canvas");
    var img = document.getElementById("img");
    var ctx = canvas.getContext("2d");
    ctx.drawImage(img, 0, 0);
    window.clustering(points);
})();
