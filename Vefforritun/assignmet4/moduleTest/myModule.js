var ssid = 12345;

function logSSIDReq() { 
    console.log("SSID returned"); 
};

//module.exports is again Node.js syntax
module.exports.getSSID = function () { 
    logSSIDReq(); 
    return ssid; 
};