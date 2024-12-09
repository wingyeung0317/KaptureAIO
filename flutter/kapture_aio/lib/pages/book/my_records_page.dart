import 'package:flutter/material.dart';
import '../../widgets/navigation_frame.dart';
import '../../api.dart';

class MyRecordsPage extends StatefulWidget {
  List<Map<String, dynamic>> booklist = [];

  MyRecordsPage({super.key});

  @override
  State<MyRecordsPage> createState() => _MyRecordsPageState();
}

class _MyRecordsPageState extends State<MyRecordsPage> {
  @override
  Widget build(BuildContext context) {
    return NavigationFrame(
        selectedIndex: 3,
        child: Padding(
            padding: EdgeInsets.all(10),
            child: FutureBuilder<List<dynamic>>(
              future: apiGetMyRecords(), //api function
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    //error
                    return Text("Error: ${snapshot.error}");
                  } else {
                    //success
                    return snapshot.data!.length > 0
                        ? ListView(
                            children: [
                              for (var book in snapshot.data!)
                                createBookRecord(book)
                            ],
                          )
                        : Text("No records found.",
                            style: TextStyle(fontSize: 16));
                  }
                } else {
                  //loading
                  return CircularProgressIndicator();
                }
              },
            )));
  }

  Widget createBookRecord(Map<String, dynamic> book) {
    return Card(
      child: ListTile(
        onTap: () {
          popupReturnDialog(book);
        },
        leading: Icon(Icons.book, size: 48),
        title:
            Text(book["title"], style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(book["authors"] +
            ", " +
            book['publishers'] +
            ", " +
            book["date"] +
            "\nISBN: " +
            book["isbn"]),
      ),
    );
  }

  void popupReturnDialog(Map<String, dynamic> book) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Return Book'),
              content: Text('Do you want to return ' + book["title"] + '?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    returnBook(int.parse(book["book_id"]));
                    Navigator.pop(context, 'Confirm');
                  },
                  child: const Text('Confirm'),
                ),
              ],
            ));
  }

  Future<void> returnBook(int bookId) async {
    String message = "Failed to return the book.";

    if (await apiReturnBook(bookId) == true) {
      message = "The book has been returned successfully.";

      Navigator.of(context).pushNamed("/myrecords");
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
