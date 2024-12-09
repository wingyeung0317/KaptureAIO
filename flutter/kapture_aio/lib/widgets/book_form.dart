import 'package:flutter/material.dart';
import '../api.dart';
import '../widgets/input_box.dart';
import 'package:validators/validators.dart'; //flutter pub add validators

class BookForm extends StatefulWidget {
  final int mode;
  final int bookId;
  const BookForm({super.key, required this.mode, this.bookId = 0});
  @override
  State<BookForm> createState() => _BookFormState();
}

class _BookFormState extends State<BookForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorsController = TextEditingController();
  final TextEditingController _publishersController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();

  String? _validateTitle(String? value) {
    if (value == null || value.isEmpty) return 'Title cannot be empty.';
    return null;
  }

  String? _validateAuthors(String? value) {
    if (value == null || value.isEmpty) return 'Authors cannot be empty.';
    return null;
  }

  String? _validatePublishers(String? value) {
    if (value == null || value.isEmpty) return 'Publishers cannot be empty.';
    return null;
  }

  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) return 'Date cannot be empty.';
    if (!isDate(value)) return 'The date format is not valid (YYYY-MM-DD).';
    return null;
  }

  String? _validateISBN(String? value) {
    if (value == null || value.isEmpty) return 'ISBN cannot be empty.';
    if (value.length != 17) return 'The length of ISBN must be equal to 17.';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(key: _formKey, child: _buildWidgets(context));
  }

  Widget _buildWidgets(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputBox(
            name: "Title",
            hint: "e.g. Harry Potter and the Philosopher's Stone",
            controller: _titleController,
            validator: _validateTitle,
          ),
          InputBox(
            name: "Authors",
            hint: "e.g. J. K. Rowling",
            controller: _authorsController,
            validator: _validateAuthors,
          ),
          InputBox(
            name: "Publishers",
            hint: "e.g. Bloomsbury (UK)",
            controller: _publishersController,
            validator: _validatePublishers,
          ),
          InputBox(
            name: "Date (YYYY-MM-DD)",
            hint: "e.g. 1997-06-26",
            controller: _dateController,
            validator: _validateDate,
          ),
          InputBox(
            name: "ISBN",
            hint: "e.g. 978-0-7475-3269-9",
            controller: _isbnController,
            validator: _validateISBN,
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
                    if (widget.mode == 0) {
                      addBook();
                    } else {
                      updateBook();
                    }
                  }
                },
                child: const Text('Submit'),
              )),
        ]);
  }

  Future<void> addBook() async {
    bool result = await apiAddBook(
        _titleController.text,
        _authorsController.text,
        _publishersController.text,
        _dateController.text,
        _isbnController.text);
    String message = 'Failed to submit the book record.';
    if (result == true) {
      message = 'The record has been successfully submitted.';
      Navigator.of(context).pushNamed("/booklist");
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> updateBook() async {
    bool result = await apiUpdateBook(
        widget.bookId,
        _titleController.text,
        _authorsController.text,
        _publishersController.text,
        _dateController.text,
        _isbnController.text);
    String message = 'Failed to update the book record.';
    if (result == true) {
      message = 'The record has been successfully updated.';
      Navigator.of(context).pushNamed("/booklist");
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
