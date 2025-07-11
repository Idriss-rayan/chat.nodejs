import 'dart:convert';

import 'package:chat/storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Formular extends StatefulWidget {
  const Formular({super.key});

  @override
  State<Formular> createState() => _FormularState();
}

class _FormularState extends State<Formular> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _number = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // final screen = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        child: Column(
          children: [
            TextField(
              controller: _name,
            ),
            TextField(
              controller: _number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String name = _name.text;
                String number = _number.text;

                var url = Uri.parse('http://localhost:3000');
                // ce block permet d'envoyer enfaite le nom et le number
                var response = await http.post(
                  url,
                  headers: {'content-type': 'application/json'},
                  body: jsonEncode({'name': name, 'number': number}),
                );

                print('Response: ${response.body}');
              },
              child: Text('Envoyer'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Storage()),
                );
              },
              child: Text('Voir'),
            ),
          ],
        ),
      ),
    );
  }
}
