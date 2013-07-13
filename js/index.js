var server = require("./server");
var route = require("./router");
var handler = require("./requestHandlers");

var handle = {}
handle["/start"] = handler.start;
handle["/upload"] = handler.upload;


server.start(route.route,handle);
