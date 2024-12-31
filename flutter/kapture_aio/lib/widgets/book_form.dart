import 'package:flutter/material.dart';
import '../api.dart';
import '../widgets/input_box.dart';

class CameraForm extends StatefulWidget {
  final int mode;
  final int cameraId;
  const CameraForm({super.key, required this.mode, this.cameraId = 0});
  @override
  State<CameraForm> createState() => _CameraFormState();
}

class _CameraFormState extends State<CameraForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  String? _validateBrand(String? value) {
    if (value == null || value.isEmpty) return 'Brand cannot be empty.';
    return null;
  }

  String? _validateModel(String? value) {
    if (value == null || value.isEmpty) return 'Model cannot be empty.';
    return null;
  }

  String? _validateDescription(String? value) {
    if (value == null || value.isEmpty) return 'Description cannot be empty.';
    return null;
  }

  String? _validateStatus(String? value) {
    if (value == null || value.isEmpty) return 'Status cannot be empty.';
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
            name: "Brand",
            hint: "e.g. Canon",
            controller: _brandController,
            validator: _validateBrand,
          ),
          InputBox(
            name: "Model",
            hint: "e.g. EOS 5D",
            controller: _modelController,
            validator: _validateModel,
          ),
          InputBox(
            name: "Description",
            hint: "e.g. Full-frame DSLR",
            controller: _descriptionController,
            validator: _validateDescription,
          ),
          InputBox(
            name: "Status",
            hint: "e.g. Available",
            controller: _statusController,
            validator: _validateStatus,
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
                      addCamera();
                    } else {
                      updateCamera();
                    }
                  }
                },
                child: const Text('Submit'),
              )),
        ]);
  }

  Future<void> addCamera() async {
    bool result = await apiAddCamera(
        _brandController.text,
        _modelController.text,
        _descriptionController.text,
        _statusController.text);
    String message = 'Failed to submit the camera record.';
    if (result == true) {
      message = 'The record has been successfully submitted.';
      Navigator.of(context).pushNamed("/camera/cameralist");
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> updateCamera() async {
    bool result = await apiUpdateCamera(
        widget.cameraId,
        _brandController.text,
        _modelController.text,
        _descriptionController.text,
        _statusController.text);
    String message = 'Failed to update the camera record.';
    if (result == true) {
      message = 'The record has been successfully updated.';
      Navigator.of(context).pushNamed("/camera/cameralist");
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
