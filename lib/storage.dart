import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Storage extends StatefulWidget {
  const Storage({super.key});

  @override
  State<Storage> createState() => _StorageState();
}

class _StorageState extends State<Storage> {
  String name = '';
  String number = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final url = Uri.parse('http://localhost:3000/last');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        name = data['name'];
        number = data['number'];
        isLoading = false;
      });
    } else {
      setState(() {
        name = 'Erreur';
        number = 'Erreur';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Données du serveur')),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nom : $name'),
                  Text('Numéro : $number'),
                ],
              ),
      ),
    );
  }
}
