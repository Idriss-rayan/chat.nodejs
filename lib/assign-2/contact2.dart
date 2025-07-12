import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Contact2 extends StatefulWidget {
  const Contact2({super.key});

  @override
  State<Contact2> createState() => _Contact2State();
}

class _Contact2State extends State<Contact2> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _message = TextEditingController();

  bool isFormValid = false;

  void _checkFormValid() {
    setState(() {
      isFormValid = _name.text.isNotEmpty &&
          _email.text.isNotEmpty &&
          _message.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _name.addListener(_checkFormValid);
    _email.addListener(_checkFormValid);
    _message.addListener(_checkFormValid);
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _message.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Tous les champs sont valides
      // print('Nom: ${_name.text}');
      // print('Email: ${_email.text}');
      // print('Message: ${_message.text}');
      // ici tu peux ajouter http.post(...)
    }
  }

  Future<void> postinfos() async {
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
          title: Text(json['status']),
          content: Text(json['message']),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Formulaire de Contact')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                controller: _name,
                decoration: InputDecoration(labelText: 'Nom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le nom est requis';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _email,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'L’email est requis';
                  } else if (!value.contains('@')) {
                    return 'Entrez un email valide';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _message,
                decoration: InputDecoration(labelText: 'Message'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le message est requis';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: isFormValid ? postinfos : null,
                //onPressed: isFormValid ? _submitForm : null,
                child: const Text('Envoyer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
