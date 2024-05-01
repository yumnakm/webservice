import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PopulasiTahun {
  int tahun;
  int populasi;
  PopulasiTahun({required this.tahun, required this.populasi});
}

class Populasi {
  List<PopulasiTahun> ListPop = <PopulasiTahun>[];

  Populasi(Map<String, dynamic> json) {
    // isi listPop disini
    var data = json["data"];
    for (var val in data) {
      var tahun = int.parse(val["Year"]); //thn dijadikan int
      var populasi = val["Population"]; //pouliasi sudah int
      ListPop.add(PopulasiTahun(tahun: tahun, populasi: populasi));
    }
  }
  factory Populasi.fromJson(Map<String, dynamic> json) {
    return Populasi(json);
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
  late Future<Populasi> futurePopulasi;

  String url =
      "https://datausa.io/api/data?drilldowns=Nation&measures=Population";

  //fetch data
  Future<Populasi> fetchData() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return Populasi.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal load');
    }
  }

  @override
  void initState() {
    super.initState();
    futurePopulasi = fetchData();
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
            child: FutureBuilder<Populasi>(
              future: futurePopulasi,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Center(
                    //gunakan listview builder
                    child: ListView.builder(
                      itemCount: snapshot
                          .data!.ListPop.length, //asumsikan data ada isi
                      itemBuilder: (context, index) {
                        return Container(
                            decoration: BoxDecoration(border: Border.all()),
                            padding: const EdgeInsets.all(14),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(snapshot.data!.ListPop[index].tahun
                                      .toString()),
                                  Text(snapshot.data!.ListPop[index].populasi
                                      .toString()),
                                ]));
                      },
                    ),
                  );
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
