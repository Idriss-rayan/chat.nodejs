import 'dart:convert';

import 'package:chat/assign-6/users.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TodoStart extends StatefulWidget {
  const TodoStart({super.key});

  @override
  State<TodoStart> createState() => _TodoStartState();
}

class _TodoStartState extends State<TodoStart> {
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  late List<Users> users = [];

  Future<void> PostUser() async {
    final user = Users();
    String name = _name.text;
    String email = _email.text;

    final url = Uri.parse('http://localhost:3000');
    final response = await http.post(
      url,
      headers: {'content-type': 'application/json'},
      body: jsonEncode(
        {
          'id': user.id,
          'name': user.name,
          'email': user.email,
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: _name,
          ),
          SizedBox(height: 20),
          TextField(
            controller: _email,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final NewUser = Users()
                ..name = _name.text
                ..email = _email.text;
              setState(() {
                users.add(NewUser);
              });
              PostUser();
            },
            child: Text('send'),
          ),
        ],
      ),
    );
  }
}
