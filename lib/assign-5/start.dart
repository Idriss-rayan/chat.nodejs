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
  bool isValidated = false;

  void _condValid() {
    setState(() {
      isValidated = _name.text.isNotEmpty && _email.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _name.addListener(_condValid);
    _email.addListener(_condValid);
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> postUsers() async {
    String name = _name.text;
    String email = _email.text;

    final url = Uri.parse('http://localhost:3000/users');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email}),
    );

    if (response.statusCode == 201) {
      _name.clear();
      _email.clear();
      setState(() {
        isValidated = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: _name,
                    decoration: InputDecoration(labelText: 'Nom'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Entrer le nom' : null,
                  ),
                  TextFormField(
                    controller: _email,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Entrer l\'email'
                        : null,
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: isValidated ? postUsers : null,
                        child: Text('Envoyer'),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Storecont(info: infos),
                            ),
                          );
                        },
                        child: Text('Voir les utilisateurs'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
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
      setState(() {
        infos = [];
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getInfos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: [
          Text('Utilisateurs'),
          Spacer(),
          InkWell(
            onTap: () {},
            child: Icon(Icons.search),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20),
          )
        ],
      )),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: infos.length,
              itemBuilder: (context, index) {
                final info = infos[index];
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID: ${info['id']}'),
                        Text('Nom: ${info['name']}'),
                        Text('Email: ${info['email']}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
