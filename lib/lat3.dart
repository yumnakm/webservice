import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class University {
  late String name;
  late String website;

  University({required this.name, required this.website});

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      name: json['name'],
      website: json['web_pages'][0], 
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<University>> futureUniversities;

  String url = "http://universities.hipolabs.com/search?country=Indonesia";

  Future<List<University>> fetchData() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<University> universities = data
          .map((universityJson) => University.fromJson(universityJson))
          .toList();
      return universities;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    futureUniversities = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'University List',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Indonesian Universities'),
        ),
        body: Center(
          child: FutureBuilder<List<University>>(
            future: futureUniversities,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(
                          snapshot.data![index].name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(snapshot.data![index].website),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
