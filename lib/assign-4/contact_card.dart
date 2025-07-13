import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class ContactCard extends StatefulWidget {
  const ContactCard({super.key});

  @override
  State<ContactCard> createState() => _ContactCardState();
}

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
          _name.text.isNotEmpty;
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
      headers: {'content-type': 'aplication/json'},
      body: jsonEncode(
        {'name': name, 'id': id, 'number': number},
      ),
    );
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
                  if (value.length <= 15) {
                    return 'the name must be EXACTLY 15 character';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _number,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'enter the phone number';
                  }
                  if (value.length < 10 || value.length > 10) {
                    return 'number should be 9 character';
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
                          MaterialPageRoute(
                              builder: (context) => DetailsList()),
                        );
                      },
                      child: Text('More')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DetailsList extends StatelessWidget {
  const DetailsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ListView.builder(itemBuilder: (context, build) {}));
  }
}
