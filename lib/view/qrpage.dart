import 'dart:developer';
import 'dart:io';

import 'package:absensi_qr_guru_flutter/controller/absen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QRpage extends StatefulWidget {
  const QRpage({Key? key}) : super(key: key);

  @override
  State<QRpage> createState() => _QRpageState();
}

class _QRpageState extends State<QRpage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  double _qrLatitude = -7.5654864;
  double _qrLongitude = 110.8434533;

  @override
  void reassemble() {
    // TODO: implement reassemble
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void initState() {
    // TODO: implement initState
    _getQRLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan QR Code"),
      ),
      body: Container(
        color: Colors.black,
        height: double.infinity,
        width: double.infinity,
        child: _buildQrView(context),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: ((value) {
          if (value == 0) {
            Navigator.pop(context);
          } else if (value == 2) {
            Navigator.popAndPushNamed(context, "/riwayat");
          }
        }),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: "Absen"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Riwayat"),
        ],
        currentIndex: 1,
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      if (scanData.code != null) {
        await controller.stopCamera();
        _absen(context, scanData.code.toString());
      }
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  void _absen(BuildContext context, String code) async {
    Map<String, String> data = {
      "code": code,
    };
    SharedPreferences preferences = await SharedPreferences.getInstance();
    double? myLatitude = preferences.getDouble("latitude");
    double? myLongitude = preferences.getDouble("longitude");
    if (myLatitude == _qrLatitude && myLongitude == _qrLongitude) {
      await absenHandler(data, context);
    } else {
      Fluttertoast.showToast(
        msg: "Maaf Lokasi Anda Tidak Sesuai",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.pop(context);
    }
  }

  void _getQRLocation() async {
    try {
      String _server = "http://192.168.100.86:8000/api/";
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? server = preferences.getString("server");
      if (server != null) {
        _server = "http://$server/api";
      }
      final response = await Dio().get(
        "$_server/lokasi",
        options: Options(headers: {"Accept": "application/json"}),
      );
      log(response.data.toString());
      final int status = response.data["status"] as int;
      if (status == 200) {
        final double latitude = response.data["payload"]["latitude"] as double;
        final double longitude =
            response.data["payload"]["longitude"] as double;
        setState(() {
          _qrLatitude = latitude;
          _qrLongitude = longitude;
        });
      }
    } on DioError catch (e) {
      log(e.response!.data.toString());
      Fluttertoast.showToast(
        msg: "Gagal Mendapatkan Lokasi QRCode",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
