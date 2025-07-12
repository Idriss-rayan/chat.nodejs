import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Geth extends StatefulWidget {
  const Geth({super.key});

  @override
  State<Geth> createState() => _GethState();
}

class _GethState extends State<Geth> {
  List<String> numbersList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final url = Uri.parse('http://localhost:3000');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        numbersList = List<String>.from(
          data.map((item) => item['number'].toString()),
        );
        isLoading = false;
      });
    } else {
      setState(() {
        numbersList = ['Erreur lors de la récupération'];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Liste des numéros')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: numbersList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(numbersList[index]),
                );
              },
            ),
    );
  }
}
