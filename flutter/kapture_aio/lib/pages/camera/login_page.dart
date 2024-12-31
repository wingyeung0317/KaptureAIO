import 'package:flutter/material.dart';
import '../../widgets/input_box.dart';
import '../../cookie.dart';
import '../../api.dart';

class CameraLoginPage extends StatefulWidget {
  const CameraLoginPage({super.key});
  @override
  State<CameraLoginPage> createState() => _CameraLoginPageState();
}

class _CameraLoginPageState extends State<CameraLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isRememberMeChecked = false; // store the state of checkbox
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                width: 600,
                height: 500,
                child: Form(key: _formKey, child: _buildWidgets(context)))));
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) return 'Username cannot be empty.';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password cannot be empty.';
    return null;
  }

  Widget _buildWidgets(BuildContext context) {
    try {
      final cookieMap = getCookie();
      int remember = cookieMap.containsKey("remember")
          ? int.parse(cookieMap["remember"]!)
          : 0;
      if (remember > 0) {
        _usernameController.text = cookieMap["remember_username"]!;
        _passwordController.text = cookieMap["remember_password"]!;
      }
    } catch (e) {
      print(e);
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        margin: EdgeInsets.only(left: 20, top: 40, bottom: 10, right: 20),
        child: Text("Login",
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
      Container(
        margin: EdgeInsets.only(left: 20, top: 0, bottom: 0, right: 20),
        alignment: Alignment.centerLeft,
        child: Row(children: [
          Checkbox(
              value: isRememberMeChecked,
              onChanged: (bool? value) {
                setState(() {
                  isRememberMeChecked = value!;
                });
              }),
          Text("Remember me",
              style: TextStyle(fontSize: 12, color: Colors.grey)),
        ]),
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
                if (isRememberMeChecked) {
                  setCookie("remember", "1");
                  setCookie("remember_username", _usernameController.text);
                  setCookie("remember_password", _passwordController.text);
                } else {
                  setCookie("remember", "0");
                }
                login();
              }
            },
            child: const Text('Login'),
          )),
      Container(
          margin: EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
          alignment: Alignment.centerLeft,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                textStyle: const TextStyle(fontSize: 14)),
            onPressed: () {
              Navigator.of(context).pushNamed("/camera/register");
            },
            child: const Text('Register'),
          )),
    ]);
  }

  void login() async {
    String message = 'Failed to login your account';

    if (await apiLogin(_usernameController.text, _passwordController.text)) {
      message = 'Successfully login to your account.';
      setCookie("logged_in_user", _usernameController.text); // 設置登錄用戶名到 cookies
      Navigator.of(context).pushNamed("/camera/home");
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
