import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart' hide Interval;
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';
import 'dart:convert';

void main() => runApp(const MyApp());

void http_test() async {
  String test_key =
      "huqLJDtJwDAYoSDSEDzjyuBsT635YnlDpkg0LWqosjc6HZDfFubR0NtkYWNH2fqW";
  String test_secret =
      "P4HNtYnvm1tBjYvdCDN4ucRNfPIfPh6snBOJlqIbwIC3mErYcZqaFJgcZsJyw0O3";
  String testnet = 'testnet.binance.vision';

  Map<String, String> header = {};
  header[HttpHeaders.contentTypeHeader] = "application/x-www-form-urlencoded";
  header["X-MBX-APIKEY"] = test_key;

  Map<String, String> params = {};
  params['symbol'] = "BTCUSDT";
  params['side'] = "BUY";
  params['type'] = "MARKET";
  params['quantity'] = "1";

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

  final response = await http.post(Uri.https(testnet, "/api/v3/order", params),
      headers: header);

  print(response.statusCode);
  print(response.body);
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
