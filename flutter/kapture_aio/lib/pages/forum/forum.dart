import 'package:kapture_aio/constant/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForumPage extends StatefulWidget {
  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  List<dynamic> forums = [];
  String titleVariable = '';
  String contentVariable = '';

  @override
  void initState() {
    super.initState();
    fetchForums();
  }

  Future<void> fetchForums() async {
    final response = await http.get(Uri.parse('http://192.168.1.100:5000/getforum'));
    if (response.statusCode == 200) {
      print(response.body.toString());
      forums = jsonDecode(response.body);
      forums = forums.toList();
      for (var i in forums) {
        print(i);
      }
      setState(() {});
    } else {
      throw Exception('Failed to load forums');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(onTapDown:(details) => fetchForums(), child:ListView(reverse: true, children: [
        for (var i in forums)
          Card(color: Color.fromARGB(255, 221, 252, 244), child: ListTile(
            title: Text(i[2], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            subtitle: MarkdownBody(data:"${i[3]}\n\n`by: ${i[1]}`\\\n`${i[0]}`"),
            onTap: () {
              // Navigate to forum detail page
            },
          ),)
        ],
      ),),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add a new forum'),
                content: Column(children: [
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Enter forum name',
                    ),
                    // Store the input value to a variable
                    onChanged: (value) {
                      // store value to a variable
                      titleVariable = value;
                    },
                  ),
                  Expanded(child: TextFormField(
                    maxLines: null,
                    expands: true,
                    decoration: InputDecoration(
                      hintText: 'Enter forum content (Allow MarkDown format)',
                    ),
                    // Store the input value to a variable
                    onChanged: (value) {
                      // store value to a variable
                      contentVariable = value;
                    },
                  ))
                ],),
                actions: <Widget>[
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Submit'),
                    onPressed: () async {
                      // Add your submit logic here
                      final forumInfo = {
                        'writer': globals.userid,
                        'title': titleVariable,
                        'content': contentVariable,
                      };

                      final response = await http.post(
                        Uri.parse('http://192.168.1.100:5000/writeforum'),
                        headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                        body: jsonEncode(forumInfo),
                      );

                      if (response.statusCode == 200) {
                        print(response.body.toString());
                        // Handle success
                      } else {
                        throw Exception('Failed to create forum');
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
          fetchForums();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}