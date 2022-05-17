const XMLHttpRequest = require("xmlhttprequest").XMLHttpRequest;

module.exports.checkAndGetURL = function(filename, callback) {
    if (module.exports.checkURL(filename) === true) {
        module.exports.loadFileAsync(filename, function(response) {
            if (response === null) {
                console.log("File could not be found!");
                callback(null);
            } else {
                callback("Not null");
            }
        });
    } else {
        console.log("Invalid URL!");
        callback("Invalid");
    }
}

module.exports.doPythagoras = function(a,b) {
    cSquare = a*a + b*b;
    return Math.sqrt(cSquare);
}

module.exports.loadFileAsync = function(url, callback) {
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            callback(this.responseText);
        } else if (this.readyState == 4) {
            callback(null);
        }
    };
    xhttp.open("GET", url, true);
    xhttp.send();
}

module.exports.checkURL = function(filename) {
    if (typeof(filename)!=="string" || filename === '') {
        return false;
    } else {
        return true;
    }
}