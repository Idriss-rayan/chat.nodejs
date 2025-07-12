import 'dart:convert';

import 'package:chat/assign-3/geth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Listcont extends StatefulWidget {
  const Listcont({super.key});

  @override
  State<Listcont> createState() => _ListcontState();
}

class _ListcontState extends State<Listcont> {
  bool isvalid = false;
  final _formKey = GlobalKey<FormState>();

  void _checkFormValid() {
    setState(() {
      isvalid =
          _number.text.length == 9 && RegExp(r'^\d+$').hasMatch(_number.text);
    });
  }

  @override
  void initState() {
    super.initState();
    _number.addListener(_checkFormValid);
  }

  @override
  void dispose() {
    _number.dispose();
    super.dispose();
  }

  Future<void> PostContact() async {
    String number = _number.text;
    final url = Uri.parse('http://localhost:3000');
    var response = await http.post(
      url,
      headers: {'content-type': 'application/json'},
      body: jsonEncode({'number': number}),
    );
  }

  final TextEditingController _number = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          children: [
            TextFormField(
              controller: _number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'remplicez ce champ';
                }
                if (value.length != 9 || !RegExp(r'^\d+$').hasMatch(value)) {
                  return 'Doit contenir exactement 9 chiffres';
                }
                return null;
              },
            ),
            SizedBox(height: 14),
            Row(
              children: [
                ElevatedButton(
                  onPressed: isvalid ? PostContact : null,
                  child: Text('send'),
                ),
                SizedBox(width: 14),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Geth(),
                      ),
                    );
                  },
                  child: Text('More'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
