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

///////////////////// second page ... ////////////////////////////////////////
class Storecont extends StatefulWidget {
  final List<Map<String, dynamic>> info;
  const Storecont({super.key, required this.info});

  @override
  State<Storecont> createState() => _StorecontState();
}

class _StorecontState extends State<Storecont> {
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;
  List<Map<String, dynamic>> filteredItems = [];

  @override
  void initState() {
    super.initState();
    getInfos();
    searchController.addListener(_filterItems);
  }

  void _filterItems() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredItems = infos.where((item) {
        final name = item['name']?.toLowerCase() ?? '';
        final email = item['email']?.toLowerCase() ?? '';
        return name.contains(query) || email.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> getInfos() async {
    final url = Uri.parse('http://localhost:3000/users');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        infos = List<Map<String, dynamic>>.from(data);
        filteredItems = infos;
        isLoading = false;
      });
    } else {
      setState(() {
        infos = [];
        filteredItems = [];
        isLoading = false;
      });
    }
  }

  Future<void> DeleteUser(String id) async {
    final url = Uri.parse('http://localhost:3000/users/$id');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      print('users deleted');
      await getInfos();
      _filterItems();
    } else {
      print('error!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Rechercher...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            Icon(Icons.search),
          ],
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final info = filteredItems[index];
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ID: ${info['id']}'),
                            Text('Nom: ${info['name']}'),
                            Text('Email: ${info['email']}'),
                          ],
                        ),
                        Spacer(),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: const Color.fromARGB(202, 59, 58, 58),
                              ),
                              onPressed: () {
                                //DeleteUser(info['id']);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditPage(
                                      id: '${info['id']}',
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(width: 20),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                DeleteUser(info['id']);
                                // je gache mon potentiel ici a iut ....
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class EditPage extends StatefulWidget {
  final String id;
  const EditPage({super.key, required this.id});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController _editname = TextEditingController();
  TextEditingController _editemail = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: _editname,
          ),
          TextField(
            controller: _editemail,
          ),
          SizedBox(
            height: 20,
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'Validated',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
