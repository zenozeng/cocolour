// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/hypot

module.exports = Math.hypot || function() {
    var y = 0;
    var length = arguments.length;

    for (var i = 0; i < length; i++) {
        if (arguments[i] === Infinity || arguments[i] === -Infinity) {
            return Infinity;
        }
        y += arguments[i] * arguments[i];
    }
    return Math.sqrt(y);
};
