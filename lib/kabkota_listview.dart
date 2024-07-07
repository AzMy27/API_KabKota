import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:restfull_api_modul/about_developer.dart';
import 'package:restfull_api_modul/detail_kabkota.dart';
import 'package:restfull_api_modul/kabkota.dart';
import 'package:http/http.dart' as http;

class KabKotaListView extends StatefulWidget {
  const KabKotaListView({super.key});

  @override
  State<KabKotaListView> createState() => KabKotaListViewState();
}

class KabKotaListViewState extends State<KabKotaListView> {
  // Hotspot HP
  // static const String URL = 'http://192.168.220.116/kabupaten-kota';
  // static const String URL = 'http://192.168.85.1/kabupaten-kota';

  // jaringan Polbeng
  // static const String URL = 'http://172.16.40.123/kabupaten-kota';
  // Hotspot Polbeng
  // static const String URL = 'http://192.168.85.1/kabupaten-kota';
  // Wi-Fi
  // static const String URL = 'http://192.168.85.1/kabupaten-kota';
  static const String URL = 'http://192.168.0.14/kabupaten-kota';

  // Localhost
  // static const String URL = 'http://127.0.0.1/kabupaten-kota';

  late Future<List<KabKota>> result_data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    result_data = _fetchKabKota();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kabupaten/Kota App'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return AboutDeveloper();
                  },
                ),
              );
            },
            icon: const Icon(Icons.account_circle),
          ),
        ],
      ),
      body: FutureBuilder<List<KabKota>>(
        future: result_data,
        builder: (context, snapshot) {
          return RefreshIndicator(
            child: Center(
              child: _listView(snapshot),
            ),
            onRefresh: _pullRefresh,
          );
        },
      ),
    );
  }

  Future<void> _pullRefresh() async {
    setState(() {
      result_data = _fetchKabKota();
    });
  }

  Widget _listView(AsyncSnapshot<List<KabKota>> snapshot) {
    if (snapshot.hasData) {
      List<KabKota>? data = snapshot.data;
      return _KabKotaListView(data!);
    } else if (snapshot.hasError) {
      return Text("${snapshot.error}");
    }
    return const CircularProgressIndicator();
  }

  Future<List<KabKota>> _fetchKabKota() async {
    var uri = Uri.parse("$URL/api/read_kabkota.php");
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      List jsonData = jsonResponse['data'];
      return jsonData.map<KabKota>((item) => KabKota.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  ListView _KabKotaListView(List<KabKota> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _tile(context, data[index]);
      },
    );
  }

  ListTile _tile(BuildContext context, KabKota data) => ListTile(
        title: Text(
          data.kabupaten_kota,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        ),
        subtitle: Text("Pusat Pemerintahan : ${data.pusat_pemerintahan}"),
        leading: Image.network(
          "$URL/image/logo/${data.logo}",
          width: 50,
          height: 100,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return DetailKabKota(data: data);
              },
            ),
          );
          final snackBar = SnackBar(
            // duration: const Duration(seconds: 1),
            content: Text("Anda memilih ${data.kabupaten_kota}!"),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
      );
}
