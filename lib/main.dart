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
    // load avatar image
    ByteData imageData = await rootBundle.load('assets/av.png');
    List<int> bytes = Uint8List.view(imageData.buffer);
    var avatarImage = Images.decodeImage(bytes);

    //load marker image 
    imageData = await rootBundle.load('assets/ma.png');
    bytes = Uint8List.view(imageData.buffer);
    var markerImage = Images.decodeImage(bytes);

    //resize the avatar image to fit inside the marker image
    avatarImage = Images.copyResize(avatarImage,
        width: markerImage.width ~/ 1.1, height: markerImage.height ~/ 1.4);
    

    var radius = 90;
    int originX = avatarImage.width ~/ 2, originY = avatarImage.height ~/ 2;
    
    //draw the avatar image cropped as a circle inside the marker image
    for (int y = -radius; y <= radius; y++)
      for (int x = -radius; x <= radius; x++)
        if (x * x + y * y <= radius * radius)
          markerImage.setPixelSafe(originX + x+8, originY + y+10,
              avatarImage.getPixelSafe(originX + x, originY + y));


    return Images.encodePng(markerImage);
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
