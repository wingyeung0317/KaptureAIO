// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:kapture_aio/constant/globals.dart' as globals;
import 'package:kapture_aio/localization/i18n.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  final Function updateHomeState;
  const LoginPage({required this.updateHomeState});
  @override
  _LoginPageState createState() => _LoginPageState(updateHomeState: updateHomeState);
}

class _LoginPageState extends State<LoginPage> {
  final Function updateHomeState;
  _LoginPageState({required this.updateHomeState});
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> login() async {
    print(jsonEncode(<String, String>{
        'username': _usernameController.text,
        'password': _passwordController.text,
      }));
    final response = await http.post(
      Uri.parse('http://${dotenv.env['FLASK']}/login'),
      body: jsonEncode(<String, String>{
        'username': _usernameController.text,
        'password': _passwordController.text,
      }),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      print(jsonDecode(response.body));
        if (jsonDecode(response.body)['status'] == 'success') {
          setState(() {
          // update globals id, username, displayname, email, role
            globals.isLoggedIn = true;
            globals.userid = jsonDecode(response.body)['id'];
            globals.username = jsonDecode(response.body)['username'];
            globals.displayname = jsonDecode(response.body)['displayname'];
            globals.email = jsonDecode(response.body)['email'];
            globals.userimg = jsonDecode(response.body)['img'];
            globals.role = globals.setRole(jsonDecode(response.body)['role']);
            globals.pageIndex = 3;
          });
          updateHomeState();
        } else {
          // If the server returns an unsuccessful response code, throw an exception.
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.red,
                  title: const Text('Failed'),
                  content: Text(I18n.loginFailed),
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
          throw Exception('Failed to login');
        }
    } else {
      // If the server returns an unsuccessful response code, throw an exception.
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.red,
              title: const Text('Failed'),
              content: const Text('Connection failed.'),
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
      throw Exception('Connection Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: login,
                    child: Text(I18n.login),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  child: const Text('Register'),
                ),
              ],
            ),
          ],
        ),
      );
  }
}