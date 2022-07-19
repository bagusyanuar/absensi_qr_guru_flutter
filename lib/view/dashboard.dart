import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String _myLatitude = '';
  String _myLongitude = '';
  @override
  void initState() {
    // TODO: implement initState
    _getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.green[800],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Text(
                        "Lokasi Saya : ($_myLatitude , $_myLongitude)",
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/qr");
                      },
                      child: Container(
                        height: 120,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/absen.png"),
                                    fit: BoxFit.contain),
                              ),
                            ),
                            const Text(
                              "Absen Masuk",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 120,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/istirahat.png"),
                                  fit: BoxFit.contain),
                            ),
                          ),
                          const Text(
                            "Istirahat",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 60,
                            width: 100,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/pulang.png"),
                                  fit: BoxFit.contain),
                            ),
                          ),
                          const Text(
                            "Absen Pulang",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _getLocation() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    double? latitude = preferences.getDouble("latitude");
    double? longitude = preferences.getDouble("longitude");
    if (latitude != null && longitude != null) {
      setState(() {
        _myLatitude = latitude.toString();
        _myLongitude = longitude.toString();
      });
    }
  }
}

// class Dashboard extends StatefulWidget {
//   const Dashboard({Key? key}) : super(key: key);

//   @override
//   State<Dashboard> createState() => _DashboardState();
// }

// class _DashboardState extends State<Dashboard> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   Barcode? result;
//   QRViewController? controller;

//   @override
//   void reassemble() {
//     // TODO: implement reassemble
//     super.reassemble();
//     if (Platform.isAndroid) {
//       controller!.pauseCamera();
//     }
//     controller!.resumeCamera();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: <Widget>[
//           Expanded(flex: 4, child: _buildQrView(context)),
//           Expanded(
//             flex: 1,
//             child: FittedBox(
//               fit: BoxFit.contain,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   if (result != null)
//                     Text('Barcode Type:  Data: ${result!.code}')
//                   else
//                     const Text('Scan a code'),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       Container(
//                         margin: const EdgeInsets.all(8),
//                         child: ElevatedButton(
//                             onPressed: () async {
//                               await controller?.toggleFlash();
//                               setState(() {});
//                             },
//                             child: FutureBuilder(
//                               future: controller?.getFlashStatus(),
//                               builder: (context, snapshot) {
//                                 return Text('Flash: ${snapshot.data}');
//                               },
//                             )),
//                       ),
//                       Container(
//                         margin: const EdgeInsets.all(8),
//                         child: ElevatedButton(
//                             onPressed: () async {
//                               await controller?.flipCamera();
//                               setState(() {});
//                             },
//                             child: FutureBuilder(
//                               future: controller?.getCameraInfo(),
//                               builder: (context, snapshot) {
//                                 if (snapshot.data != null) {
//                                   return Text('Camera facing');
//                                 } else {
//                                   return const Text('loading');
//                                 }
//                               },
//                             )),
//                       )
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       Container(
//                         margin: const EdgeInsets.all(8),
//                         child: ElevatedButton(
//                           onPressed: () async {
//                             await controller?.pauseCamera();
//                           },
//                           child: const Text('pause',
//                               style: TextStyle(fontSize: 20)),
//                         ),
//                       ),
//                       Container(
//                         margin: const EdgeInsets.all(8),
//                         child: ElevatedButton(
//                           onPressed: () async {
//                             await controller?.resumeCamera();
//                           },
//                           child: const Text('resume',
//                               style: TextStyle(fontSize: 20)),
//                         ),
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildQrView(BuildContext context) {
//     // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
//     var scanArea = (MediaQuery.of(context).size.width < 400 ||
//             MediaQuery.of(context).size.height < 400)
//         ? 250.0
//         : 300.0;
//     // To ensure the Scanner view is properly sizes after rotation
//     // we need to listen for Flutter SizeChanged notification and update controller
//     return QRView(
//       key: qrKey,
//       onQRViewCreated: _onQRViewCreated,
//       overlay: QrScannerOverlayShape(
//           borderColor: Colors.red,
//           borderRadius: 10,
//           borderLength: 30,
//           borderWidth: 10,
//           cutOutSize: scanArea),
//       onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     setState(() {
//       this.controller = controller;
//     });
//     controller.scannedDataStream.listen((scanData) async {
//       if (scanData.code != null) {
//         await controller.pauseCamera();
//       }
//       setState(() {
//         result = scanData;
//       });
//     });
//   }

//   void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
//     log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
//     if (!p) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('no Permission')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
// }
