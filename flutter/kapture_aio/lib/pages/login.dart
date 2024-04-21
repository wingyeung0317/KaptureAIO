// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Login extends Container {
  Login({super.key});

  void login() {
    // Todo: Add your login logic here
  }
  void register() {
    // Todo: Add your registration logic here
  }

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: 
        Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: Text('Login', style: TextStyle(fontSize: 30)),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () {
                    login();
                  },
                  child: Text('Login'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () {
                    // Call the register function when the button is pressed
                    register();
                  },
                  child: Text('Register'),
                ),
              ),
            ],
          ),
        ],
      )
    );
  }
}