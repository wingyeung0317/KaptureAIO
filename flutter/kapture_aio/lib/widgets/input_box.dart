import 'package:flutter/material.dart';

class InputBox extends StatefulWidget {
  final String name;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  InputBox(
      {super.key,
      required this.name,
      required this.hint,
      required this.controller,
      this.validator,
      this.obscureText = false});
  @override
  State<InputBox> createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
          child: Text(
            widget.name,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
            margin: EdgeInsets.only(left: 20, top: 0, bottom: 10, right: 20),
            alignment: Alignment.centerLeft,
            child: TextFormField(
              obscureText: _obscureText,
              controller: widget.controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: widget.hint,
                suffixIcon: widget.obscureText
                    ? IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      )
                    : null,
              ),
              validator: widget.validator,
              obscuringCharacter: '*',
            )),
      ],
    );
  }
}
