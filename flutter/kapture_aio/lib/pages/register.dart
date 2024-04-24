// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:kapture_aio/localization/i18n.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _imgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: I18n.email,
              ),
            ),
            TextField(
              controller: _displayNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Display Name',
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: I18n.password,
              ),
            ),
            TextField(
              controller: _imgController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Image URL',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final response = await http.post(
                  Uri.parse('http://${dotenv.env['FLASK']}/register'),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, String>{
                    'username': _usernameController.text,
                    'displayname': _displayNameController.text,
                    'email': _emailController.text,
                    'password': _passwordController.text,
                    'img': _imgController.text,
                  }),
                );
                print(jsonEncode(<String, String>{
                    'username': _usernameController.text,
                    'displayname': _displayNameController.text,
                    'email': _emailController.text,
                    'password': _passwordController.text,
                    'img': _imgController.text,
                  }));
                if (response.statusCode == 200) {
                  if(response.body == 'success'){
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.green,
                          title: const Text('Success'),
                          content: const Text('You have registered successfully.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.pop(context);
                              },
                              child: const Text('OK', style: TextStyle(fontSize: 22)),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.red,
                          title: const Text('Failed'),
                          content: const Text('Username or Email is already used.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK', style: TextStyle(fontSize: 22)),
                            ),
                          ],
                        );
                      },
                    );
                  }
                } else {
                  // If the server returns an unexpected response,
                  // then throw an exception.
                  throw Exception('Connection Error');
                }
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}