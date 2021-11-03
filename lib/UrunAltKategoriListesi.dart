// ignore: file_names
// ignore_for_file: file_names

import 'package:abiyelik/model/alt_kategoriler_model.dart';
import 'package:abiyelik/model/kategoriler_model.dart';
import 'package:abiyelik/model/urunler_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'UrunDetay.dart';

class UrunAltKategoriListesi extends StatefulWidget {
  final AltKategoriler student;
  UrunAltKategoriListesi({required this.student});
  @override
  _UrunListesi createState() => _UrunListesi();
}

class _UrunListesi extends State<UrunAltKategoriListesi> {
  late Future<List<Urun>> students;
  final kategoriAltListKey = GlobalKey<_UrunListesi>();

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

  Future<List<Urun>> getStudentList() async {
    final response =
    await http.post(Uri.parse("http://www.umaymusic.com/Urunler.php"),
      body: {
        'KategoriId': widget.student.Id.toString(),
      },
    );
    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    List<Urun> students = items.map<Urun>((json) {
      return Urun.fromJson(json);
    }).toList();

    return students;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: kategoriAltListKey,
      body: Center(
        child: FutureBuilder<List<Urun>>(
          future: students,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // By default, show a loading spinner.
            if (!snapshot.hasData) return const CircularProgressIndicator();
            // Render student lists
            if(snapshot.data.length == 0) {
              Navigator.of(context).pop();
            }
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                var data = snapshot.data[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
                  child: Card(
                    color: const Color(0x77FFFFFF),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundImage:
                        AssetImage('assets/images/slider/1.jpg'),
                      ),
                      title: Text(
                        data.Name,
                        style: const TextStyle(fontSize: 15),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UrunDetay(student: data,)),
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
