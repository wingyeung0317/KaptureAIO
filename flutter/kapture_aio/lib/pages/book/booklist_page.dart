import 'package:flutter/material.dart';
import '../../widgets/book_form.dart';
import '../../widgets/navigation_frame.dart';
import '../../api.dart';
import '../../cookie.dart';

class BooklistPage extends StatefulWidget {
  List<Map<String, dynamic>> booklist = [
    {
      "title": "Book 1",
      "authors": "David Wong",
      "publishers": "Publisher A",
      "date": "1995-05-01",
      "isbn": "123-4-5678-90123-4",
      "status": "1",
    },
    {
      "title": "Book 2",
      "authors": "Tom Lee",
      "publishers": "Publisher B",
      "date": "1995-07-02",
      "isbn": "123-4-5678-90123-5",
      "status": "0",
    },
    {
      "title": "Book 3",
      "authors": "Peter Chan",
      "publishers": "Publisher C",
      "date": "1995-09-10",
      "isbn": "123-4-5678-90123-6",
      "status": "1",
    },
  ];
  BooklistPage({super.key});
  @override
  State<BooklistPage> createState() => _BooklistPageState();
}

class _BooklistPageState extends State<BooklistPage> {
  @override
  Widget build(BuildContext context) {
    apiGetAllBooks(); //<<<< try your api functio
    return NavigationFrame(
      selectedIndex: 2,
      child: Padding(
          padding: EdgeInsets.all(10),
          child: FutureBuilder<List<dynamic>>(
            //List<dynamic> is json data
            future: apiGetAllBooks(), //<<<< try your api function
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  //error
                  return Text("Error: ${snapshot.error}");
                } else {
                  //success
                  return createBookLists(snapshot.data!);
                }
              } else {
                //loading
                return CircularProgressIndicator();
              }
            },
          )),
    );
  }

  Widget createBookLists(List<dynamic> books) {
    return ListView(
        children: [for (var book in books!) createSingleBookRecord(book)]);
  }

  Widget createSingleBookRecord(Map<String, dynamic> book) {
    Map<String, String> cookieMap = getCookie();
    int is_admin = int.parse(cookieMap['is_admin']!);
    return Card(
      child: ListTile(
        enabled: int.parse(book["status"]) == 0 ? true : false, //check status
        onTap: () {
          popupBorrowDialog(book);
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
        trailing: is_admin == 1
            ? Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    if (int.parse(book["status"]) == 0) popupUpdateDialog(book);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    if (int.parse(book["status"]) == 0)
                      popupDeletewDialog(book);
                  },
                ),
              ])
            : Container(width: 50),
      ),
    );
  }

  void popupBorrowDialog(Map<String, dynamic> book) {
    final now = DateTime.now();
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Reserve Book'),
              content: Container(
                  height: 150,
                  child: Column(
                    children: [
                      Text(
                          'Do you want to reserve the book with following details?'),
                      Container(height: 30),
                      Container(
                          width: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Date: " + now.toString()),
                              Text("Title: " + book["title"]),
                              Text("Publishers: " + book["publishers"]),
                              Text("ISBN: " + book["isbn"]),
                              Text("Borrower: " + "Me"),
                            ],
                          ))
                    ],
                  )),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    borrowBook(int.parse(book["book_id"]));
                    Navigator.pop(context, 'Yes');
                  },
                  child: const Text('Yes'),
                ),
              ],
            ));
  }

  void popupUpdateDialog(Map<String, dynamic> book) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Update Book'),
              content: Container(
                  width: 400,
                  height: 400,
                  child: SingleChildScrollView(
                      child: BookForm(
                          mode: 1, bookId: int.parse(book['book_id'])))),
            ));
  }

  void popupDeletewDialog(Map<String, dynamic> book) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Delete Book'),
              content:
                  Text('Do you really want to delete ' + book["title"] + '?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    deleteBook(int.parse(book["book_id"]));
                    Navigator.pop(context, 'Confirm');
                  },
                  child: const Text('Confirm'),
                ),
              ],
            ));
  }

  Future<void> deleteBook(int bookId) async {
    String message = "Failed to delete the book.";
    if (await apiDeleteBook(bookId) == true) {
      message = "The book has been deleted successfully.";
      Navigator.of(context).pushNamed("/booklist");
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> borrowBook(int bookId) async {
    String message = "Failed to borrow the book.";
    if (await apiBorrowBook(bookId) == true) {
      message = "The book has been borrowed successfully.";
      Navigator.of(context).pushNamed("/booklist");
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
