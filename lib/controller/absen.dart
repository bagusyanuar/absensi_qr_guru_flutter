import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> absenHandler(
    Map<String, String> data, BuildContext context) async {
  try {
    String _server = "http://192.168.100.86:8000/api/";
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? server = preferences.getString("server");
    String? token = preferences.getString("token");
    if (server != null) {
      _server = "http://$server/api";
    }
    var formData = FormData.fromMap(data);
    final response = await Dio().post("$_server/absen",
        options: Options(headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        }),
        data: formData);
    final int status = response.data["status"] as int;
    final String message = response.data["message"] as String;
    if (status == 200) {
      Fluttertoast.showToast(
        msg: "Berhasil Absen",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.pop(context);
    }
  } on DioError catch (e) {
    Fluttertoast.showToast(
      msg: "Terjadi Kesalahan " + e.message.toString(),
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
