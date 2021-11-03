// ignore_for_file: file_names

import 'package:abiyelik/model/kategoriler_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'KategoriAltListesi.dart';

class KategoriListesi extends StatefulWidget {
  const KategoriListesi({Key? key}) : super(key: key);

  @override
  _KategoriListesi createState() => _KategoriListesi();
}

class _KategoriListesi extends State<KategoriListesi> {
  late Future<List<Student>> students;
  final kategoriAltListKey = GlobalKey<_KategoriListesi>();

  @override
  void initState() {
    super.initState();

    students = getStudentList();
  }

  Future<List<Student>> getStudentList() async {
    final response =
        await http.get(Uri.parse("http://www.umaymusic.com/kategoriler.php"));
    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    List<Student> students = items.map<Student>((json) {
      return Student.fromJson(json);
    }).toList();

    return students;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: kategoriAltListKey,
      body: Center(
        child: FutureBuilder<List<Student>>(
          future: students,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // By default, show a loading spinner.
            if (!snapshot.hasData) return const CircularProgressIndicator();
            // Render student lists
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                var data = snapshot.data[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => KategoriAltListesi(
                                student: data,
                              )),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 20.0),
                    decoration: BoxDecoration(
                        color: const Color(0x77FFFFFF),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            data.KategoriAdi.toUpperCase(),
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: Image.network(
                              "http://www.umaymusic.com/image/" + data.Image,
                              height: 100,
                            ))
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
