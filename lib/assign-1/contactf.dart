import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Contactf extends StatefulWidget {
  const Contactf({super.key});

  @override
  State<Contactf> createState() => _ContactfState();
}

class _ContactfState extends State<Contactf> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _message = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          children: [
            TextField(
              controller: _name,
              decoration: InputDecoration(
                  hintText: 'name ',
                  hintStyle: TextStyle(
                      color: const Color.fromARGB(84, 158, 158, 158))),
            ),
            TextField(
              controller: _email,
              decoration: InputDecoration(
                  hintText: 'email',
                  hintStyle: TextStyle(
                      color: const Color.fromARGB(84, 158, 158, 158))),
            ),
            TextField(
              controller: _message,
              decoration: InputDecoration(
                  hintText: 'message',
                  hintStyle: TextStyle(
                      color: const Color.fromARGB(84, 158, 158, 158))),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    String name = _name.text;
                    String email = _email.text;
                    String message = _message.text;

                    var url = Uri.parse('http://localhost:3000');
                    var response = await http.post(
                      url,
                      headers: {'content-type': 'application/json'},
                      body: jsonEncode(
                        {'name': name, 'email': email, 'message': message},
                      ),
                    );
                    if (response.statusCode == 200) {
                      var json = jsonDecode(response.body);
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text("Succès"),
                          content: Text(json['message']),
                        ),
                      );
                    } else {
                      print("Erreur : ${response.statusCode}");
                    }
                  },
                  child: Text('send'),
                ),
                SizedBox(width: 40),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('watch'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
