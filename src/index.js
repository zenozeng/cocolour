(function() {
    var colorsClustering = require('colors-clustering');
    var $ = require('jquery');

    var displayClusters = function(clusters) {
        var html;
        html = clusters.map(function(cluster) {
            var color;
            color = cluster.color;
            return `<div class='color' style='background: rgb(" + (color.join(',')) + ")'></div>`;
        });
        html = "<div class='colors'>" + (html.join('')) + "</div>";
        return document.getElementById("colors").innerHTML = html;
    };

    var handleClusters = function(clusters) {

        // sort by weight
        clusters.sort(function(a, b) {
            return b.weight - a.weight;
        });

        displayClusters(clusters);
    };

    var handleImage = function(src) {
        // handle clusters
        colorsClustering({src: src, minCount: 7}, function(clusters) {
            handleClusters(clusters);
        });

        // update #image
        var img = new Image();
        img.onload = function() {
            var box = document.getElementById("image");
            box.style.lineHeight = 0;
            box.innerHTML = "";
            box.appendChild(img);
        };
        img.src = src;
    };

    // bind events
    var body = document.body;
    var ignore = function(event) {
        event.preventDefault();
    };
    body.ondragover = ignore;
    body.ondragend = ignore;
    body.ondragenter = ignore;
    body.ondragleave = ignore;
    body.ondrag = ignore;
    body.ondrop = function(event) {
        event.preventDefault();
        var url = URL.createObjectURL(event.dataTransfer.files[0]);
        handleImage(url);
    };
})();
