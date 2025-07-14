import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

List<Map<String, dynamic>> infos = [];

class _StartState extends State<Start> {
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  bool IsValidated = false;

  void _CondValid() {
    IsValidated = _name.text.isNotEmpty;
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
  }

  @override
  void iniState() {
    super.initState();
    _name.addListener(_CondValid);
    _email.addListener(_CondValid);
  }

  Future<void> PostUsers() async {
    String name = _name.text;
    String email = _email.text;
    String id = '';
    final url = Uri.parse('http://localhost:3000/user');
    var response = await http.post(
      url,
      headers: {'content-type': 'application/json'},
      body: jsonEncode(
        {'id': id, 'name': name, 'email': email},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Form(
            child: Column(
              children: [
                TextFormField(
                  controller: _name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'ente the name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'ente the mail';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: IsValidated ? PostUsers : null,
                      child: Text('send'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Storecont(info: infos),
                          ),
                        );
                      },
                      child: Text('see'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Storecont extends StatefulWidget {
  final List<Map<String, dynamic>> info;
  const Storecont({super.key, required this.info});

  @override
  State<Storecont> createState() => _StorecontState();
}

class _StorecontState extends State<Storecont> {
  bool isLoading = true;
  Future<void> getInfos() async {
    final url = Uri.parse('http://localhost:3000/users');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        infos = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } else {
      infos = [];
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: infos.length,
          itemBuilder: (context, index) {
            final info = infos[index];
            return Padding(
              padding: const EdgeInsets.all(28.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black),
                ),
                width: double.infinity,
                height: 200,
                child: Column(
                  children: [
                    Text('${info['id']}'),
                    Text('${info['name']}'),
                    Text('${info['email']}'),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
