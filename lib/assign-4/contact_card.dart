import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class ContactCard extends StatefulWidget {
  const ContactCard({super.key});

  @override
  State<ContactCard> createState() => _ContactCardState();
}

List<Map<String, dynamic>> contactList = [];

class _ContactCardState extends State<ContactCard> {
  final _formkey = GlobalKey<FormState>();
  final uudi = Uuid();

  TextEditingController _name = TextEditingController();
  TextEditingController _id = TextEditingController();
  TextEditingController _number = TextEditingController();

  bool IsValidated = false;

  void _CondValid() {
    setState(() {
      IsValidated = _number.text.isNotEmpty &&
          _number.text.length == 9 &&
          _name.text.isNotEmpty &&
          _name.text.length == 15;
    });
  }

  @override
  void initState() {
    super.initState();
    _number.addListener(_CondValid);
    _name.addListener(_CondValid);
  }

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _number.dispose();
    _id.dispose();
  }

  Future<void> PostContact() async {
    final uudi = Uuid();
    String name = _name.text;
    String id = uudi.v4();
    String number = _number.text;
    final url = Uri.parse('http://localhost:3000');
    var response = await http.post(
      url,
      headers: {'content-type': 'application/json'},
      body: jsonEncode(
        {'name': name, 'id': id, 'number': number},
      ),
    );
    _name.clear();
    _number.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        autovalidateMode: AutovalidateMode.always,
        key: _formkey,
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            children: [
              TextFormField(
                controller: _name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'enter the name';
                  }
                  if (value.length != 15) {
                    return 'the name must be EXACTLY 15 character';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _number,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'enter the phone number';
                  }
                  if (value.length != 9) {
                    return 'Number should be exactly 9 digits';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: IsValidated ? PostContact : null,
                    child: Text('send'),
                  ),
                  SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DetailsList()),
                      );
                    },
                    child: Text('More'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailsList extends StatefulWidget {
  const DetailsList({super.key});

  @override
  State<DetailsList> createState() => _DetailsListState();
}

class _DetailsListState extends State<DetailsList> {
  @override
  void initState() {
    super.initState();
    GetContact(); // ← tu l'as oubliée ici
  }

  bool isLoading = true;
  Future<void> GetContact() async {
    final url = Uri.parse('http://localhost:3000');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        contactList = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } else {
      setState(() {
        contactList = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: ListView.builder(
        itemCount: contactList.length,
        itemBuilder: (context, index) {
          final contact = contactList[index];
          return Padding(
            padding: const EdgeInsets.all(28.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DisplayList(contact: contact),
                  ),
                );
              },
              child: Container(
                width: screenWidth * 0.8,
                height: screenHeight * 0.18,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color.fromARGB(255, 0, 36, 65),
                  ),
                ),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('${contact['name']}'),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 50.0),
                          child: Text('${contact['id']}'),
                        ),
                      ],
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DisplayList(
                                contact: contact,
                              ),
                            ),
                          );
                        },
                        child: Icon(CupertinoIcons.arrow_right),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class DisplayList extends StatefulWidget {
  final Map<String, dynamic> contact;
  DisplayList({super.key, required this.contact});

  @override
  State<DisplayList> createState() => _DisplayListState();
}

class _DisplayListState extends State<DisplayList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contact Info')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${widget.contact['name']}'),
            Text('ID: ${widget.contact['id']}'),
            Text('Number: ${widget.contact['number']}'),
          ],
        ),
      ),
    );
  }
}
