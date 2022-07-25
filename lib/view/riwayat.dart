import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Riwayat extends StatefulWidget {
  const Riwayat({Key? key}) : super(key: key);

  @override
  State<Riwayat> createState() => _RiwayatState();
}

class _RiwayatState extends State<Riwayat> {
  List<dynamic> _dataAbsen = [];
  @override
  void initState() {
    // TODO: implement initState
    _getAbsen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat"),
      ),
      body: Container(
        color: Colors.white,
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
            child: Column(
          children: _dataAbsen.map((e) {
            return Container(
              height: 90,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      "Tanggal : ${e['absen']['tanggal'].toString()}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    "Masuk : ${e['masuk'].toString()}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Pulang : ${e['pulang'] != null ? e['pulang'].toString() : 'Belum Absen Pulang'}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        )),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: ((value) {
          if (value == 0) {
            Navigator.pop(context);
          } else if (value == 1) {
            Navigator.popAndPushNamed(context, "/qr");
          }
        }),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: "Absen"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Riwayat"),
        ],
        currentIndex: 2,
      ),
    );
  }

  void _getAbsen() async {
    try {
      String _server = "http://192.168.100.86:8000/api/";
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? server = preferences.getString("server");
      String? token = preferences.getString("token");
      if (server != null) {
        _server = "http://$server/api";
      }
      final response = await Dio().get(
        "$_server/absen/data",
        options: Options(headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        }),
      );
      log(response.data.toString());
      final int status = response.data["status"] as int;
      if (status == 200) {
        final List<dynamic> _tmpData =
            response.data["payload"] as List<dynamic>;
        setState(() {
          _dataAbsen = _tmpData;
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
}
