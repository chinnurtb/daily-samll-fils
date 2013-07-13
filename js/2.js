var handle = require("./requestHandlers");
var http = require("http");

function onreq(request, response){
var out = typeof handle.s('/');
console.log("beging"+ out);
response.writeHead(200, {"Content-Type": "text/html"});
    response.write(out);
    response.end();
}

http.createServer(onreq).listen(8080);
console.log("start~~~");
