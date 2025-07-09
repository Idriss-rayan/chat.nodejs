import 'package:chat/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<User> users = [];

  final nameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final url =
        Uri.parse('http://localhost:3000/api/users'); // Pour Android Emulator
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        users = data.map((json) => User.fromJson(json)).toList();
      });
    }
  }

  Future<void> addUser(String name, String email) async {
    final url = Uri.parse('http://localhost:3000/api/users');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'email': email}),
    );

    if (response.statusCode == 201) {
      final newUser = User.fromJson(json.decode(response.body));
      setState(() {
        users.add(newUser);
        nameController.clear();
        emailController.clear();
      });
    } else {
      throw Exception('Échec de l’ajout');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Utilisateurs')),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nom'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  final email = emailController.text.trim();
                  if (name.isNotEmpty && email.isNotEmpty) {
                    addUser(name, email);
                  }
                },
                child: Text('Ajouter'),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      title: Text(user.name),
                      subtitle: Text(user.email),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
