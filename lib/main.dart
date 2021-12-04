// ignore_for_file: deprecated_member_use, prefer_const_constructors

import 'package:draggable_widget/draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:web_socket_channel/io.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.playTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DragController? dragController = DragController();
  String _userName = 'Ruslan';
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool _showQr = false;
  Barcode? result;
  QRViewController? controller;

  @override
  void initState() {
    super.initState();
    connectToServer();
  }

  // // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  // @override
  // void reassemble() {
  //   super.reassemble();
  //   if (Platform.isAndroid) {
  //     controller!.pauseCamera();
  //   } else if (Platform.isIOS) {
  //     controller!.resumeCamera();
  //   }
  // }

  void _incrementCounter() {
    connectToServer();
  }

  @override
  Widget build(BuildContext context) {
    String? cameraScanResult;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(_userName),
      // ),

      backgroundColor: Color(0xFFF7F8FA),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16.0), bottomRight: Radius.circular(16.0)),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Normandy - control',
                    style: TextStyle(fontSize: 28, color: Colors.blueAccent, fontWeight: FontWeight.w700),
                  ),
                  _userName.isEmpty
                      ? Text('Пользователь не задан')
                      : Text(
                          'Аппаратом управляет: $_userName',
                          style: TextStyle(fontSize: 18, color: Colors.blueAccent, fontWeight: FontWeight.w500),
                        )
                ],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 300,
                height: 300,
                child: Stack(
                  children: [
                    // left
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        height: 100.0,
                        width: 100.0,
                        child: FittedBox(
                          child: FloatingActionButton(
                            backgroundColor: Color(0xFF005FCF).withOpacity(.6),
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.white24,
                              size: 48,
                            ),
                            onPressed: () => sendMessage('left'),
                          ),
                        ),
                      ),
                    ),
                    // top
                    Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        height: 100.0,
                        width: 100.0,
                        child: FittedBox(
                          child: FloatingActionButton(
                            backgroundColor: Color(0xFF005FCF).withOpacity(.6),
                            child: Icon(
                              Icons.arrow_upward_rounded,
                              color: Colors.white24,
                              size: 48,
                            ),
                            onPressed: () => sendMessage('forward'),
                          ),
                        ),
                      ),
                    ),
                    // right
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        height: 100.0,
                        width: 100.0,
                        child: FittedBox(
                          child: FloatingActionButton(
                            backgroundColor: Color(0xFF005FCF).withOpacity(.6),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white24,
                              size: 48,
                            ),
                            onPressed: () => sendMessage('right'),
                          ),
                        ),
                      ),
                    ),
                    // right
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: 100.0,
                        width: 100.0,
                        child: FittedBox(
                          child: FloatingActionButton(
                            backgroundColor: Color(0xFF005FCF).withOpacity(.6),
                            child: Icon(
                              Icons.arrow_downward_rounded,
                              color: Colors.white24,
                              size: 48,
                            ),
                            onPressed: () => sendMessage('downward'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 300,
                height: 300,
                child: Stack(
                  children: [
                    // left
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        height: 100.0,
                        width: 100.0,
                        child: FittedBox(
                          child: FloatingActionButton(
                            backgroundColor: Color(0xFF005FCF).withOpacity(.6),
                            child: Icon(
                              Icons.undo_rounded,
                              color: Colors.white24,
                              size: 36,
                            ),
                            onPressed: () => {sendMessage('rotate_left')},
                          ),
                        ),
                      ),
                    ),
                    // up
                    Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        height: 100.0,
                        width: 100.0,
                        child: FittedBox(
                          child: FloatingActionButton(
                            backgroundColor: Color(0xFF005FCF).withOpacity(.6),
                            child: Icon(
                              Icons.thumb_up_alt_rounded,
                              color: Colors.white24,
                              size: 36,
                            ),
                            onPressed: () => {sendMessage('up')},
                          ),
                        ),
                      ),
                    ),
                    // right
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        height: 100.0,
                        width: 100.0,
                        child: FittedBox(
                          child: FloatingActionButton(
                            backgroundColor: Color(0xFF005FCF).withOpacity(.6),
                            child: Icon(
                              Icons.redo_rounded,
                              color: Colors.white24,
                              size: 36,
                            ),
                            onPressed: () => {sendMessage('rotate_right')},
                          ),
                        ),
                      ),
                    ),
                    // down
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: 100.0,
                        width: 100.0,
                        child: FittedBox(
                          child: FloatingActionButton(
                            backgroundColor: Color(0xFF005FCF).withOpacity(.6),
                            child: Icon(
                              Icons.thumb_down_alt_rounded,
                              color: Colors.white24,
                              size: 36,
                            ),
                            onPressed: () => {sendMessage('down')},
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Positioned(
          //   left: 260,
          //   bottom: 10,
          //   child: FloatingActionButton(
          //     onPressed: () => {},
          //   ),
          // ),
          // Positioned(
          //   left: 340,
          //   bottom: 10,
          //   child: FloatingActionButton(
          //     onPressed: () => {},
          //   ),
          // ),
          // Positioned(
          //   left: 420,
          //   bottom: 10,
          //   child: FloatingActionButton(
          //     onPressed: () => {},
          //   ),
          // ),
          if (_showQr)
            Center(
              child: Container(
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderColor: Colors.red,
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400)
                        ? 300.0
                        : 300.0,
                  ),
                ),
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 10,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_showQr)
                    SizedBox(
                      height: 80.0,
                      width: 80.0,
                      child: FittedBox(
                        child: FloatingActionButton(
                          backgroundColor: Color(0xFF005FCF).withOpacity(.6),
                          child: Icon(
                            Icons.camera,
                            color: Colors.white24,
                            size: 48,
                          ),
                          onPressed: () => {},
                        ),
                      ),
                    ),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    height: 80.0,
                    width: 80.0,
                    child: FittedBox(
                      child: FloatingActionButton(
                        backgroundColor: _userName == '' ? Colors.red.withOpacity(.6) : Colors.green.withOpacity(.6),
                        child: Icon(
                          _showQr
                              ? Icons.close_rounded
                              : (_userName == '' ? Icons.wifi_off_rounded : Icons.wifi_rounded),
                          color: Colors.white24,
                          size: 48,
                        ),
                        onPressed: () async => {
                          setState(() {
                            _showQr = !_showQr;
                          })
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  if (!_showQr)
                    SizedBox(
                      height: 80.0,
                      width: 80.0,
                      child: FittedBox(
                        child: FloatingActionButton(
                          backgroundColor: Color(0xFF005FCF).withOpacity(.6),
                          child: Icon(
                            Icons.sports_esports_rounded,
                            color: Colors.white24,
                            size: 48,
                          ),
                          onPressed: () => {},
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void connectToServer() {
    var channel = IOWebSocketChannel.connect(Uri.parse('ws://127.0.0.1:3000'));
    // var channel = IOWebSocketChannel.connect(Uri.parse('ws://134.0.117.33:3000'));

    // channel.stream.listen((message) {
    //   print(message);

    //   Map x = {'\"kek\"': '\"lol\"', '\"type\"': 1};
    //   channel.sink.add(x.toString());
    //   // channel.sink.close(status.goingAway);
    // });
  }

  void sendMessage(
    String direction,
  ) {
    var channel = IOWebSocketChannel.connect(Uri.parse('ws://127.0.0.1:3000'));
    // var channel = IOWebSocketChannel.connect(Uri.parse('ws://134.0.117.33:3000'));

    Map x = {'\"dir\"': '\"$direction\"', '\"user\"': '\"$_userName\"'};
    channel.sink.add(x.toString());

    // channel.stream.listen((message) {
    //   print(message);

    //   Map x = {'\"dir\"': '\"$direction\"', '\"user\"': '\"$_userName\"'};
    //   channel.sink.add(x.toString());
    //   // channel.sink.close(status.goingAway);
    // });
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        _showQr = false;
        result = scanData;
        _userName = scanData.code.toString();
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}



  // if (false)
  //           Center(
  //             child: Card(
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(15.0),
  //               ),
  //               child: Container(
  //                 width: 360,
  //                 height: 240,
  //                 child: Center(
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       SizedBox(
  //                         height: 8,
  //                       ),
  //                       Text(
  //                         '',
  //                         style: TextStyle(color: Color(0xFF005FCF), fontWeight: FontWeight.w700, fontSize: 24.0),
  //                         textAlign: TextAlign.center,
  //                       ),
  //                       SizedBox(
  //                         height: 8,
  //                       ),
  //                       Text(
  //                         '_cardBody',
  //                         style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20.0),
  //                         textAlign: TextAlign.center,
  //                       ),
  //                       SizedBox(
  //                         height: 32,
  //                       ),
  //                       if (false)
  //                         RaisedButton(
  //                           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(10.0),
  //                           ),
  //                           color: Theme.of(context).primaryColor.withOpacity(0.8),
  //                           child: Text("Выйти из урока", style: TextStyle(color: Colors.white)),
  //                           onPressed: () => {
  //                             // Navigator.of(context).push(
  //                             //   MaterialPageRoute(
  //                             //     builder: (_) => HomePage(),
  //                             //   ),
  //                             // ),
  //                             Navigator.pop(context),
  //                           },
  //                         ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //       ],
  //     ),
  //     // floatingActionButton: FloatingActionButton(
  //     //   onPressed: _incrementCounter,
  //     //   tooltip: 'Increment',
  //     //   child: const Icon(Icons.add),
  //     // ),
  //   );