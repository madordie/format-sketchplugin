function onRun(context) {

    var file_path = context.plugin.url().URLByAppendingPathComponent("Contents").URLByAppendingPathComponent("Sketch").URLByAppendingPathComponent("fill-strings.txt").path()
    var data = NSData.dataWithContentsOfFile(file_path);
    var string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]
    string = [string substringToIndex:string.length()-1]
    var list = [string componentsSeparatedByString:"\n"]

    var sketch = context.api()
    sketch.selectedDocument.selectedLayers.iterateWithFilter("isText", function(layer) {
        layer.text = list[Math.floor(Math.random()*list.length)]
    })
};
