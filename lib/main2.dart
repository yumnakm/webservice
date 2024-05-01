import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CatFact {
  String fakta;
  int panjang;

  CatFact({required this.fakta, required this.panjang});

  factory CatFact.fromJson(Map<String, dynamic> json) {
    return CatFact(
      fakta: json['fact'],
      panjang: json['length'],
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  late Future<CatFact> futureCatFact;
  String url = "https://catfact.ninja/fact";

  Future<CatFact> fetchData() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return CatFact.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal load');
    }
  }

  @override
  void initState() {
    super.initState();
    futureCatFact = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'coba http',
        home: Scaffold(
          appBar: AppBar(
            title: const Text('coba http'),
          ),
          body: Center(
            child: FutureBuilder<CatFact>(
              future: futureCatFact,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        Text(snapshot.data!.fakta),
                        Text(snapshot.data!.panjang.toString())
                      ]));
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
        ));
  }
}
