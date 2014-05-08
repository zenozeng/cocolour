(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
/* MIT license */

module.exports = {
  rgb2hsl: rgb2hsl,
  rgb2hsv: rgb2hsv,
  rgb2cmyk: rgb2cmyk,
  rgb2keyword: rgb2keyword,
  rgb2xyz: rgb2xyz,
  rgb2lab: rgb2lab,
  rgb2lch: rgb2lch,

  hsl2rgb: hsl2rgb,
  hsl2hsv: hsl2hsv,
  hsl2cmyk: hsl2cmyk,
  hsl2keyword: hsl2keyword,

  hsv2rgb: hsv2rgb,
  hsv2hsl: hsv2hsl,
  hsv2cmyk: hsv2cmyk,
  hsv2keyword: hsv2keyword,

  cmyk2rgb: cmyk2rgb,
  cmyk2hsl: cmyk2hsl,
  cmyk2hsv: cmyk2hsv,
  cmyk2keyword: cmyk2keyword,
  
  keyword2rgb: keyword2rgb,
  keyword2hsl: keyword2hsl,
  keyword2hsv: keyword2hsv,
  keyword2cmyk: keyword2cmyk,
  keyword2lab: keyword2lab,
  keyword2xyz: keyword2xyz,
  
  xyz2rgb: xyz2rgb,
  xyz2lab: xyz2lab,
  xyz2lch: xyz2lch,
  
  lab2xyz: lab2xyz,
  lab2rgb: lab2rgb,
  lab2lch: lab2lch,

  lch2lab: lch2lab,
  lch2xyz: lch2xyz,
  lch2rgb: lch2rgb,
}


function rgb2hsl(rgb) {
  var r = rgb[0]/255,
      g = rgb[1]/255,
      b = rgb[2]/255,
      min = Math.min(r, g, b),
      max = Math.max(r, g, b),
      delta = max - min,
      h, s, l;

  if (max == min)
    h = 0;
  else if (r == max) 
    h = (g - b) / delta; 
  else if (g == max)
    h = 2 + (b - r) / delta; 
  else if (b == max)
    h = 4 + (r - g)/ delta;

  h = Math.min(h * 60, 360);

  if (h < 0)
    h += 360;

  l = (min + max) / 2;

  if (max == min)
    s = 0;
  else if (l <= 0.5)
    s = delta / (max + min);
  else
    s = delta / (2 - max - min);

  return [h, s * 100, l * 100];
}

function rgb2hsv(rgb) {
  var r = rgb[0],
      g = rgb[1],
      b = rgb[2],
      min = Math.min(r, g, b),
      max = Math.max(r, g, b),
      delta = max - min,
      h, s, v;

  if (max == 0)
    s = 0;
  else
    s = (delta/max * 1000)/10;

  if (max == min)
    h = 0;
  else if (r == max) 
    h = (g - b) / delta; 
  else if (g == max)
    h = 2 + (b - r) / delta; 
  else if (b == max)
    h = 4 + (r - g) / delta;

  h = Math.min(h * 60, 360);

  if (h < 0) 
    h += 360;

  v = ((max / 255) * 1000) / 10;

  return [h, s, v];
}

function rgb2cmyk(rgb) {
  var r = rgb[0] / 255,
      g = rgb[1] / 255,
      b = rgb[2] / 255,
      c, m, y, k;
      
  k = Math.min(1 - r, 1 - g, 1 - b);
  c = (1 - r - k) / (1 - k);
  m = (1 - g - k) / (1 - k);
  y = (1 - b - k) / (1 - k);
  return [c * 100, m * 100, y * 100, k * 100];
}

function rgb2keyword(rgb) {
  return reverseKeywords[JSON.stringify(rgb)];
}

function rgb2xyz(rgb) {
  var r = rgb[0] / 255,
      g = rgb[1] / 255,
      b = rgb[2] / 255;

  // assume sRGB
  r = r > 0.04045 ? Math.pow(((r + 0.055) / 1.055), 2.4) : (r / 12.92);
  g = g > 0.04045 ? Math.pow(((g + 0.055) / 1.055), 2.4) : (g / 12.92);
  b = b > 0.04045 ? Math.pow(((b + 0.055) / 1.055), 2.4) : (b / 12.92);
  
  var x = (r * 0.4124) + (g * 0.3576) + (b * 0.1805);
  var y = (r * 0.2126) + (g * 0.7152) + (b * 0.0722);
  var z = (r * 0.0193) + (g * 0.1192) + (b * 0.9505);

  return [x * 100, y *100, z * 100];
}

function rgb2lab(rgb) {
  var xyz = rgb2xyz(rgb),
        x = xyz[0],
        y = xyz[1],
        z = xyz[2],
        l, a, b;

  x /= 95.047;
  y /= 100;
  z /= 108.883;

  x = x > 0.008856 ? Math.pow(x, 1/3) : (7.787 * x) + (16 / 116);
  y = y > 0.008856 ? Math.pow(y, 1/3) : (7.787 * y) + (16 / 116);
  z = z > 0.008856 ? Math.pow(z, 1/3) : (7.787 * z) + (16 / 116);

  l = (116 * y) - 16;
  a = 500 * (x - y);
  b = 200 * (y - z);
  
  return [l, a, b];
}

function rgb2lch(args) {
  return lab2lch(rgb2lab(args));
}

function hsl2rgb(hsl) {
  var h = hsl[0] / 360,
      s = hsl[1] / 100,
      l = hsl[2] / 100,
      t1, t2, t3, rgb, val;

  if (s == 0) {
    val = l * 255;
    return [val, val, val];
  }

  if (l < 0.5)
    t2 = l * (1 + s);
  else
    t2 = l + s - l * s;
  t1 = 2 * l - t2;

  rgb = [0, 0, 0];
  for (var i = 0; i < 3; i++) {
    t3 = h + 1 / 3 * - (i - 1);
    t3 < 0 && t3++;
    t3 > 1 && t3--;

    if (6 * t3 < 1)
      val = t1 + (t2 - t1) * 6 * t3;
    else if (2 * t3 < 1)
      val = t2;
    else if (3 * t3 < 2)
      val = t1 + (t2 - t1) * (2 / 3 - t3) * 6;
    else
      val = t1;

    rgb[i] = val * 255;
  }
  
  return rgb;
}

function hsl2hsv(hsl) {
  var h = hsl[0],
      s = hsl[1] / 100,
      l = hsl[2] / 100,
      sv, v;
  l *= 2;
  s *= (l <= 1) ? l : 2 - l;
  v = (l + s) / 2;
  sv = (2 * s) / (l + s);
  return [h, sv * 100, v * 100];
}

function hsl2cmyk(args) {
  return rgb2cmyk(hsl2rgb(args));
}

function hsl2keyword(args) {
  return rgb2keyword(hsl2rgb(args));
}


function hsv2rgb(hsv) {
  var h = hsv[0] / 60,
      s = hsv[1] / 100,
      v = hsv[2] / 100,
      hi = Math.floor(h) % 6;

  var f = h - Math.floor(h),
      p = 255 * v * (1 - s),
      q = 255 * v * (1 - (s * f)),
      t = 255 * v * (1 - (s * (1 - f))),
      v = 255 * v;

  switch(hi) {
    case 0:
      return [v, t, p];
    case 1:
      return [q, v, p];
    case 2:
      return [p, v, t];
    case 3:
      return [p, q, v];
    case 4:
      return [t, p, v];
    case 5:
      return [v, p, q];
  }
}

function hsv2hsl(hsv) {
  var h = hsv[0],
      s = hsv[1] / 100,
      v = hsv[2] / 100,
      sl, l;

  l = (2 - s) * v;  
  sl = s * v;
  sl /= (l <= 1) ? l : 2 - l;
  l /= 2;
  return [h, sl * 100, l * 100];
}

function hsv2cmyk(args) {
  return rgb2cmyk(hsv2rgb(args));
}

function hsv2keyword(args) {
  return rgb2keyword(hsv2rgb(args));
}

function cmyk2rgb(cmyk) {
  var c = cmyk[0] / 100,
      m = cmyk[1] / 100,
      y = cmyk[2] / 100,
      k = cmyk[3] / 100,
      r, g, b;

  r = 1 - Math.min(1, c * (1 - k) + k);
  g = 1 - Math.min(1, m * (1 - k) + k);
  b = 1 - Math.min(1, y * (1 - k) + k);
  return [r * 255, g * 255, b * 255];
}

function cmyk2hsl(args) {
  return rgb2hsl(cmyk2rgb(args));
}

function cmyk2hsv(args) {
  return rgb2hsv(cmyk2rgb(args));
}

function cmyk2keyword(args) {
  return rgb2keyword(cmyk2rgb(args));
}


function xyz2rgb(xyz) {
  var x = xyz[0] / 100,
      y = xyz[1] / 100,
      z = xyz[2] / 100,
      r, g, b;

  r = (x * 3.2406) + (y * -1.5372) + (z * -0.4986);
  g = (x * -0.9689) + (y * 1.8758) + (z * 0.0415);
  b = (x * 0.0557) + (y * -0.2040) + (z * 1.0570);

  // assume sRGB
  r = r > 0.0031308 ? ((1.055 * Math.pow(r, 1.0 / 2.4)) - 0.055)
    : r = (r * 12.92);

  g = g > 0.0031308 ? ((1.055 * Math.pow(g, 1.0 / 2.4)) - 0.055)
    : g = (g * 12.92);
        
  b = b > 0.0031308 ? ((1.055 * Math.pow(b, 1.0 / 2.4)) - 0.055)
    : b = (b * 12.92);

  r = Math.min(Math.max(0, r), 1);
  g = Math.min(Math.max(0, g), 1);
  b = Math.min(Math.max(0, b), 1);

  return [r * 255, g * 255, b * 255];
}

function xyz2lab(xyz) {
  var x = xyz[0],
      y = xyz[1],
      z = xyz[2],
      l, a, b;

  x /= 95.047;
  y /= 100;
  z /= 108.883;

  x = x > 0.008856 ? Math.pow(x, 1/3) : (7.787 * x) + (16 / 116);
  y = y > 0.008856 ? Math.pow(y, 1/3) : (7.787 * y) + (16 / 116);
  z = z > 0.008856 ? Math.pow(z, 1/3) : (7.787 * z) + (16 / 116);

  l = (116 * y) - 16;
  a = 500 * (x - y);
  b = 200 * (y - z);
  
  return [l, a, b];
}

function xyz2lch(args) {
  return lab2lch(xyz2lab(args));
}

function lab2xyz(lab) {
  var l = lab[0],
      a = lab[1],
      b = lab[2],
      x, y, z, y2;

  if (l <= 8) {
    y = (l * 100) / 903.3;
    y2 = (7.787 * (y / 100)) + (16 / 116);
  } else {
    y = 100 * Math.pow((l + 16) / 116, 3);
    y2 = Math.pow(y / 100, 1/3);
  }

  x = x / 95.047 <= 0.008856 ? x = (95.047 * ((a / 500) + y2 - (16 / 116))) / 7.787 : 95.047 * Math.pow((a / 500) + y2, 3);

  z = z / 108.883 <= 0.008859 ? z = (108.883 * (y2 - (b / 200) - (16 / 116))) / 7.787 : 108.883 * Math.pow(y2 - (b / 200), 3);

  return [x, y, z];
}

function lab2lch(lab) {
  var l = lab[0],
      a = lab[1],
      b = lab[2],
      hr, h, c;

  hr = Math.atan2(b, a);
  h = hr * 360 / 2 / Math.PI;
  if (h < 0) {
    h += 360;
  }
  c = Math.sqrt(a * a + b * b);
  return [l, c, h];
}

function lab2rgb(args) {
  return xyz2rgb(lab2xyz(args));
}

function lch2lab(lch) {
  var l = lch[0],
      c = lch[1],
      h = lch[2],
      a, b, hr;

  hr = h / 360 * 2 * Math.PI;
  a = c * Math.cos(hr);
  b = c * Math.sin(hr);
  return [l, a, b];
}

function lch2xyz(args) {
  return lab2xyz(lch2lab(args));
}

function lch2rgb(args) {
  return lab2rgb(lch2lab(args));
}

function keyword2rgb(keyword) {
  return cssKeywords[keyword];
}

function keyword2hsl(args) {
  return rgb2hsl(keyword2rgb(args));
}

function keyword2hsv(args) {
  return rgb2hsv(keyword2rgb(args));
}

function keyword2cmyk(args) {
  return rgb2cmyk(keyword2rgb(args));
}

function keyword2lab(args) {
  return rgb2lab(keyword2rgb(args));
}

function keyword2xyz(args) {
  return rgb2xyz(keyword2rgb(args));
}

var cssKeywords = {
  aliceblue:  [240,248,255],
  antiquewhite: [250,235,215],
  aqua: [0,255,255],
  aquamarine: [127,255,212],
  azure:  [240,255,255],
  beige:  [245,245,220],
  bisque: [255,228,196],
  black:  [0,0,0],
  blanchedalmond: [255,235,205],
  blue: [0,0,255],
  blueviolet: [138,43,226],
  brown:  [165,42,42],
  burlywood:  [222,184,135],
  cadetblue:  [95,158,160],
  chartreuse: [127,255,0],
  chocolate:  [210,105,30],
  coral:  [255,127,80],
  cornflowerblue: [100,149,237],
  cornsilk: [255,248,220],
  crimson:  [220,20,60],
  cyan: [0,255,255],
  darkblue: [0,0,139],
  darkcyan: [0,139,139],
  darkgoldenrod:  [184,134,11],
  darkgray: [169,169,169],
  darkgreen:  [0,100,0],
  darkgrey: [169,169,169],
  darkkhaki:  [189,183,107],
  darkmagenta:  [139,0,139],
  darkolivegreen: [85,107,47],
  darkorange: [255,140,0],
  darkorchid: [153,50,204],
  darkred:  [139,0,0],
  darksalmon: [233,150,122],
  darkseagreen: [143,188,143],
  darkslateblue:  [72,61,139],
  darkslategray:  [47,79,79],
  darkslategrey:  [47,79,79],
  darkturquoise:  [0,206,209],
  darkviolet: [148,0,211],
  deeppink: [255,20,147],
  deepskyblue:  [0,191,255],
  dimgray:  [105,105,105],
  dimgrey:  [105,105,105],
  dodgerblue: [30,144,255],
  firebrick:  [178,34,34],
  floralwhite:  [255,250,240],
  forestgreen:  [34,139,34],
  fuchsia:  [255,0,255],
  gainsboro:  [220,220,220],
  ghostwhite: [248,248,255],
  gold: [255,215,0],
  goldenrod:  [218,165,32],
  gray: [128,128,128],
  green:  [0,128,0],
  greenyellow:  [173,255,47],
  grey: [128,128,128],
  honeydew: [240,255,240],
  hotpink:  [255,105,180],
  indianred:  [205,92,92],
  indigo: [75,0,130],
  ivory:  [255,255,240],
  khaki:  [240,230,140],
  lavender: [230,230,250],
  lavenderblush:  [255,240,245],
  lawngreen:  [124,252,0],
  lemonchiffon: [255,250,205],
  lightblue:  [173,216,230],
  lightcoral: [240,128,128],
  lightcyan:  [224,255,255],
  lightgoldenrodyellow: [250,250,210],
  lightgray:  [211,211,211],
  lightgreen: [144,238,144],
  lightgrey:  [211,211,211],
  lightpink:  [255,182,193],
  lightsalmon:  [255,160,122],
  lightseagreen:  [32,178,170],
  lightskyblue: [135,206,250],
  lightslategray: [119,136,153],
  lightslategrey: [119,136,153],
  lightsteelblue: [176,196,222],
  lightyellow:  [255,255,224],
  lime: [0,255,0],
  limegreen:  [50,205,50],
  linen:  [250,240,230],
  magenta:  [255,0,255],
  maroon: [128,0,0],
  mediumaquamarine: [102,205,170],
  mediumblue: [0,0,205],
  mediumorchid: [186,85,211],
  mediumpurple: [147,112,219],
  mediumseagreen: [60,179,113],
  mediumslateblue:  [123,104,238],
  mediumspringgreen:  [0,250,154],
  mediumturquoise:  [72,209,204],
  mediumvioletred:  [199,21,133],
  midnightblue: [25,25,112],
  mintcream:  [245,255,250],
  mistyrose:  [255,228,225],
  moccasin: [255,228,181],
  navajowhite:  [255,222,173],
  navy: [0,0,128],
  oldlace:  [253,245,230],
  olive:  [128,128,0],
  olivedrab:  [107,142,35],
  orange: [255,165,0],
  orangered:  [255,69,0],
  orchid: [218,112,214],
  palegoldenrod:  [238,232,170],
  palegreen:  [152,251,152],
  paleturquoise:  [175,238,238],
  palevioletred:  [219,112,147],
  papayawhip: [255,239,213],
  peachpuff:  [255,218,185],
  peru: [205,133,63],
  pink: [255,192,203],
  plum: [221,160,221],
  powderblue: [176,224,230],
  purple: [128,0,128],
  red:  [255,0,0],
  rosybrown:  [188,143,143],
  royalblue:  [65,105,225],
  saddlebrown:  [139,69,19],
  salmon: [250,128,114],
  sandybrown: [244,164,96],
  seagreen: [46,139,87],
  seashell: [255,245,238],
  sienna: [160,82,45],
  silver: [192,192,192],
  skyblue:  [135,206,235],
  slateblue:  [106,90,205],
  slategray:  [112,128,144],
  slategrey:  [112,128,144],
  snow: [255,250,250],
  springgreen:  [0,255,127],
  steelblue:  [70,130,180],
  tan:  [210,180,140],
  teal: [0,128,128],
  thistle:  [216,191,216],
  tomato: [255,99,71],
  turquoise:  [64,224,208],
  violet: [238,130,238],
  wheat:  [245,222,179],
  white:  [255,255,255],
  whitesmoke: [245,245,245],
  yellow: [255,255,0],
  yellowgreen:  [154,205,50]
};

var reverseKeywords = {};
for (var key in cssKeywords) {
  reverseKeywords[JSON.stringify(cssKeywords[key])] = key;
}

},{}],2:[function(require,module,exports){
var conversions = require("./conversions");

var convert = function() {
   return new Converter();
}

for (var func in conversions) {
  // export Raw versions
  convert[func + "Raw"] =  (function(func) {
    // accept array or plain args
    return function(arg) {
      if (typeof arg == "number")
        arg = Array.prototype.slice.call(arguments);
      return conversions[func](arg);
    }
  })(func);

  var pair = /(\w+)2(\w+)/.exec(func),
      from = pair[1],
      to = pair[2];

  // export rgb2hsl and ["rgb"]["hsl"]
  convert[from] = convert[from] || {};

  convert[from][to] = convert[func] = (function(func) { 
    return function(arg) {
      if (typeof arg == "number") {
        arg = Array.prototype.slice.call(arguments);        
      }
      
      var val = conversions[func](arg);
      if (typeof val == "string" || val === undefined) {
        return val; // keyword        
      }

      round(val)
      return val;
    }
  })(func);
}


/* Converter does lazy conversion and caching */
var Converter = function() {
   this.space = "rgb";
   this.convs = {
     'rgb': [0, 0, 0]
   };
};

/* Either get the values for a space or
  set the values for a space, depending on args */
Converter.prototype.routeSpace = function(space, args) {
   var values = args[0];
   if (values === undefined) {
      // color.rgb()
      return this.getValues(space);
   }
   // color.rgb(10, 10, 10)
   if (typeof values == "number") {
      values = Array.prototype.slice.call(args);        
   }

   return this.setValues(space, values);
};
  
/* Set the values for a space, invalidating cache */
Converter.prototype.setValues = function(space, values) {
   this.space = space;
   this.convs = {};
   this.convs[space] = values;
   return this;
};

/* Get the values for a space. If there's already
  a conversion for the space, fetch it, otherwise
  compute it */
Converter.prototype.getValues = function(space) {
   var vals = this.convs[space];
   if (!vals) {
      var fspace = this.space,
          from = this.convs[fspace];
      vals = convert[fspace][space](from);

      this.convs[space] = vals;
   }
   else {
      round(vals);
   }
  return vals;
};

function round(val) {
  for (var i = 0; i < val.length; i++) {
    val[i] = Math.round(val[i]);        
  }
};

["rgb", "hsl", "hsv", "cmyk", "keyword"].forEach(function(space) {
   Converter.prototype[space] = function(vals) {
      return this.routeSpace(space, arguments);
   }
});

module.exports = convert;
},{"./conversions":1}],3:[function(require,module,exports){
// Generated by CoffeeScript 1.7.1
(function() {
  var Canvas, Image, calcClusters, clustering;

  calcClusters = require("./lib/clustering.js");

  Canvas = require("canvas-browserify");

  Image = Canvas.Image;

  clustering = function(config, callback) {
    var defaultConfig, img, k, timeImgStart, v;
    defaultConfig = {
      debug: false,
      maxWidth: 30,
      maxHeight: 30,
      minCount: 1
    };
    for (k in config) {
      v = config[k];
      defaultConfig[k] = v;
    }
    config = defaultConfig;
    img = new Image;
    timeImgStart = (new Date()).getTime();
    img.onload = function() {
      var canvas, ctx, height, i, image, imgData, pixels, scale, timeStart, width, _ref;
      if (config.debug) {
        console.log("load image in " + ((new Date()).getTime() - timeImgStart) + "ms");
      }
      timeStart = (new Date()).getTime();
      image = this;
      scale = Math.max(image.width / config.maxWidth, image.height / config.maxHeight, 1);
      _ref = [image.width, image.height].map(function(elem) {
        return parseInt(elem / scale);
      }), width = _ref[0], height = _ref[1];
      canvas = new Canvas(width, height);
      ctx = canvas.getContext("2d");
      ctx.drawImage(this, 0, 0, image.width, image.height, 0, 0, width, height);
      imgData = ctx.getImageData(0, 0, width, height);
      pixels = [];
      i = 0;
      while (i < imgData.data.length) {
        pixels.push([imgData.data[i], imgData.data[i + 1], imgData.data[i + 2], imgData.data[i + 3]]);
        i += 4;
      }
      if (config.debug) {
        console.log("parse image in " + ((new Date()).getTime() - timeStart) + "ms");
      }
      return typeof callback === "function" ? callback(calcClusters(pixels, config)) : void 0;
    };
    return img.src = config.src;
  };

  module.exports = clustering;

}).call(this);

},{"./lib/clustering.js":5,"canvas-browserify":7}],4:[function(require,module,exports){
// Generated by CoffeeScript 1.7.1
(function() {
  var CIE76;

  CIE76 = function(lab1, lab2) {
    var sum;
    sum = 0;
    lab1.forEach(function(val, i) {
      return sum += Math.pow(val - lab2[i], 2);
    });
    return Math.sqrt(sum);
  };

  module.exports = CIE76;

}).call(this);

},{}],5:[function(require,module,exports){
// Generated by CoffeeScript 1.7.1
(function() {
  var calcCenter, calcClusters, calcDistance, color, seeds;

  color = require("color-convert");

  calcDistance = require("./CIE76.js");

  seeds = require("./seeds.js");

  calcCenter = function(labs) {
    var A, B, L, d, lab, len, minDistance, newCenter, _i, _len, _ref;
    _ref = [0, 0, 0], L = _ref[0], A = _ref[1], B = _ref[2];
    labs.forEach(function(lab) {
      L += lab[0];
      A += lab[1];
      return B += lab[2];
    });
    len = labs.length;
    L /= len;
    A /= len;
    B /= len;
    minDistance = null;
    newCenter = null;
    for (_i = 0, _len = labs.length; _i < _len; _i++) {
      lab = labs[_i];
      d = calcDistance([L, A, B], lab);
      if ((newCenter == null) || (d > minDistance)) {
        minDistance = d;
        newCenter = lab;
      }
    }
    return newCenter;
  };

  calcClusters = function(pixels, config) {
    var centers, clusters, end, iter, log, removeEmptyClusters, start, useRandomPixels;
    start = (new Date()).getTime();
    log = function(title, colors) {
      if (colors == null) {
        colors = [];
      }
      if (config.debug) {
        return typeof config.log === "function" ? config.log(title, colors.map(function(lab) {
          return color.lab2rgb(lab);
        })) : void 0;
      }
    };
    pixels = pixels.map(function(rgba) {
      var a, b, g, r, rgb;
      r = rgba[0], g = rgba[1], b = rgba[2], a = rgba[3];
      rgb = [r, g, b];
      if (a !== 255) {
        a /= 255;
        rgb = rgb.map(function(elem) {
          return 255 * (1 - a) + elem * a;
        });
      }
      return color.rgb2lab(rgb);
    });
    centers = seeds.map(function(rgb) {
      return color.rgb2lab(rgb);
    });
    log("Seeds", centers);
    clusters = null;
    iter = function(removeEmptyClusters, useRandomPixels) {
      var i, minDistance, minIndex, pixel, _i, _j, _len, _ref;
      if (removeEmptyClusters == null) {
        removeEmptyClusters = true;
      }
      if (useRandomPixels == null) {
        useRandomPixels = true;
      }
      clusters = [];
      for (i = _i = 0, _ref = centers.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
        clusters[i] = [];
      }
      for (_j = 0, _len = pixels.length; _j < _len; _j++) {
        pixel = pixels[_j];
        minIndex = null;
        minDistance = null;
        centers.forEach(function(center, index) {
          var d;
          d = calcDistance(center, pixel);
          if ((minDistance == null) || (d < minDistance)) {
            minIndex = index;
            return minDistance = d;
          }
        });
        clusters[minIndex].push(pixel);
      }
      if (removeEmptyClusters) {
        clusters = clusters.filter(function(clusterPixels) {
          return clusterPixels.length > 0;
        });
      }
      centers = clusters.map(function(clusterPixels) {
        return calcCenter(clusterPixels);
      });
      if (useRandomPixels) {
        while (centers.length < config.minCount) {
          centers.push(pixels[parseInt(Math.random() * pixels.length)]);
        }
      }
      return log("New Clusters", centers);
    };
    iter();
    iter();
    iter();
    iter(removeEmptyClusters = false, useRandomPixels = false);
    centers = centers.map(function(lab) {
      return color.lab2rgb(lab);
    });
    end = (new Date()).getTime();
    log("Calc " + centers.length + " clusters in " + (end - start) + "ms");
    return centers.map(function(center, i) {
      var weight;
      weight = clusters[i].length / pixels.length;
      return {
        color: center,
        weight: weight
      };
    });
  };

  module.exports = calcClusters;

}).call(this);

},{"./CIE76.js":4,"./seeds.js":6,"color-convert":2}],6:[function(require,module,exports){
// Generated by CoffeeScript 1.7.1
(function() {
  var seeds;

  seeds = "240,248,255\n250,235,215\n0,255,255\n127,255,212\n240,255,255\n245,245,220\n255,228,196\n0,0,0\n255,235,205\n0,0,255\n138,43,226\n165,42,42\n222,184,135\n95,158,160\n127,255,0\n210,105,30\n255,127,80\n100,149,237\n255,248,220\n220,20,60\n0,255,255\n0,0,139\n0,139,139\n184,134,11\n169,169,169\n0,100,0\n169,169,169\n189,183,107\n139,0,139\n85,107,47\n255,140,0\n153,50,204\n139,0,0\n233,150,122\n143,188,143\n72,61,139\n47,79,79\n47,79,79\n0,206,209\n148,0,211\n255,20,147\n0,191,255\n105,105,105\n105,105,105\n30,144,255\n178,34,34\n255,250,240\n34,139,34\n255,0,255\n220,220,220\n248,248,255\n255,215,0\n218,165,32\n128,128,128\n0,128,0\n173,255,47\n128,128,128\n240,255,240\n255,105,180\n205,92,92\n75,0,130\n255,255,240\n240,230,140\n230,230,250\n255,240,245\n124,252,0\n255,250,205\n173,216,230\n240,128,128\n224,255,255\n250,250,210\n211,211,211\n144,238,144\n211,211,211\n255,182,193\n255,160,122\n32,178,170\n135,206,250\n119,136,153\n119,136,153\n176,196,222\n255,255,224\n0,255,0\n50,205,50\n250,240,230\n255,0,255\n128,0,0\n102,205,170\n0,0,205\n186,85,211\n147,112,219\n60,179,113\n123,104,238\n0,250,154\n72,209,204\n199,21,133\n25,25,112\n245,255,250\n255,228,225\n255,228,181\n255,222,173\n0,0,128\n253,245,230\n128,128,0\n107,142,35\n255,165,0\n255,69,0\n218,112,214\n238,232,170\n152,251,152\n175,238,238\n219,112,147\n255,239,213\n255,218,185\n205,133,63\n255,192,203\n221,160,221\n176,224,230\n128,0,128\n255,0,0\n188,143,143\n65,105,225\n139,69,19\n250,128,114\n244,164,96\n46,139,87\n255,245,238\n160,82,45\n192,192,192\n135,206,235\n106,90,205\n112,128,144\n112,128,144\n255,250,250\n0,255,127\n70,130,180\n210,180,140\n0,128,128\n216,191,216\n255,99,71\n64,224,208\n238,130,238\n245,222,179\n255,255,255\n245,245,245\n255,255,0\n154,205,50";

  seeds = seeds.split("\n").map(function(line) {
    return line.split(",");
  });

  module.exports = seeds;

}).call(this);

},{}],7:[function(require,module,exports){

var Canvas = module.exports = function Canvas (w, h) {
  var canvas = document.createElement('canvas')
  canvas.width = w || 300
  canvas.height = h || 150
  return canvas
}

Canvas.Image = function () {
  var img = document.createElement('img')
  return img
}




},{}],8:[function(require,module,exports){
var box, colorsClustering, display;

colorsClustering = require("colors-clustering");

display = function(clusters) {
  var html;
  html = clusters.map(function(cluster) {
    var color;
    color = cluster.color;
    return "<div class='color' style='background: rgb(" + (color.join(',')) + ")'></div>";
  });
  html = "<div class='colors'>" + (html.join('')) + "</div>";
  return document.getElementById("colors").innerHTML = html;
};

box = document.getElementById("image");

box.ondragover = function(event) {
  this.className = 'hover';
  return event.preventDefault();
};

box.ondragend = function(event) {
  this.className = '';
  return event.preventDefault();
};

box.ondrop = function(event) {
  var config, img, url;
  box.style.lineHeight = 0;
  document.getElementById("colors").innerHTML = "Calculating...";
  event.preventDefault();
  url = URL.createObjectURL(event.dataTransfer.files[0]);
  config = {
    src: url,
    minCount: 7
  };
  colorsClustering(config, function(clusters) {
    var C, colorMatchings, html;
    display(clusters);
    colorMatchings = [];
    C = function(arr, n) {
      var iter, results;
      results = [];
      iter = function(t, arr, n) {
        var i, _i, _ref, _results;
        if (n === 0) {
          return results.push(t);
        } else {
          _results = [];
          for (i = _i = 0, _ref = arr.length - n; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
            _results.push(iter(t.concat(arr[i]), arr.slice(i + 1), n - 1));
          }
          return _results;
        }
      };
      iter([], arr, n);
      return results;
    };
    colorMatchings = C([0, 1, 2, 3, 4, 5, 6], 5).map(function(colorMatching) {
      return colorMatching.map(function(i) {
        return clusters[i].color;
      });
    });
    html = colorMatchings.map(function(colors) {
      var tmp;
      tmp = colors.map(function(color) {
        return "<div class='color' style='background: rgb(" + (color.join(',')) + ")'></div>";
      });
      return "<div class='scheme'>" + (tmp.join('')) + "</div>";
    });
    return document.getElementById("schemes").innerHTML = html.join('');
  });
  img = new Image;
  img.src = url;
  return img.onload = function() {
    box.innerHTML = "";
    return box.appendChild(img);
  };
};


},{"colors-clustering":3}]},{},[8])