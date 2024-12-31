import 'package:flutter/material.dart';
import '../../widgets/input_box.dart';
import '../../api.dart';

class CameraRegisterPage extends StatefulWidget {
  const CameraRegisterPage({super.key});
  @override
  State<CameraRegisterPage> createState() => _CameraRegisterPageState();
}

class _CameraRegisterPageState extends State<CameraRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatedPasswordController = TextEditingController();

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) return 'Username cannot be empty.';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password cannot be empty.';
    return null;
  }

  String? _validateRepeatedPassword(String? value) {
    if (value == null || value.isEmpty) return 'Repeated password cannot be empty.';
    if (value != _passwordController.text) return 'Passwords do not match.';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                width: 600,
                height: 600,
                child: Form(key: _formKey, child: _buildWidgets(context)))));
  }

  Widget _buildWidgets(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        margin: EdgeInsets.only(left: 20, top: 40, bottom: 10, right: 20),
        child: Text("Register",
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            )),
      ),
      InputBox(
        name: "Username",
        hint: "e.g. chantaiman",
        controller: _usernameController,
        validator: _validateUsername,
      ),
      InputBox(
        name: "Password",
        hint: "Enter 8 characters or more",
        controller: _passwordController,
        validator: _validatePassword,
        obscureText: true,
      ),
      InputBox(
        name: "Repeat Password",
        hint: "Enter the same password",
        controller: _repeatedPasswordController,
        validator: _validateRepeatedPassword,
        obscureText: true,
      ),
      Container(
          margin: EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
          alignment: Alignment.centerLeft,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                textStyle: const TextStyle(fontSize: 14)),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                register();
              }
            },
            child: const Text('Register'),
          )),
      Container(
          margin: EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
          alignment: Alignment.centerLeft,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                textStyle: const TextStyle(fontSize: 14)),
            onPressed: () {
              Navigator.of(context).pushNamed("/camera/login");
            },
            child: const Text('Back to Login'),
          )),
    ]);
  }

  void register() async {
    String message = 'Failed to register your account';

    if (await apiRegister(_usernameController.text, _passwordController.text, _repeatedPasswordController.text)) {
      message = 'Successfully registered your account.';
      Navigator.of(context).pushNamed("/camera/login");
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}