import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as Images;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();

  Future<List<int>> makeReceiptImage() async {
    ByteData imageData = await rootBundle.load('assets/av.png');
    List<int> bytes = Uint8List.view(imageData.buffer);
    var srcImage = Images.decodeImage(bytes);

    imageData = await rootBundle.load('assets/ma.png');
    bytes = Uint8List.view(imageData.buffer);
    var dstImage = Images.decodeImage(bytes);

    srcImage = Images.copyResize(srcImage,
        width: dstImage.width ~/ 1.1, height: dstImage.height ~/ 1.4);
    var radius = 90;
    int originX = srcImage.width ~/ 2, originY = srcImage.height ~/ 2; // origin

    for (int y = -radius; y <= radius; y++)
      for (int x = -radius; x <= radius; x++)
        if (x * x + y * y <= radius * radius)
          dstImage.setPixelSafe(originX + x+8, originY + y+10,
              srcImage.getPixelSafe(originX + x, originY + y));
    // else
    //   srcImage.setPixelSafe(originX + x, originY + y, Color(0xFFFFFFFF).value);

    // TODO: WRITE ON TO THE IMAGE
    // Images.Image mergeImage = Images.drawImage(dstImage, srcImage,
    //     dstX: 8,
    //     dstY: 10,
    //     srcX: 0,
    //     srcY: 0,
    //     srcW: srcImage.width,
    //     srcH: srcImage.height);

    // Write it to disk as a different jpeg
    var new_image = Images.encodePng(dstImage);

    return new_image;
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<int> myImage;
  void _incrementCounter() {
    widget.makeReceiptImage().then((List<int> image) {
      setState(() {
        myImage = image;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade100,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            myImage == null ? Text('fdassd') : Image.memory(myImage),
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
