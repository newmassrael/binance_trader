import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart' hide Interval;
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/status.dart' as status;

void main() => runApp(const MyApp());

void http_test() async {
  String test_key =
      "huqLJDtJwDAYoSDSEDzjyuBsT635YnlDpkg0LWqosjc6HZDfFubR0NtkYWNH2fqW";
  String test_secret =
      "P4HNtYnvm1tBjYvdCDN4ucRNfPIfPh6snBOJlqIbwIC3mErYcZqaFJgcZsJyw0O3";
  String test_net = 'testnet.binance.vision';
  String real_net = 'api.binance.com';

  Map<String, String> header = {};
  header[HttpHeaders.contentTypeHeader] = "application/x-www-form-urlencoded";
  header["X-MBX-APIKEY"] = test_key;

  Map<String, String> params = {};
  params['timestamp'] = DateTime.now().millisecondsSinceEpoch.toString();

  var tempUri = Uri.https('', '', params);

  String queryParams = tempUri.toString().substring(7);
  List<int> messageBytes = utf8.encode(queryParams);
  List<int> key = utf8.encode(test_secret);
  Hmac hmac = Hmac(sha256, key);
  Digest digest = hmac.convert(messageBytes);
  String signature = hex.encode(digest.bytes);
  params['signature'] = signature;

  print(params);

  // final response = await http.get(Uri.https(real_net, "/sapi/v1/system/status"),
  //     headers: header);

  final response = await http.get(
      Uri.https(real_net, "/sapi/v1/account/apiTradingStatus", params),
      headers: header);

  // final response = await http.get(
  //     Uri.https(real_net, "/sapi/v1/capital/config/getall", params),
  //     headers: header);

  // final response =
  //     await http.get(Uri.https(test_net, "/api/v1/time"), headers: header);

  print(response.statusCode);

  if (response.statusCode == 200) {
    // 만약 서버로의 요청이 성공하면, JSON을 파싱합니다.

    print(response.body);
  } else {
    print(response.body);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    http_test();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Binance API tester"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Test"),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
