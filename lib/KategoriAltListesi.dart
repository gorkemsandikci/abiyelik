// ignore: file_names
// ignore_for_file: file_names

import 'package:abiyelik/model/alt_kategoriler_model.dart';
import 'package:abiyelik/model/kategoriler_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'UrunAltKategoriListesi.dart';
import 'UrunKategoriListesi.dart';

class KategoriAltListesi extends StatefulWidget {
  final Student student;
  KategoriAltListesi({required this.student});
  @override
  _KategoriListesi createState() => _KategoriListesi();
}

class _KategoriListesi extends State<KategoriAltListesi> {
  late Future<List<AltKategoriler>> students;
  final kategoriAltListKey = GlobalKey<_KategoriListesi>();

  @override
  void initState() {
    try {
      super.initState();
      students = getStudentList();
    }
    catch (e) {
      print(e);
    }
  }

  Future<List<AltKategoriler>> getStudentList() async {
    final response =
    await http.post(Uri.parse("http://www.umaymusic.com/KategoriAltKategoriler.php"),
      body: {
        'KategoriId': widget.student.Id.toString(),
      },
    );
    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    List<AltKategoriler> students = items.map<AltKategoriler>((json) {
      return AltKategoriler.fromJson(json);
    }).toList();

    return students;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: kategoriAltListKey,
      body:

      Center(
        child: FutureBuilder<List<AltKategoriler>>(
          future: students,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // By default, show a loading spinner.
            if (!snapshot.hasData) return const CircularProgressIndicator();
            // Render student lists
            if(snapshot.data.length == 0) {
              //Alt Kategori yoksa olacaklar
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UrunKategoriListesi(student: widget.student,)),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                var data = snapshot.data[index];
                return
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
                    child: Card(
                      color: const Color(0x77FFFFFF),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundImage:
                          AssetImage('assets/images/slider/1.jpg'),
                        ),
                        title: Text(
                          data.KategoriAdi,
                          style: const TextStyle(fontSize: 15),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UrunAltKategoriListesi(student: data,)),
                          );
                        },
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
