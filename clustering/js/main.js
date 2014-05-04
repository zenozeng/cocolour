// Generated by CoffeeScript 1.7.1
(function() {
  var img, url;

  window.math = new mathjs;

  url = "test.min.jpg";

  img = new Image();

  img.onload = function() {
    var b, canvas, ctx, g, h, i, image, imgData, maxHeight, maxWidth, points, r, scale, w, _ref, _ref1;
    image = this;
    maxWidth = 200;
    maxHeight = 200;
    scale = Math.max(image.width / maxWidth, image.height / maxHeight, 1);
    _ref = [image.width, image.height].map(function(elem) {
      return parseInt(elem / scale);
    }), w = _ref[0], h = _ref[1];
    canvas = document.createElement("canvas");
    canvas.width = w;
    canvas.height = h;
    ctx = canvas.getContext("2d");
    ctx.drawImage(this, 0, 0, image.width, image.height, 0, 0, w, h);
    document.body.appendChild(canvas);
    imgData = ctx.getImageData(0, 0, w, h);
    points = [];
    i = 0;
    while (i < imgData.data.length) {
      _ref1 = [imgData.data[i], imgData.data[i + 1], imgData.data[i + 2]], r = _ref1[0], g = _ref1[1], b = _ref1[2];
      points.push(window.rgb2hsl(r, g, b));
      i += 4;
    }
    console.log(points.length);
    return window.clustering(points);
  };

  img.src = url;

}).call(this);
